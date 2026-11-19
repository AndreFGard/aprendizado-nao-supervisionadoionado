from typing import Self

import numpy as np
import pandas as pd
from sklearn.decomposition import KernelPCA as SklearnKernelPCA


class KernelPCA:
    def __init__(self, model: SklearnKernelPCA):
        self._model = model

    @classmethod
    def create(
        cls,
        kernel: str = "rbf",
        gamma: float | None = None,
        random_state: int | None = 42,
    ) -> Self:
        return cls(
            SklearnKernelPCA(
                kernel=kernel,  # pyright: ignore[reportArgumentType]
                gamma=gamma,
                random_state=random_state,
            )
        )

    def fit_transform(self, x: pd.DataFrame | np.ndarray) -> np.ndarray:
        return self._model.fit_transform(x)

    @property
    def eigenvalues_(self) -> np.ndarray:
        return self._model.eigenvalues_

    @property
    def gamma_(self) -> float:
        """Resolved default kernel gamma."""
        return float(self._model.gamma_)  # pyright: ignore[reportAttributeAccessIssue]
