from typing import Protocol, Self

import numpy as np
import pandas as pd


class ITreinableModel(Protocol):
    def fit(self, x: pd.DataFrame | np.ndarray) -> Self: ...


class IKMeansLikeModel(ITreinableModel, Protocol):
    objective_name: str

    @classmethod
    def create(cls, n_clusters: int, random_state: int) -> Self: ...

    def predict(self, x: pd.DataFrame | np.ndarray) -> np.ndarray: ...

    @property
    def n_iter(self) -> int | None: ...

    def compute_objective(self, x: pd.DataFrame | np.ndarray) -> float:
        """Implementation dependent objective function, smaller is better."""
        ...


class ITransductiveModel(ITreinableModel, Protocol):
    def fit_predict(self, x: pd.DataFrame | np.ndarray) -> np.ndarray: ...
