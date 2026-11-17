from typing import Self

import numpy as np
import pandas as pd
import umap

from apns.models import treinable_model


class UMAP(treinable_model.ITransductiveModel):
    def __init__(self, model: umap.UMAP):
        self._model = model

    @classmethod
    def create(
        cls,
        n_components: int = 2,
        n_neighbors: int = 15,
        min_dist: float = 0.1,
        metric: str = "euclidean",
        random_state: int | None = 42,
    ) -> Self:
        return cls(
            umap.UMAP(
                n_components=n_components,
                n_neighbors=n_neighbors,
                min_dist=min_dist,
                metric=metric,
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
    def graph_(self):
        return self._model.graph_