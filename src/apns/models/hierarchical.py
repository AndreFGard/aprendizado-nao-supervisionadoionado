from typing import Self

import numpy as np
import pandas as pd

from scipy.cluster.hierarchy import linkage

from apns.models import treinable_model


class HierarchicalCentroid(treinable_model.ITreinableModel):
    def __init__(self, n_clusters: int):
        self.n_clusters = n_clusters
        self.linkage_matrix_: np.ndarray | None = None
        self.n_samples_: int | None = None
        self.labels_: np.ndarray | None = None

    @classmethod
    def create(cls, n_clusters: int) -> Self:
        return cls(n_clusters=n_clusters)

    def fit(self, x: pd.DataFrame | np.ndarray) -> Self:
        x = np.asarray(x, dtype=float)
        self.n_samples_ = len(x)
        self.linkage_matrix_ = linkage(
            x,
            method="centroid",
            metric="euclidean",
        )
        self.labels_ = None
        return self

    def fit_predict(self, x: pd.DataFrame | np.ndarray) -> np.ndarray:
        self.fit(x)
        return self.get_clusters(self.n_clusters)

    def get_clusters(self, k: int | None = None) -> np.ndarray:
        if k is None:
            k = self.n_clusters
        if self.linkage_matrix_ is None:
            raise RuntimeError("O modelo precisa ser ajustado antes de obter os agrupamentos.")
        if k < 1 or k > self.n_samples_:
            raise ValueError(f"k deve estar entre 1 e {self.n_samples_}.")

        n_merges = self.n_samples_ - k
        parent = np.arange(2 * self.n_samples_ - 1)

        def find(node: int) -> int:
            while parent[node] != node:
                parent[node] = parent[parent[node]]
                node = parent[node]
            return node

        for merge_id, (left, right, _, _) in enumerate(
            self.linkage_matrix_[:n_merges],
            start=self.n_samples_,
        ):
            left_root = find(int(left))
            right_root = find(int(right))
            parent[left_root] = merge_id
            parent[right_root] = merge_id

        roots = np.array([find(index) for index in range(self.n_samples_)])
        labels = np.unique(roots, return_inverse=True)[1]
        self.labels_ = labels
        return labels
