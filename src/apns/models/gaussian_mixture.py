from typing import Self

import numpy as np
import pandas as pd
import sklearn.mixture

from apns.models import treinable_model


class GaussianMixture(treinable_model.IKMeansLikeModel):
    """Mistura gaussiana (EM) com partição crisp pela posterior máxima."""

    objective_name = "-log-likelihood"

    def __init__(self, model: sklearn.mixture.GaussianMixture):
        self._model = model

    @classmethod
    def create(
        cls,
        n_clusters: int,
        random_state: int = 42,
        covariance_type: str = "full",
    ) -> Self:
        return cls(
            sklearn.mixture.GaussianMixture(
                n_components=n_clusters,
                covariance_type=covariance_type,  # pyright: ignore[reportArgumentType]
                n_init=1,
                random_state=random_state,
            )
        )

    def fit(self, x: pd.DataFrame | np.ndarray) -> Self:
        self._model.fit(x)
        return self

    def predict(self, x: pd.DataFrame | np.ndarray) -> np.ndarray:
        """Crisp with higher odds posteriori."""
        return self._model.predict(x)

    def log_likelihood(self, x: pd.DataFrame | np.ndarray) -> float:
        """Larger is better"""
        return float(self._model.score_samples(x).sum())

    def compute_objective(self, x: pd.DataFrame | np.ndarray) -> float:
        """Negative to follow the standard."""
        return -self.log_likelihood(x)

    def bic(self, x: pd.DataFrame | np.ndarray) -> float:
        """Bayesian Information Criterion (smaller is better)."""
        if isinstance(x, pd.DataFrame):
            return float(self._model.bic(x))
        return float(
            self._model.bic(np.asarray(x, dtype=float))
        )

    @property
    def covariance_type(self) -> str:
        return str(self._model.covariance_type)

    @property
    def n_iter(self) -> int:
        return int(self._model.n_iter_)
