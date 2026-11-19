from typing import Self

import fcmeans
import numpy as np
import pandas as pd
from scipy.spatial.distance import cdist

from apns.models import treinable_model


class KMeansFuzzy(treinable_model.IKMeansLikeModel):
    objective_name = "J_m"

    def __init__(self, model: fcmeans.FCM):
        self._model = model

    @classmethod
    def create(cls, n_clusters: int, random_state: int = 42, m=2) -> Self:
        return cls(
            fcmeans.FCM(
                n_clusters=n_clusters,
                random_state=random_state,
                m=m,
            )
        )

    def fit(self, x: pd.DataFrame | np.ndarray) -> Self:
        self._model.fit(np.asarray(x, dtype=float))
        return self

    def predict(self, x: pd.DataFrame | np.ndarray) -> np.ndarray:
        """Crisp by default."""
        return self._model.predict(np.asarray(x, dtype=float))

    def compute_objective(self, x: pd.DataFrame | np.ndarray) -> float:
        """J_m = Σ membership_ij^m · d²(x_i, c_j) (smaller is better)."""
        squared_distance = cdist(
            np.asarray(x, dtype=float), self._centers, "sqeuclidean"
        )
        return float(np.sum(self._memberships**self._m * squared_distance))

    @property
    def _memberships(self) -> np.ndarray:
        memberships = self._model.u
        assert memberships is not None
        return memberships

    @property
    def _centers(self) -> np.ndarray:
        centers = self._model.centers
        assert isinstance(centers, np.ndarray)
        return centers

    @property
    def _m(self) -> float:
        return self._model.m

    @property
    def n_iter(self) -> None:
        return None
