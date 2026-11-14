from typing import Self

import numpy as np
import pandas as pd

from apns.models import treinable_model


class KernelFuzzyKMeans(treinable_model.ITreinableModel):
    def __init__(
        self,
        n_clusters: int,
        random_state: int,
        m: float = 2.0,
        sigma2: float | None = None,
        n_init: int = 1,
        max_iter: int = 100,
        tol: float = 1e-5,
    ):
        self.n_clusters = n_clusters
        self.random_state = random_state
        self.m = m
        self.sigma2 = sigma2
        self.n_init = n_init
        self.max_iter = max_iter
        self.tol = tol
        self.membership_: np.ndarray | None = None
        self.labels_: np.ndarray | None = None
        self.objective_: float | None = None
        self.objective_history_: list[float] | None = None
        self.n_iter_: int | None = None
        self._x: np.ndarray | None = None
        self._kernel: np.ndarray | None = None
        self._weights: np.ndarray | None = None
        self._prototype_norms: np.ndarray | None = None
        self._gamma: float | None = None

    @classmethod
    def create(
        cls,
        n_clusters: int,
        random_state: int,
        m: float = 2.0,
        sigma2: float | None = None,
        n_init: int = 1,
        max_iter: int = 100,
        tol: float = 1e-5,
    ) -> Self:
        return cls(n_clusters, random_state, m, sigma2, n_init, max_iter, tol)

    def fit(self, x: pd.DataFrame | np.ndarray) -> Self:
        self._x = self._array(x)
        sigma2 = self.sigma2
        if sigma2 is None:
            sigma2 = float(np.var(self._x)) or 1.0
        self._gamma = 1 / (2 * sigma2)
        self._kernel = self._rbf_kernel(self._x, self._x)

        best = None
        for init in range(self.n_init):
            rng = np.random.default_rng(self.random_state + init)
            membership = rng.random((len(self._x), self.n_clusters))
            membership /= membership.sum(axis=1, keepdims=True)
            history = []

            for _ in range(self.max_iter):
                weights = membership**self.m
                distances, _ = self._distances(self._kernel, weights)
                membership = self._memberships(distances)
                weights = membership**self.m
                distances, norms = self._distances(self._kernel, weights)
                objective = float(np.sum(weights * distances))
                history.append(objective)

                if len(history) > 1 and abs(history[-2] - objective) <= self.tol:
                    break

            if best is None or objective < best[0]:
                best = objective, membership, weights, norms, history

        (
            self.objective_,
            self.membership_,
            self._weights,
            self._prototype_norms,
            self.objective_history_,
        ) = best
        self.n_iter_ = len(self.objective_history_)
        self.labels_ = np.argmax(self.membership_, axis=1)
        return self

    def predict(self, x: pd.DataFrame | np.ndarray) -> np.ndarray:
        samples = self._array(x)
        kernel = self._rbf_kernel(samples, self._x)
        distances, _ = self._distances(
            kernel,
            self._weights,
            np.ones(len(samples)),
            self._prototype_norms,
        )
        return np.argmax(self._memberships(distances), axis=1)

    def _distances(
        self,
        kernel: np.ndarray,
        weights: np.ndarray,
        diagonal: np.ndarray | None = None,
        prototype_norms: np.ndarray | None = None,
    ) -> tuple[np.ndarray, np.ndarray]:
        diagonal = np.diag(kernel) if diagonal is None else diagonal
        if prototype_norms is None:
            prototype_norms = np.array(
                [
                    self._prototype_norm(weights[:, cluster])
                    for cluster in range(self.n_clusters)
                ]
            )

        distances = np.empty((len(kernel), self.n_clusters))
        for cluster in range(self.n_clusters):
            cluster_weights = weights[:, cluster]
            if cluster_weights.sum() == 0:
                distances[:, cluster] = diagonal
                continue
            distances[:, cluster] = (
                diagonal
                - 2 * kernel @ cluster_weights / cluster_weights.sum()
                + prototype_norms[cluster]
            )
        return np.maximum(distances, 0), prototype_norms

    def _prototype_norm(self, weights: np.ndarray) -> float:
        total_weight = weights.sum()
        if total_weight == 0:
            return 0.0
        return float(weights @ self._kernel @ weights / total_weight**2)

    def _memberships(self, distances: np.ndarray) -> np.ndarray:
        zero = distances <= np.finfo(float).eps
        memberships = np.zeros_like(distances)
        rows_with_zero = zero.any(axis=1)
        memberships[rows_with_zero] = zero[rows_with_zero]
        memberships[rows_with_zero] /= memberships[rows_with_zero].sum(
            axis=1,
            keepdims=True,
        )

        nonzero = ~rows_with_zero
        inverse = distances[nonzero] ** (-1 / (self.m - 1))
        memberships[nonzero] = inverse / inverse.sum(axis=1, keepdims=True)
        return memberships

    def _rbf_kernel(self, x: np.ndarray, y: np.ndarray) -> np.ndarray:
        squared_distances = (
            np.sum(x**2, axis=1)[:, None] + np.sum(y**2, axis=1)[None, :] - 2 * x @ y.T
        )
        return np.exp(-self._gamma * np.maximum(squared_distances, 0))

    @staticmethod
    def _array(x: pd.DataFrame | np.ndarray) -> np.ndarray:
        if isinstance(x, pd.DataFrame):
            x = x.to_numpy()
        return np.asarray(x, dtype=float)
