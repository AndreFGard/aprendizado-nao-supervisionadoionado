from typing import Self

import numpy as np
import pandas as pd
from sklearn.decomposition import KernelPCA as SklearnKernelPCA


class KernelPCA:
    """Thin wrapper around scikit-learn KernelPCA.

    RBF is the project's configurable kernel default. All other parameters
    keep their scikit-learn defaults; for RBF, `gamma=None` lets scikit-learn
    use its default value of `1 / n_features`.
    """

    def __init__(self, model: SklearnKernelPCA):
        self._model = model

    @classmethod
    def create(
        cls,
        kernel: str = "rbf",
        random_state: int | None = 42,
    ) -> Self:
        return cls(
            SklearnKernelPCA(
                kernel=kernel,  # pyright: ignore[reportArgumentType],
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
