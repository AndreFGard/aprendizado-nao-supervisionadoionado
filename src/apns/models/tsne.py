from typing import Self

import numpy as np
import pandas as pd
from sklearn.manifold import TSNE as SklearnTSNE

from apns.models import treinable_model


class TSNE(treinable_model.ITransductiveModel):
    def __init__(self, model: SklearnTSNE):
        self._model = model

    @classmethod
    def create(
        cls,
        n_components: int = 2,
        perplexity: float = 30.0,
        learning_rate: str | float = "auto",
        max_iter: int = 1000,
        init: str = "pca",
        random_state: int | None = 42,
    ) -> Self:
        return cls(
            SklearnTSNE(
                n_components=n_components,
                perplexity=perplexity,
                learning_rate=learning_rate,
                max_iter=max_iter,
                init=init,
                random_state=random_state,
            )
        )

    def fit(self, x: pd.DataFrame | np.ndarray) -> Self:
        self._model.fit(x)
        return self

    def fit_predict(self, x: pd.DataFrame | np.ndarray) -> np.ndarray:
        self.fit(x)
        return self.embedding_

    @property
    def embedding_(self) -> np.ndarray:
        return self._model.embedding_

    @property
    def kl_divergence_(self) -> float:
        return self._model.kl_divergence_

    @property
    def n_iter_(self) -> int:
        return self._model.n_iter_
