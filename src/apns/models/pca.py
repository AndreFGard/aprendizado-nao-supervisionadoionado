from typing import Self

import numpy as np
import pandas as pd
from sklearn.decomposition import PCA as SklearnPCA


class PCA:
    """Thin wrapper around scikit-learn PCA."""

    def __init__(self, model: SklearnPCA):
        self._model = model

    @classmethod
    def create(cls, random_state: int | None = 42) -> Self:
        return cls(SklearnPCA(random_state=random_state))

    def fit_transform(self, x: pd.DataFrame | np.ndarray) -> np.ndarray:
        return self._model.fit_transform(x)

    @property
    def components_(self) -> np.ndarray:
        return self._model.components_

    @property
    def explained_variance_(self) -> np.ndarray:
        return self._model.explained_variance_

    @property
    def explained_variance_ratio_(self) -> np.ndarray:
        return self._model.explained_variance_ratio_
