import json
from pathlib import Path

import numpy as np
import pandas as pd

from apns import metrics
from apns.models import dbscan
from apns.models import hierarchical
from apns.models import kernel_fuzzy_kmeans
from apns.models import kmedoids
from apns.models import tsne
from apns.models import treinable_model
from apns.visualization import (
    plot_cluster_assignments,
    plot_dbscan_metrics,
    plot_hierarchical_dendrogram,
    plot_kmedoids_inertia,
    plot_kmedoids_silhouette,
    plot_membership_degrees,
    plot_objective_convergence,
    plot_tsne_embedding,
    plot_tsne_embeddings_comparison,
    plot_tsne_perplexity_comparison,
)


def evaluate_kmeanslike_model(
    x,
    y,
    model_cls: type[treinable_model.IPredictiveModel],
    max_n_cluster=5,
    max_iter=10,
):
    results = []
    for k in range(2, max_n_cluster + 1):
        for iter in range(max_iter):
            model = model_cls.create(n_clusters=k, random_state=iter)
            model.fit(x)

            clusters = model.predict(x)
            silhouette = metrics.calcular_silhueta(x, clusters)
            results.append(
                {
                    "model_name": model_cls.__name__,
                    "iter": iter,
                    "k": k,
                    "silhouette": silhouette,
                    "rand_score": metrics.calcular_ari(y, clusters),
                }
            )
    return pd.DataFrame(results)


def evaluate_kernel_fuzzy_kmeans_model(
    x: pd.DataFrame,
    y: pd.Series,
    max_n_cluster: int = 5,
    max_iter: int = 10,
    m: float = 2.0,
    sigma2: float | None = None,
    n_init: int = 1,
    model_max_iter: int = 100,
    tol: float = 1e-5,
    m_values: list[float] | None = None,
    sigma2_values: list[float | None] | None = None,
) -> pd.DataFrame:
    m_values = [m] if m_values is None else m_values
    sigma2_values = [sigma2] if sigma2_values is None else sigma2_values
    results = []
    for k in range(2, max_n_cluster + 1):
        for m_value in m_values:
            for sigma2_value in sigma2_values:
                for iteration in range(max_iter):
                    model = kernel_fuzzy_kmeans.KernelFuzzyKMeans.create(
                        n_clusters=k,
                        random_state=iteration,
                        m=m_value,
                        sigma2=sigma2_value,
                        n_init=n_init,
                        max_iter=model_max_iter,
                        tol=tol,
                    )
                    model.fit(x)
                    clusters = model.predict(x)
                    results.append(
                        {
                            "model_name": model.__class__.__name__,
                            "iter": iteration,
                            "k": k,
                            "m": m_value,
                            "sigma2": model.sigma2,
                            "n_init": n_init,
                            "silhouette": metrics.calcular_silhueta(x, clusters),
                            "rand_score": metrics.calcular_ari(y, clusters),
                            "objective": model.objective_,
                            "n_iter": model.n_iter_,
                        }
                    )
    return pd.DataFrame(results)


def export_kernel_fuzzy_kmeans_results(
    x: pd.DataFrame,
    y: pd.Series,
    max_n_cluster: int = 5,
    max_iter: int = 10,
    m: float = 2.0,
    sigma2: float | None = None,
    n_init: int = 1,
    model_max_iter: int = 100,
    tol: float = 1e-5,
    m_values: list[float] | None = None,
    sigma2_values: list[float | None] | None = None,
    results_dir: Path | None = None,
) -> pd.DataFrame:
    results = evaluate_kernel_fuzzy_kmeans_model(
        x=x,
        y=y,
        max_n_cluster=max_n_cluster,
        max_iter=max_iter,
        m=m,
        sigma2=sigma2,
        n_init=n_init,
        model_max_iter=model_max_iter,
        tol=tol,
        m_values=m_values,
        sigma2_values=sigma2_values,
    )

    if results_dir is None:
        project_root = Path(__file__).resolve().parents[2]
        results_dir = project_root / "results"
    else:
        results_dir = Path(results_dir)

    tables_dir = results_dir / "tables"
    figures_dir = results_dir / "figures"
    tables_dir.mkdir(parents=True, exist_ok=True)
    figures_dir.mkdir(parents=True, exist_ok=True)

    results.to_csv(tables_dir / "kernel_fuzzy_kmeans_metrics.csv", index=False)

    valid_results = results.dropna(subset=["silhouette"])
    best_result = (
        valid_results.loc[valid_results["silhouette"].idxmax()]
        if not valid_results.empty
        else results.loc[results["objective"].idxmin()]
    )
    model = kernel_fuzzy_kmeans.KernelFuzzyKMeans.create(
        n_clusters=int(best_result["k"]),
        random_state=int(best_result["iter"]),
        m=float(best_result["m"]),
        sigma2=best_result["sigma2"],
        n_init=n_init,
        max_iter=model_max_iter,
        tol=tol,
    )
    model.fit(x)
    clusters_fig = plot_cluster_assignments(
        x,
        model.labels_,
        "Kernel Fuzzy K-Means: melhor agrupamento",
    )
    clusters_fig.savefig(figures_dir / "kernel_fuzzy_kmeans_clusters.png")

    membership_fig = plot_membership_degrees(model.membership_)
    membership_fig.savefig(figures_dir / "kernel_fuzzy_kmeans_memberships.png")

    objective_fig = plot_objective_convergence(model.objective_history_)
    objective_fig.savefig(figures_dir / "kernel_fuzzy_kmeans_objective_convergence.png")

    return results


def evaluate_hierarchical_model(
    x: pd.DataFrame,
    y: pd.Series,
    max_n_cluster: int = 5,
    max_iter: int = 10,
) -> pd.DataFrame:
    results = []
    for k in range(2, max_n_cluster + 1):
        for iteration in range(max_iter):
            model = hierarchical.HierarchicalCentroid.create(n_clusters=k)
            clusters = model.fit_predict(x)
            results.append(
                {
                    "model_name": model.__class__.__name__,
                    "iter": iteration,
                    "k": k,
                    "linkage": "centroid",
                    "silhouette": metrics.calcular_silhueta(x, clusters),
                    "rand_score": metrics.calcular_ari(y, clusters),
                }
            )
    return pd.DataFrame(results)


def export_hierarchical_results(
    x: pd.DataFrame,
    y: pd.Series,
    max_n_cluster: int = 5,
    max_iter: int = 10,
    results_dir: Path | None = None,
) -> pd.DataFrame:
    results = evaluate_hierarchical_model(
        x=x,
        y=y,
        max_n_cluster=max_n_cluster,
        max_iter=max_iter,
    )

    if results_dir is None:
        project_root = Path(__file__).resolve().parents[2]
        results_dir = project_root / "results"

    tables_dir = results_dir / "tables"
    figures_dir = results_dir / "figures"
    tables_dir.mkdir(parents=True, exist_ok=True)
    figures_dir.mkdir(parents=True, exist_ok=True)

    results.to_csv(tables_dir / "hierarchical_metrics.csv", index=False)

    model = hierarchical.HierarchicalCentroid.create(
        n_clusters=2,
    )
    model.fit(x)
    dendrogram_fig = plot_hierarchical_dendrogram(model.linkage_matrix_)
    dendrogram_fig.savefig(figures_dir / "hierarchical_dendrogram.png")

    return results


def evaluate_kmedoids_model(
    x: pd.DataFrame,
    y: pd.Series,
    metric: str | list[str] = "cityblock",
    max_n_cluster: int = 5,
    max_iter: int = 10,
) -> pd.DataFrame:
    metric_values = [metric] if isinstance(metric, str) else metric
    results = []
    for metric_value in metric_values:
        for k in range(2, max_n_cluster + 1):
            for iteration in range(max_iter):
                model = kmedoids.KMedoids.create(
                    n_clusters=k,
                    metric=metric_value,
                    random_state=iteration,
                )
                model.fit(x)

                clusters = model.predict(x)
                results.append(
                    {
                        "model_name": kmedoids.KMedoids.__name__,
                        "iter": iteration,
                        "k": k,
                        "metric": metric_value,
                        "silhouette": metrics.calcular_silhueta(
                            x,
                            clusters,
                            metric=metric_value,
                        ),
                        "inertia": model.inertia_,
                        "rand_score": metrics.calcular_ari(y, clusters),
                        "labels": json.dumps(clusters.tolist()),
                    }
                )
    return pd.DataFrame(results)


def test_kmedoids_model(
    x: pd.DataFrame,
    metric: str = "cityblock",
) -> kmedoids.KMedoids:
    model = kmedoids.KMedoids.create(
        n_clusters=2,
        metric=metric,
        random_state=0,
    )
    model.fit(x)
    return model


def select_best_kmedoids_by_k(results: pd.DataFrame) -> pd.DataFrame:
    best_indices = results.groupby("k")["inertia"].idxmin()
    return results.loc[best_indices].sort_values("k").reset_index(drop=True)


def select_best_kmedoids_configuration(results: pd.DataFrame) -> pd.DataFrame:
    valid_results = results.dropna(subset=["silhouette"])
    best_index = valid_results["silhouette"].idxmax()
    return results.loc[[best_index]].reset_index(drop=True)


def export_kmedoids_results(
    x: pd.DataFrame,
    y: pd.Series,
    metric: str | list[str] = "cityblock",
    max_n_cluster: int = 5,
    max_iter: int = 10,
    results_dir: Path | None = None,
) -> pd.DataFrame:
    results = evaluate_kmedoids_model(
        x=x,
        y=y,
        metric=metric,
        max_n_cluster=max_n_cluster,
        max_iter=max_iter,
    )

    if results_dir is None:
        project_root = Path(__file__).resolve().parents[2]
        results_dir = project_root / "results"

    tables_dir = results_dir / "tables"
    figures_dir = results_dir / "figures"
    tables_dir.mkdir(parents=True, exist_ok=True)
    figures_dir.mkdir(parents=True, exist_ok=True)

    results.to_csv(tables_dir / "kmedoids_metrics.csv", index=False)
    best_by_k = select_best_kmedoids_by_k(results)
    best_configuration = select_best_kmedoids_configuration(results)
    best_by_k.to_csv(tables_dir / "kmedoids_best_by_k.csv", index=False)
    best_configuration.to_csv(
        tables_dir / "kmedoids_best_configuration.csv",
        index=False,
    )

    silhouette_fig = plot_kmedoids_silhouette(results)
    silhouette_fig.savefig(figures_dir / "kmedoids_silhouette.png")
    inertia_fig = plot_kmedoids_inertia(results)
    inertia_fig.savefig(figures_dir / "kmedoids_inertia.png")
    kmedoids_labels = json.loads(best_configuration.iloc[0]["labels"])
    clusters_fig = plot_cluster_assignments(
        x,
        kmedoids_labels,
        "K-Medoids: melhor agrupamento por silhueta",
    )
    clusters_fig.savefig(figures_dir / "kmedoids_clusters.png")

    return results


def evaluate_dbscan_model(
    x: pd.DataFrame,
    y: pd.Series,
    eps: float,
    minpts: int,
    distance: str = "euclidean",
) -> pd.DataFrame:
    model = dbscan.DBSCAN.create(
        eps=eps,
        minpts=minpts,
        distance=distance,
    )

    clusters = model.fit_predict(x)
    n_clusters = len(set(clusters) - {-1})
    pontos_validos = clusters != -1
    n_ruido = int(np.sum(~pontos_validos))
    silhouete = (
        None
        if n_clusters < 2
        else metrics.calcular_silhueta(
            x.loc[pontos_validos],
            clusters[pontos_validos],
        )
    )

    return pd.DataFrame(
        [
            {
                "model_name": dbscan.DBSCAN.__name__,
                "eps": eps,
                "minpts": minpts,
                "distance": distance,
                "n_clusters": n_clusters,
                "n_ruido": n_ruido,
                "silhouette": silhouete,
                "rand_score": metrics.calcular_ari(
                    y.loc[pontos_validos],
                    clusters[pontos_validos],
                ),
                "labels": json.dumps(clusters.tolist()),
            }
        ]
    )


def export_dbscan_results(
    x: pd.DataFrame,
    y: pd.Series,
    eps_values: list[float],
    minpts_values: list[int],
    distance: str = "euclidean",
    results_dir: Path | None = None,
) -> pd.DataFrame:
    results = [
        evaluate_dbscan_model(
            x=x,
            y=y,
            eps=eps,
            minpts=minpts,
            distance=distance,
        )
        for eps in eps_values
        for minpts in minpts_values
    ]
    all_results = pd.concat(results, ignore_index=True)

    if results_dir is None:
        project_root = Path(__file__).resolve().parents[2]
        results_dir = project_root / "results"

    tables_dir = results_dir / "tables"
    figures_dir = results_dir / "figures"
    tables_dir.mkdir(parents=True, exist_ok=True)
    figures_dir.mkdir(parents=True, exist_ok=True)

    plots = plot_dbscan_metrics(all_results)
    all_results.to_csv(tables_dir / "dbscan_metrics.csv", index=False)
    plots.silhouette_fig.savefig(figures_dir / "dbscan_silhouette.png")
    plots.noise_fig.savefig(figures_dir / "dbscan_noise.png")

    selected_result = evaluate_dbscan_model(
        x=x,
        y=y,
        eps=0.6,
        minpts=5,
        distance=distance,
    )
    selected_result.to_csv(
        tables_dir / "dbscan_selected_configuration.csv",
        index=False,
    )
    selected_labels = json.loads(selected_result.iloc[0]["labels"])
    selected_clusters_fig = plot_cluster_assignments(
        x,
        selected_labels,
        "DBSCAN: agrupamento selecionado",
    )
    selected_clusters_fig.savefig(figures_dir / "dbscan_clusters.png")

    return all_results


def evaluate_tsne_model(
    x: pd.DataFrame,
    y: pd.Series,
    perplexity: float = 30.0,
    max_iter: int = 1000,
    random_state: int = 42,
) -> pd.DataFrame:
    model = tsne.TSNE.create(
        perplexity=perplexity,
        max_iter=max_iter,
        random_state=random_state,
    )
    embedding = model.fit_predict(x)

    return pd.DataFrame(
        [
            {
                "model_name": tsne.TSNE.__name__,
                "perplexity": perplexity,
                "max_iter": max_iter,
                "random_state": random_state,
                "silhouette": metrics.calcular_silhueta(embedding, y),
                "kl_divergence": model.kl_divergence_,
                "n_iter": model.n_iter_,
            }
        ]
    )


def export_tsne_results(
    x: pd.DataFrame,
    y: pd.Series,
    perplexity_values: list[float] | None = None,
    max_iter: int = 1000,
    random_state: int = 42,
    results_dir: Path | None = None,
) -> pd.DataFrame:
    perplexity_values = [30.0] if perplexity_values is None else perplexity_values
    results = pd.concat(
        [
            evaluate_tsne_model(
                x=x,
                y=y,
                perplexity=perplexity,
                max_iter=max_iter,
                random_state=random_state,
            )
            for perplexity in perplexity_values
        ],
        ignore_index=True,
    )

    if results_dir is None:
        project_root = Path(__file__).resolve().parents[2]
        results_dir = project_root / "results"

    tables_dir = Path(results_dir) / "tables"
    figures_dir = Path(results_dir) / "figures"
    tables_dir.mkdir(parents=True, exist_ok=True)
    figures_dir.mkdir(parents=True, exist_ok=True)
    results.to_csv(tables_dir / "tsne_metrics.csv", index=False)

    embeddings = {}
    for perplexity in perplexity_values:
        model = tsne.TSNE.create(
            perplexity=perplexity,
            max_iter=max_iter,
            random_state=random_state,
        )
        embeddings[perplexity] = model.fit_predict(x)

    embeddings_figure = plot_tsne_embeddings_comparison(embeddings, y)
    embeddings_figure.savefig(
        figures_dir / "tsne_embeddings_perplexities.png",
    )

    perplexity_figure = plot_tsne_perplexity_comparison(results)
    perplexity_figure.savefig(figures_dir / "tsne_perplexity_comparison.png")

    best_result = results.loc[results["silhouette"].idxmax()]
    best_model = tsne.TSNE.create(
        perplexity=float(best_result["perplexity"]),
        max_iter=max_iter,
        random_state=random_state,
    )
    embedding = best_model.fit_predict(x)
    figure = plot_tsne_embedding(
        embedding,
        y,
        title=(
            "Visualização do Iris utilizando t-SNE "
            f"(perplexidade={best_result['perplexity']})"
        ),
    )
    figure.savefig(figures_dir / "tsne_embedding.png")

    return results


def comparar_algoritmos_por_silhueta(
    resultados: dict[str, pd.DataFrame],
) -> pd.DataFrame:
    """Compara cada algoritmo pela configuração de maior silhueta."""
    comparacao = []
    for nome, resultados_modelo in resultados.items():
        validos = resultados_modelo.dropna(subset=["silhouette"])
        melhor = validos.loc[validos["silhouette"].idxmax()]
        comparacao.append(
            {
                "algorithm": nome,
                "n_clusters": melhor.get("k", melhor.get("n_clusters")),
                "silhouette": melhor["silhouette"],
                "rand_score": melhor["rand_score"],
                "metric": melhor.get("metric"),
                "linkage": melhor.get("linkage"),
                "m": melhor.get("m"),
                "sigma2": melhor.get("sigma2"),
                "eps": melhor.get("eps"),
                "minpts": melhor.get("minpts"),
            }
        )

    return (
        pd.DataFrame(comparacao)
        .sort_values(
            "silhouette",
            ascending=False,
        )
        .reset_index(drop=True)
    )


def export_comparacao_algoritmos(
    resultados: dict[str, pd.DataFrame],
    results_dir: Path | None = None,
) -> pd.DataFrame:
    """Exporta a comparação dos algoritmos para uma tabela CSV."""
    if results_dir is None:
        project_root = Path(__file__).resolve().parents[2]
        results_dir = project_root / "results"

    tables_dir = Path(results_dir) / "tables"
    tables_dir.mkdir(parents=True, exist_ok=True)

    comparacao = comparar_algoritmos_por_silhueta(resultados)
    comparacao.to_csv(tables_dir / "algorithm_comparison.csv", index=False)
    return comparacao
