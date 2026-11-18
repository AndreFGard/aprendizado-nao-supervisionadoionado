from dataclasses import dataclass

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import plotly
import plotly.express as px
from matplotlib.figure import Figure
from scipy.cluster.hierarchy import dendrogram

px.defaults.height = 480  # pyright: ignore[reportAttributeAccessIssue]
px.defaults.width = 640  # pyright: ignore[reportAttributeAccessIssue]


@dataclass
class KMeansLikeMetrics:
    rand_score_fig: plotly.graph_objs.Figure
    silhouette_fig: plotly.graph_objs.Figure
    best_metrics_per_n_clusters: pd.DataFrame


@dataclass
class DBSCANMetrics:
    silhouette_fig: Figure
    noise_fig: Figure
    metrics: pd.DataFrame


def plot_iris_data(
    x: pd.DataFrame,
    y: pd.Series,
    title: str = "Iris Dataset",
) -> plotly.graph_objs.Figure:
    iris = x.copy()
    iris["species"] = y.to_numpy()

    return px.scatter_matrix(
        iris,
        dimensions=x.columns,
        color="species",
        title=title,
        labels={column: column.replace("_", " ").title() for column in x.columns},
    )


def plot_kmedoids_silhouette(df_resultados: pd.DataFrame) -> Figure:
    figure, axis = plt.subplots(figsize=(8, 5))
    axis.plot(
        df_resultados["k"],
        df_resultados["silhouette"],
        marker="o",
    )
    axis.set_xlabel("Número de clusters (k)")
    axis.set_ylabel("Silhouette")
    axis.set_title("K-medoids: Silhouette × k")
    axis.set_xticks(range(1, 6))
    axis.grid()
    figure.tight_layout()
    return figure


def plot_silhouette_by_k(best_by_k: pd.DataFrame, model_name: str) -> Figure:
    ordered = best_by_k.dropna(subset=["silhouette"]).sort_values("k")
    figure, axis = plt.subplots(figsize=(8, 5))
    axis.plot(ordered["k"], ordered["silhouette"], marker="o")
    axis.set_xlabel("Número de clusters (k)")
    axis.set_ylabel("Silhouette")
    axis.set_title(f"{model_name}: Silhouette × k")
    axis.set_xticks(range(1, int(best_by_k["k"].max()) + 1))
    axis.grid()
    figure.tight_layout()
    return figure


def plot_kmedoids_inertia(df_resultados: pd.DataFrame) -> Figure:
    figure, axis = plt.subplots(figsize=(8, 5))
    axis.plot(
        df_resultados["k"],
        df_resultados["inertia"],
        marker="o",
    )
    axis.set_xlabel("Número de clusters (k)")
    axis.set_ylabel("Inertia")
    axis.set_title("K-medoids: Inertia × k")
    axis.set_xticks(sorted(df_resultados["k"].unique()))
    axis.grid()
    figure.tight_layout()
    return figure


def plot_cluster_assignments(
    x: pd.DataFrame,
    labels,
    title: str,
) -> Figure:
    figure, axis = plt.subplots(figsize=(8, 5))
    scatter = axis.scatter(
        x.iloc[:, 0],
        x.iloc[:, 1],
        c=labels,
        cmap="tab10",
        edgecolors="black",
        linewidths=0.3,
    )
    axis.set_xlabel(x.columns[0])
    axis.set_ylabel(x.columns[1])
    axis.set_title(title)
    figure.colorbar(scatter, ax=axis, label="Rótulo do cluster")
    figure.tight_layout()
    return figure


def plot_tsne_embedding(
    embedding: np.ndarray,
    labels: pd.Series,
    title: str = "Visualização do Iris utilizando t-SNE",
) -> Figure:
    figure, axis = plt.subplots(figsize=(9, 6))
    labels_array = labels.to_numpy()

    for label in pd.unique(labels_array):
        mask = labels_array == label
        axis.scatter(
            embedding[mask, 0],
            embedding[mask, 1],
            label=str(label),
            alpha=0.8,
        )

    axis.set_title(title)
    axis.set_xlabel("Componente t-SNE 1")
    axis.set_ylabel("Componente t-SNE 2")
    axis.legend()
    axis.grid(alpha=0.2)
    figure.tight_layout()
    return figure


def plot_tsne_embeddings_comparison(
    embeddings: dict[float, np.ndarray],
    labels: pd.Series,
) -> Figure:
    perplexities = sorted(embeddings)
    n_columns = min(2, len(perplexities))
    n_rows = (len(perplexities) + n_columns - 1) // n_columns
    figure, axes = plt.subplots(
        n_rows,
        n_columns,
        figsize=(6 * n_columns, 5 * n_rows),
        squeeze=False,
    )
    labels_array = labels.to_numpy()

    for axis, perplexity in zip(axes.flat, perplexities):
        embedding = embeddings[perplexity]
        for label in pd.unique(labels_array):
            mask = labels_array == label
            axis.scatter(
                embedding[mask, 0],
                embedding[mask, 1],
                label=str(label),
                alpha=0.8,
            )
        axis.set_title(f"Perplexidade = {perplexity:g}")
        axis.set_xlabel("Componente t-SNE 1")
        axis.set_ylabel("Componente t-SNE 2")
        axis.grid(alpha=0.2)

    for axis in axes.flat[len(perplexities) :]:
        axis.set_visible(False)

    handles, legend_labels = axes.flat[0].get_legend_handles_labels()
    figure.legend(handles, legend_labels, loc="lower center", ncol=2)
    figure.suptitle("t-SNE: comparação dos embeddings por perplexidade")
    figure.tight_layout(rect=(0, 0.05, 1, 0.95))
    return figure


def plot_tsne_perplexity_comparison(df_metrics: pd.DataFrame) -> Figure:
    figure, axes = plt.subplots(1, 2, figsize=(12, 5))

    ordered_metrics = df_metrics.sort_values("perplexity")
    axes[0].plot(
        ordered_metrics["perplexity"],
        ordered_metrics["silhouette"],
        marker="o",
    )
    axes[0].set_xlabel("Perplexidade")
    axes[0].set_ylabel("Silhueta")
    axes[0].set_title("Silhueta por perplexidade")
    axes[0].grid(alpha=0.2)

    axes[1].plot(
        ordered_metrics["perplexity"],
        ordered_metrics["kl_divergence"],
        marker="o",
    )
    axes[1].set_xlabel("Perplexidade")
    axes[1].set_ylabel("KL divergence")
    axes[1].set_title("KL divergence por perplexidade")
    axes[1].grid(alpha=0.2)

    figure.suptitle("t-SNE: comparação de perplexidades")
    figure.tight_layout()
    return figure


def plot_umap_embedding(
    embedding: np.ndarray,
    labels: pd.Series,
    title: str = "Visualização do Iris utilizando UMAP",
) -> Figure:
    figure, axis = plt.subplots(figsize=(9, 6))
    labels_array = labels.to_numpy()

    for label in pd.unique(labels_array):
        mask = labels_array == label
        axis.scatter(
            embedding[mask, 0],
            embedding[mask, 1],
            label=str(label),
            alpha=0.8,
        )

    axis.set_title(title)
    axis.set_xlabel("Componente UMAP 1")
    axis.set_ylabel("Componente UMAP 2")
    axis.legend()
    axis.grid(alpha=0.2)
    figure.tight_layout()
    return figure


def plot_umap_embeddings_comparison(
    embeddings: dict[tuple[int, float], np.ndarray],
    labels: pd.Series,
) -> Figure:
    parameters = sorted(embeddings)
    n_columns = min(2, len(parameters))
    n_rows = (len(parameters) + n_columns - 1) // n_columns
    figure, axes = plt.subplots(
        n_rows,
        n_columns,
        figsize=(6 * n_columns, 5 * n_rows),
        squeeze=False,
    )
    labels_array = labels.to_numpy()

    for axis, (n_neighbors, min_dist) in zip(axes.flat, parameters):
        embedding = embeddings[(n_neighbors, min_dist)]
        for label in pd.unique(labels_array):
            mask = labels_array == label
            axis.scatter(
                embedding[mask, 0],
                embedding[mask, 1],
                label=str(label),
                alpha=0.8,
            )
        axis.set_title(f"n_neighbors={n_neighbors}, min_dist={min_dist:g}")
        axis.set_xlabel("Componente UMAP 1")
        axis.set_ylabel("Componente UMAP 2")
        axis.grid(alpha=0.2)

    for axis in axes.flat[len(parameters) :]:
        axis.set_visible(False)

    handles, legend_labels = axes.flat[0].get_legend_handles_labels()
    figure.legend(handles, legend_labels, loc="lower center", ncol=2)
    figure.suptitle("UMAP: comparação dos embeddings por parâmetros")
    figure.tight_layout(rect=(0, 0.05, 1, 0.95))
    return figure


def plot_umap_parameter_comparison(df_metrics: pd.DataFrame) -> Figure:
    figure, axis = plt.subplots(figsize=(9, 5))
    for min_dist, group in df_metrics.groupby("min_dist"):
        ordered_metrics = group.sort_values("n_neighbors")
        axis.plot(
            ordered_metrics["n_neighbors"],
            ordered_metrics["silhouette"],
            marker="o",
            label=f"min_dist={min_dist:g}",
        )
    axis.set_xlabel("Número de vizinhos (n_neighbors)")
    axis.set_ylabel("Silhueta")
    axis.set_title("UMAP: silhueta por parâmetros")
    axis.grid(alpha=0.2)
    axis.legend()
    figure.tight_layout()
    return figure


def plot_component_scatter(
    embedding: np.ndarray,
    labels: pd.Series,
    x_label: str,
    y_label: str,
    title: str,
) -> Figure:
    """Dispersão 2D de um embedding, com os rótulos reais por cor."""
    figure, axis = plt.subplots(figsize=(9, 6))
    labels_array = labels.to_numpy()

    for label in pd.unique(labels_array):
        mask = labels_array == label
        axis.scatter(
            embedding[mask, 0],
            embedding[mask, 1],
            label=str(label),
            alpha=0.8,
        )

    axis.set_title(title)
    axis.set_xlabel(x_label)
    axis.set_ylabel(y_label)
    axis.legend()
    axis.grid(alpha=0.2)
    figure.tight_layout()
    return figure


def plot_membership_degrees(membership: np.ndarray) -> Figure:
    figure, axis = plt.subplots(figsize=(10, 5))
    image = axis.imshow(membership.T, aspect="auto", cmap="viridis", vmin=0, vmax=1)
    axis.set_xlabel("Amostra")
    axis.set_ylabel("Cluster")
    axis.set_title("Kernel Fuzzy K-Means: graus de pertinência")
    axis.set_yticks(range(membership.shape[1]))
    figure.colorbar(image, ax=axis, label="Pertinência")
    figure.tight_layout()
    return figure


def plot_objective_convergence(objective_history: list[float]) -> Figure:
    figure, axis = plt.subplots(figsize=(8, 5))
    axis.plot(range(1, len(objective_history) + 1), objective_history, marker="o")
    axis.set_xlabel("Iteração")
    axis.set_ylabel("Função objetivo")
    axis.set_title("Kernel Fuzzy K-Means: convergência da função objetivo")
    axis.grid()
    figure.tight_layout()
    return figure


def plot_hierarchical_dendrogram(
    linkage_matrix,
    title: str = "Agrupamento hierárquico: dendrograma",
) -> Figure:
    figure, axis = plt.subplots(figsize=(12, 6))
    dendrogram(linkage_matrix, ax=axis)
    axis.set_xlabel("Observações")
    axis.set_ylabel("Distância")
    axis.set_title(title)
    figure.tight_layout()
    return figure


# TODO require a pandera/typed d
def plot_kmeans_like_metrics(df_metrics: pd.DataFrame, model_name: str):
    # TODO rename labels
    # TODO decide if this is the best plot
    # TODO decide if its desirable to see teh distrbution of metrics per iteration or if a simple line plot of the .max() does the job
    rand_score_fig = px.box(
        df_metrics,
        x="k",
        y="rand_score",
        boxmode="group",
        points="all",
        title=f"{model_name} Rand Index",
    )

    silhouette_fig = px.box(
        df_metrics,
        x="k",
        y="silhouette",
        boxmode="group",
        points="all",
        title=f"{model_name} Silhouette Score",
    )

    best_values = df_metrics.groupby(["k", "model_name"])[
        ["silhouette", "rand_score"]
    ].max()
    best_values = best_values.rename(
        columns={
            "silhouette": "Max silhouette",
            "rand_score": "Max Rand Index",
        }
    )

    return KMeansLikeMetrics(
        rand_score_fig=rand_score_fig,
        silhouette_fig=silhouette_fig,
        best_metrics_per_n_clusters=best_values,
    )


def plot_dbscan_metrics(
    df_metrics: pd.DataFrame,
    model_name: str = "DBSCAN",
):
    silhouette_metrics = df_metrics.dropna(subset=["silhouette"])
    silhouette_fig, silhouette_axis = plt.subplots(figsize=(8, 5))
    for minpts, group in silhouette_metrics.groupby("minpts"):
        group = group.sort_values("eps")
        silhouette_axis.plot(
            group["eps"],
            group["silhouette"],
            marker="o",
            label=f"min_samples={minpts}",
        )
    silhouette_axis.set_xlabel("eps")
    silhouette_axis.set_ylabel("Silhouette")
    silhouette_axis.set_title(f"{model_name}: Silhouette por eps")
    silhouette_axis.grid()
    silhouette_axis.legend()
    silhouette_fig.tight_layout()

    noise_fig, noise_axis = plt.subplots(figsize=(8, 5))
    for minpts, group in df_metrics.groupby("minpts"):
        group = group.sort_values("eps")
        noise_axis.plot(
            group["eps"],
            group["n_ruido"],
            marker="o",
            label=f"min_samples={minpts}",
        )
    noise_axis.set_xlabel("eps")
    noise_axis.set_ylabel("Pontos de ruído")
    noise_axis.set_title(f"{model_name}: Pontos de ruído por eps")
    noise_axis.grid()
    noise_axis.legend()
    noise_fig.tight_layout()

    return DBSCANMetrics(
        silhouette_fig=silhouette_fig,
        noise_fig=noise_fig,
        metrics=df_metrics,
    )
