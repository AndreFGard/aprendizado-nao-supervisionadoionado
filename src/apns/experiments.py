import dataclasses
import json
from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from matplotlib.figure import Figure

from apns import metrics
from apns.models import (
    dbscan,
    hierarchical,
    kernel_fuzzy_kmeans,
    kernel_pca,
    kmedoids,
    pca,
    treinable_model,
    tsne,
    umap,
)
from apns.visualization import (
    plot_cluster_assignments,
    plot_dbscan_eps_comparison,
    plot_dbscan_metrics,
    plot_hierarchical_dendrogram,
    plot_kmedoids_inertia,
    plot_kmedoids_silhouette,
    plot_membership_degrees,
    plot_objective_convergence,
    plot_tsne_embedding,
    plot_tsne_embeddings_comparison,
    plot_tsne_perplexity_comparison,
    plot_umap_embedding,
    plot_umap_embeddings_comparison,
    plot_umap_parameter_comparison,
)


def _prepare_results_directories(
    results_dir: Path | None,
) -> tuple[Path, Path]:
    if results_dir is None:
        results_dir = Path(__file__).resolve().parents[2] / "results"
    else:
        results_dir = Path(results_dir)

    tables_dir = results_dir / "tables"
    figures_dir = results_dir / "figures"
    tables_dir.mkdir(parents=True, exist_ok=True)
    figures_dir.mkdir(parents=True, exist_ok=True)
    return tables_dir, figures_dir


def _save_figure(figure: Figure, path: Path) -> None:
    figure.savefig(path)
    plt.close(figure)


def _save_table(
    results: pd.DataFrame,
    tables_dir: Path,
    filename: str,
) -> None:
    results.to_csv(tables_dir / filename, index=False)


def _select_best_row(
    results: pd.DataFrame,
    metric: str,
    fallback_metric: str | None = None,
) -> pd.Series:
    valid_results = results.dropna(subset=[metric])
    if not valid_results.empty:
        return valid_results.loc[valid_results[metric].idxmax()]
    assert fallback_metric is not None
    valid_results = results.dropna(subset=[fallback_metric])
    if not valid_results.empty:
        return valid_results.loc[valid_results[fallback_metric].idxmin()]
    raise ValueError(f"No valid mnetric for {metric} ")


def evaluate_kmeanslike_model(
    x: pd.DataFrame,
    y: pd.Series,
    model_cls: type[treinable_model.IKMeansLikeModel],
    max_n_cluster: int = 5,
    max_iter: int = 10,
) -> pd.DataFrame:
    results = []
    for k in range(1, max_n_cluster + 1):
        for iteration in range(max_iter):
            model = model_cls.create(n_clusters=k, random_state=iteration)
            model.fit(x)

            clusters = model.predict(x)
            silhouette = metrics.calcular_silhueta(x, clusters)
            results.append(
                {
                    "model_name": model_cls.__name__,
                    "objective_name": model_cls.objective_name,
                    "iter": iteration,
                    "k": k,
                    "objective": model.compute_objective(x),
                    "silhouette": silhouette,
                    "ari": metrics.calcular_ari(y, clusters),
                    "n_iter": model.n_iter,
                }
            )
    return pd.DataFrame(results)


@dataclasses.dataclass
class PCAResult:
    embedding: np.ndarray
    variance: pd.DataFrame
    components: pd.DataFrame


def evaluate_pca_model(x: pd.DataFrame) -> PCAResult:
    model = pca.PCA.create()
    embedding = model.fit_transform(x)
    ratios = model.explained_variance_ratio_
    component_names = [f"PC{i}" for i in range(1, len(ratios) + 1)]

    variance = pd.DataFrame(
        {
            "component": range(1, len(ratios) + 1),
            "eigenvalue": model.explained_variance_,
            "explained_variance_ratio": ratios,
            "cumulative_ratio": np.cumsum(ratios),
        }
    )
    components = pd.DataFrame(model.components_, columns=x.columns)
    components.insert(0, "component", component_names)

    return PCAResult(
        embedding=embedding,
        variance=variance,
        components=components,
    )


@dataclasses.dataclass
class KernelPCAResult:
    embedding: np.ndarray
    variance: pd.DataFrame


def evaluate_kernel_pca_model(
    x: pd.DataFrame,
    kernel: str = "rbf",
) -> KernelPCAResult:
    model = kernel_pca.KernelPCA.create(kernel=kernel)
    embedding = model.fit_transform(x)
    eigenvalues = model.eigenvalues_
    ratios = eigenvalues / eigenvalues.sum()

    variance = pd.DataFrame(
        {
            "component": range(1, len(eigenvalues) + 1),
            "kernel": kernel,
            # default gamma
            "gamma*": model.gamma_,
            "eigenvalue": eigenvalues,
            "explained_variance_ratio": ratios,
            "cumulative_ratio": np.cumsum(ratios),
        }
    )
    return KernelPCAResult(embedding=embedding, variance=variance)


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
                            "ari": metrics.calcular_ari(y, clusters),
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

    tables_dir, figures_dir = _prepare_results_directories(results_dir)

    _save_table(results, tables_dir, "kernel_fuzzy_kmeans_metrics.csv")

    best_result = _select_best_row(
        results,
        metric="silhouette",
        fallback_metric="objective",
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
    _save_figure(
        clusters_fig,
        figures_dir / "kernel_fuzzy_kmeans_clusters.png",
    )

    membership_fig = plot_membership_degrees(model.membership_)
    _save_figure(
        membership_fig,
        figures_dir / "kernel_fuzzy_kmeans_memberships.png",
    )

    k3_ari_result = (
        results.loc[results["k"] == 3]
        .sort_values("ari", ascending=False)
        .iloc[0]
    )
    k3_sigma2 = k3_ari_result["sigma2"]
    if pd.isna(k3_sigma2):
        k3_sigma2 = None
    k3_model = kernel_fuzzy_kmeans.KernelFuzzyKMeans.create(
        n_clusters=3,
        random_state=int(k3_ari_result["iter"]),
        m=float(k3_ari_result["m"]),
        sigma2=k3_sigma2,
        n_init=n_init,
        max_iter=model_max_iter,
        tol=tol,
    )
    k3_model.fit(x)

    cluster_species = (
        pd.DataFrame({"cluster": k3_model.labels_, "species": y.to_numpy()})
        .groupby("cluster")["species"]
        .agg(lambda values: values.mode().iloc[0])
    )
    species_names = {
        "Iris-setosa": "Setosa",
        "Iris-versicolor": "Versicolor",
        "Iris-virginica": "Virginica",
    }
    k3_cluster_names = {
        int(cluster): species_names[str(species)]
        for cluster, species in cluster_species.items()
    }

    k3_clusters_fig = plot_cluster_assignments(
        x,
        k3_model.labels_,
        "Kernel Fuzzy K-Means (k = 3): melhor ARI",
        x_column="petal_length",
        y_column="petal_width",
        cluster_names=k3_cluster_names,
    )
    _save_figure(
        k3_clusters_fig,
        figures_dir / "kernel_fuzzy_kmeans_k3_ari_clusters.png",
    )

    k3_membership_fig = plot_membership_degrees(
        k3_model.membership_,
        cluster_names=k3_cluster_names,
        title="Kernel Fuzzy K-Means (k = 3): graus de pertinência",
    )
    _save_figure(
        k3_membership_fig,
        figures_dir / "kernel_fuzzy_kmeans_k3_ari_memberships.png",
    )

    contingency = (
        pd.crosstab(
            pd.Series(y.to_numpy(), name="species"),
            pd.Series(k3_model.labels_, name="cluster"),
        )
        .rename(index=species_names)
        .rename(columns=k3_cluster_names)
    )
    contingency.to_csv(tables_dir / "kernel_fuzzy_kmeans_k3_ari_contingency.csv")

    membership_table = pd.DataFrame(
        k3_model.membership_,
        columns=[k3_cluster_names[cluster] for cluster in range(3)],
    )
    membership_table.insert(0, "sample", range(len(membership_table)))
    membership_table.to_csv(
        tables_dir / "kernel_fuzzy_kmeans_k3_ari_membership.csv",
        index=False,
    )

    objective_fig = plot_objective_convergence(model.objective_history_)
    _save_figure(
        objective_fig,
        figures_dir / "kernel_fuzzy_kmeans_objective_convergence.png",
    )

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
                    "ari": metrics.calcular_ari(y, clusters),
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

    tables_dir, figures_dir = _prepare_results_directories(results_dir)

    _save_table(results, tables_dir, "hierarchical_metrics.csv")

    model = hierarchical.HierarchicalCentroid.create(n_clusters=3)
    model.fit(x)

    k3_labels = model.get_clusters(k=3)
    cluster_species = (
        pd.DataFrame({"cluster": k3_labels, "species": y.to_numpy()})
        .groupby("cluster")["species"]
        .agg(lambda values: values.mode().iloc[0])
    )
    species_names = {
        "Iris-setosa": "Setosa",
        "Iris-versicolor": "Versicolor",
        "Iris-virginica": "Virginica",
    }
    k3_cluster_names = {
        int(cluster): species_names[str(species)]
        for cluster, species in cluster_species.items()
    }
    k3_clusters_fig = plot_cluster_assignments(
        x,
        k3_labels,
        "Centroid Linkage (k = 3): agrupamento no plano das pétalas",
        x_column="petal_length",
        y_column="petal_width",
        cluster_names=k3_cluster_names,
    )
    _save_figure(
        k3_clusters_fig,
        figures_dir / "hierarchical_k3_petal_clusters.png",
    )

    cut_height = (
        model.linkage_matrix_[len(x) - 3 - 1, 2]
        + model.linkage_matrix_[len(x) - 3, 2]
    ) / 2
    dendrogram_fig = plot_hierarchical_dendrogram(
        model.linkage_matrix_,
        truncate_p=30,
        cut_height=cut_height,
        title="Centroid Linkage: dendrograma truncado",
    )
    _save_figure(dendrogram_fig, figures_dir / "hierarchical_dendrogram.png")

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
                        "ari": metrics.calcular_ari(y, clusters),
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
    best_result = _select_best_row(results, metric="silhouette")
    return results.loc[[best_result.name]].reset_index(drop=True)


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

    tables_dir, figures_dir = _prepare_results_directories(results_dir)

    _save_table(results, tables_dir, "kmedoids_metrics.csv")
    best_by_k = select_best_kmedoids_by_k(results)
    best_configuration = select_best_kmedoids_configuration(results)
    _save_table(best_by_k, tables_dir, "kmedoids_best_by_k.csv")
    _save_table(
        best_configuration,
        tables_dir,
        "kmedoids_best_configuration.csv",
    )

    silhouette_fig = plot_kmedoids_silhouette(results)
    _save_figure(silhouette_fig, figures_dir / "kmedoids_silhouette.png")
    inertia_fig = plot_kmedoids_inertia(results)
    _save_figure(inertia_fig, figures_dir / "kmedoids_inertia.png")

    k3_result = best_by_k.loc[best_by_k["k"] == 3].iloc[0]
    kmedoids_model = kmedoids.KMedoids.create(
        n_clusters=3,
        metric=metric if isinstance(metric, str) else str(metric[0]),
        random_state=int(k3_result["iter"]),
    )
    kmedoids_model.fit(x)
    kmedoids_labels = kmedoids_model.predict(x)
    cluster_species = (
        pd.DataFrame({"cluster": kmedoids_labels, "species": y.to_numpy()})
        .groupby("cluster")["species"]
        .agg(lambda values: values.mode().iloc[0])
    )
    species_names = {
        "Iris-setosa": "Setosa",
        "Iris-versicolor": "Versicolor",
        "Iris-virginica": "Virginica",
    }
    cluster_names = {
        int(cluster): species_names[str(species)]
        for cluster, species in cluster_species.items()
    }
    clusters_fig = plot_cluster_assignments(
        x,
        kmedoids_labels,
        "K-Medoids (k = 3): agrupamento no plano das pétalas",
        x_column="petal_length",
        y_column="petal_width",
        medoid_indices=kmedoids_model.medoid_indices_,
        cluster_names=cluster_names,
    )
    _save_figure(clusters_fig, figures_dir / "kmedoids_clusters.png")

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
                "cobertura": 100 * (len(clusters) - n_ruido) / len(clusters),
                "silhouette": silhouete,
                "ari": metrics.calcular_ari(
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

    tables_dir, figures_dir = _prepare_results_directories(results_dir)

    plots = plot_dbscan_metrics(all_results)
    _save_table(all_results, tables_dir, "dbscan_metrics.csv")
    _save_figure(plots.silhouette_fig, figures_dir / "dbscan_silhouette.png")
    _save_figure(plots.noise_fig, figures_dir / "dbscan_noise.png")
    _save_figure(plots.coverage_fig, figures_dir / "dbscan_coverage.png")

    eligible = all_results[
        all_results["n_ruido"].le(10)
        & all_results["silhouette"].notna()
    ]
    if eligible.empty:
        raise ValueError(
            "Nenhuma configuração do DBSCAN possui silhueta válida "
            "com no máximo 10 observações de ruído"
        )
    selected_row = eligible.sort_values(
        ["silhouette", "eps", "minpts"],
        ascending=[False, True, True],
    ).iloc[0]
    selected_result = evaluate_dbscan_model(
        x=x,
        y=y,
        eps=float(selected_row["eps"]),
        minpts=int(selected_row["minpts"]),
        distance=distance,
    )
    _save_table(
        selected_result,
        tables_dir,
        "dbscan_selected_configuration.csv",
    )
    selected_labels = json.loads(selected_result.iloc[0]["labels"])
    selected_clusters_fig = plot_cluster_assignments(
        x,
        selected_labels,
        "DBSCAN: agrupamento selecionado",
    )
    _save_figure(
        selected_clusters_fig,
        figures_dir / "dbscan_clusters.png",
    )

    petal_model = dbscan.DBSCAN.create(
        eps=0.4,
        minpts=3,
        distance=distance,
    )
    petal_labels = petal_model.fit_predict(x)
    petal_clusters_fig = plot_cluster_assignments(
        x,
        petal_labels,
        "DBSCAN: eps = 0,4 e minpts = 3",
        x_column="petal_length",
        y_column="petal_width",
    )
    _save_figure(
        petal_clusters_fig,
        figures_dir / "dbscan_eps04_minpts3_petals.png",
    )

    def dbscan_factory(*, eps: float, minpts: int):
        return dbscan.DBSCAN.create(
            eps=eps,
            minpts=minpts,
            distance=distance,
        )

    eps_comparison_fig = plot_dbscan_eps_comparison(
        x=x,
        eps_values=(0.4, 1.0),
        minpts=5,
        model_factory=dbscan_factory,
    )
    _save_figure(
        eps_comparison_fig,
        figures_dir / "dbscan_eps04_eps10_comparison.png",
    )

    return all_results


def evaluate_tsne_model(
    x: pd.DataFrame,
    y: pd.Series,
    perplexity: float = 30.0,
    max_iter: int = 1000,
    random_state: int = 42,
) -> pd.DataFrame:
    model, embedding = _fit_tsne(
        x=x,
        perplexity=perplexity,
        max_iter=max_iter,
        random_state=random_state,
    )

    # A silhueta usa os rótulos reais para medir a separabilidade no embedding.
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
                "trustworthiness": metrics.calcular_trustworthiness(
                    x,
                    embedding,
                    n_neighbors=10,
                ),
            }
        ]
    )


def _fit_tsne(
    x: pd.DataFrame,
    perplexity: float,
    max_iter: int,
    random_state: int,
) -> tuple[tsne.TSNE, np.ndarray]:
    model = tsne.TSNE.create(
        perplexity=perplexity,
        max_iter=max_iter,
        random_state=random_state,
    )
    return model, model.fit_predict(x)


def export_tsne_results(
    x: pd.DataFrame,
    y: pd.Series,
    perplexity_values: list[float] | None = None,
    max_iter: int = 1000,
    random_state: int = 42,
    results_dir: Path | None = None,
    seed_values: list[int] | None = None,
    trustworthiness_n_neighbors: int = 10,
) -> pd.DataFrame:
    perplexity_values = [30.0] if perplexity_values is None else perplexity_values
    seed_values = list(range(10)) if seed_values is None else seed_values
    tables_dir, figures_dir = _prepare_results_directories(results_dir)
    result_rows = []

    embeddings = {}
    for perplexity in perplexity_values:
        model, embedding = _fit_tsne(
            x=x,
            perplexity=perplexity,
            max_iter=max_iter,
            random_state=random_state,
        )
        embeddings[perplexity] = embedding
        result_rows.append(
            {
                "model_name": tsne.TSNE.__name__,
                "perplexity": perplexity,
                "max_iter": max_iter,
                "random_state": random_state,
                # Compara a separação dos rótulos conhecidos no embedding.
                "silhouette": metrics.calcular_silhueta(embedding, y),
                "kl_divergence": model.kl_divergence_,
                "n_iter": model.n_iter_,
                "trustworthiness": metrics.calcular_trustworthiness(
                    x,
                    embedding,
                    n_neighbors=trustworthiness_n_neighbors,
                ),
            }
        )

    results = pd.DataFrame(result_rows)
    _save_table(results, tables_dir, "tsne_metrics.csv")

    seed_rows = []
    for seed in seed_values:
        model, embedding = _fit_tsne(
            x=x,
            perplexity=30.0,
            max_iter=max_iter,
            random_state=seed,
        )
        seed_rows.append(
            {
                "model_name": tsne.TSNE.__name__,
                "perplexity": 30.0,
                "max_iter": max_iter,
                "random_state": seed,
                "silhouette": metrics.calcular_silhueta(embedding, y),
                "kl_divergence": model.kl_divergence_,
                "n_iter": model.n_iter_,
                "trustworthiness": metrics.calcular_trustworthiness(
                    x,
                    embedding,
                    n_neighbors=trustworthiness_n_neighbors,
                ),
            }
        )

    seed_results = pd.DataFrame(seed_rows)
    _save_table(seed_results, tables_dir, "tsne_seed_results.csv")
    seed_summary = pd.DataFrame(
        [
            {
                "perplexity": 30.0,
                "n_seeds": len(seed_results),
                "n_neighbors_trustworthiness": trustworthiness_n_neighbors,
                "silhouette_mean": seed_results["silhouette"].mean(),
                "silhouette_std": seed_results["silhouette"].std(),
                "kl_divergence_mean": seed_results["kl_divergence"].mean(),
                "kl_divergence_std": seed_results["kl_divergence"].std(),
                "trustworthiness_mean": seed_results["trustworthiness"].mean(),
                "trustworthiness_std": seed_results["trustworthiness"].std(),
            }
        ]
    )
    _save_table(seed_summary, tables_dir, "tsne_seed_summary.csv")

    embeddings_figure = plot_tsne_embeddings_comparison(embeddings, y)
    _save_figure(
        embeddings_figure,
        figures_dir / "tsne_embeddings_perplexities.png",
    )

    perplexity_figure = plot_tsne_perplexity_comparison(results)
    _save_figure(
        perplexity_figure,
        figures_dir / "tsne_perplexity_comparison.png",
    )

    best_result = _select_best_row(results, metric="silhouette")
    embedding = embeddings[float(best_result["perplexity"])]
    figure = plot_tsne_embedding(
        embedding,
        y,
        title=(
            "Visualização do Iris utilizando t-SNE "
            f"(perplexidade={best_result['perplexity']})"
        ),
    )
    _save_figure(figure, figures_dir / "tsne_embedding.png")

    return results


def evaluate_umap_model(
    x: pd.DataFrame,
    y: pd.Series,
    n_neighbors: int = 15,
    min_dist: float = 0.1,
    random_state: int = 42,
    trustworthiness_n_neighbors: int = 10,
) -> pd.DataFrame:
    _model, embedding = _fit_umap(
        x=x,
        n_neighbors=n_neighbors,
        min_dist=min_dist,
        random_state=random_state,
    )
    return pd.DataFrame(
        [
            {
                "model_name": umap.UMAP.__name__,
                "n_neighbors": n_neighbors,
                "min_dist": min_dist,
                "random_state": random_state,
                "silhouette": metrics.calcular_silhueta(embedding, y),
                "trustworthiness": metrics.calcular_trustworthiness(
                    x,
                    embedding,
                    n_neighbors=trustworthiness_n_neighbors,
                ),
            }
        ]
    )


def _fit_umap(
    x: pd.DataFrame,
    n_neighbors: int,
    min_dist: float,
    random_state: int,
) -> tuple[umap.UMAP, np.ndarray]:
    model = umap.UMAP.create(
        n_neighbors=n_neighbors,
        min_dist=min_dist,
        random_state=random_state,
    )
    return model, model.fit_predict(x)


def export_umap_results(
    x: pd.DataFrame,
    y: pd.Series,
    n_neighbors_values: list[int] | None = None,
    min_dist_values: list[float] | None = None,
    random_state: int = 42,
    results_dir: Path | None = None,
    seed_values: list[int] | None = None,
    trustworthiness_n_neighbors: int = 10,
    n_best_configurations: int = 4,
) -> pd.DataFrame:
    n_neighbors_values = [15] if n_neighbors_values is None else n_neighbors_values
    min_dist_values = [0.1] if min_dist_values is None else min_dist_values
    seed_values = list(range(10)) if seed_values is None else seed_values
    tables_dir, figures_dir = _prepare_results_directories(results_dir)
    result_rows = []
    embeddings = {}

    for n_neighbors in n_neighbors_values:
        for min_dist in min_dist_values:
            _model, embedding = _fit_umap(
                x=x,
                n_neighbors=n_neighbors,
                min_dist=min_dist,
                random_state=random_state,
            )
            parameter = (n_neighbors, min_dist)
            embeddings[parameter] = embedding
            result_rows.append(
                {
                    "model_name": umap.UMAP.__name__,
                    "n_neighbors": n_neighbors,
                    "min_dist": min_dist,
                    "random_state": random_state,
                    "silhouette": metrics.calcular_silhueta(embedding, y),
                    "trustworthiness": metrics.calcular_trustworthiness(
                        x,
                        embedding,
                        n_neighbors=trustworthiness_n_neighbors,
                    ),
                }
            )

    results = pd.DataFrame(result_rows)
    _save_table(results, tables_dir, "umap_metrics.csv")

    top_configurations = (
        results.sort_values("silhouette", ascending=False)
        .head(n_best_configurations)
        [["n_neighbors", "min_dist"]]
        .itertuples(index=False, name=None)
    )

    seed_rows = []
    seed_summary_rows = []
    for n_neighbors, min_dist in top_configurations:
        for seed in seed_values:
            _model, embedding = _fit_umap(
                x=x,
                n_neighbors=int(n_neighbors),
                min_dist=float(min_dist),
                random_state=seed,
            )
            seed_rows.append(
                {
                    "model_name": umap.UMAP.__name__,
                    "n_neighbors": int(n_neighbors),
                    "min_dist": float(min_dist),
                    "random_state": seed,
                    "silhouette": metrics.calcular_silhueta(embedding, y),
                    "trustworthiness": metrics.calcular_trustworthiness(
                        x,
                        embedding,
                        n_neighbors=trustworthiness_n_neighbors,
                    ),
                }
            )

    seed_results = pd.DataFrame(seed_rows)
    _save_table(seed_results, tables_dir, "umap_seed_results.csv")

    for (n_neighbors, min_dist), group in seed_results.groupby(
        ["n_neighbors", "min_dist"]
    ):
        seed_summary_rows.append(
            {
                "n_neighbors": int(n_neighbors),
                "min_dist": float(min_dist),
                "n_seeds": len(group),
                "n_neighbors_trustworthiness": trustworthiness_n_neighbors,
                "silhouette_mean": group["silhouette"].mean(),
                "silhouette_std": group["silhouette"].std(),
                "trustworthiness_mean": group["trustworthiness"].mean(),
                "trustworthiness_std": group["trustworthiness"].std(),
            }
        )

    seed_summary = pd.DataFrame(seed_summary_rows).sort_values(
        ["silhouette_mean", "trustworthiness_mean"],
        ascending=False,
    )
    _save_table(seed_summary, tables_dir, "umap_seed_summary.csv")

    embeddings_figure = plot_umap_embeddings_comparison(embeddings, y)
    _save_figure(
        embeddings_figure,
        figures_dir / "umap_embeddings_parameters.png",
    )

    parameter_figure = plot_umap_parameter_comparison(results)
    _save_figure(
        parameter_figure,
        figures_dir / "umap_parameter_comparison.png",
    )

    best_result = _select_best_row(results, metric="silhouette")
    embedding = embeddings[
        (int(best_result["n_neighbors"]), float(best_result["min_dist"]))
    ]
    figure = plot_umap_embedding(
        embedding,
        y,
        title=(
            "Visualização do Iris utilizando UMAP "
            f"(n_neighbors={int(best_result['n_neighbors'])}, "
            f"min_dist={best_result['min_dist']:g})"
        ),
    )
    _save_figure(figure, figures_dir / "umap_embedding.png")

    return results


def comparar_algoritmos_por_silhueta(
    resultados: dict[str, pd.DataFrame],
) -> pd.DataFrame:
    """Compara cada algoritmo pela configuração de maior silhueta."""
    comparacao = []
    for nome, resultados_modelo in resultados.items():
        melhor = _select_best_row(resultados_modelo, metric="silhouette")
        comparacao.append(
            {
                "algorithm": nome,
                "n_clusters": melhor.get("k", melhor.get("n_clusters")),
                "silhouette": melhor["silhouette"],
                "ari": melhor["ari"],
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
    tables_dir, _ = _prepare_results_directories(results_dir)

    comparacao = comparar_algoritmos_por_silhueta(resultados)
    _save_table(comparacao, tables_dir, "algorithm_comparison.csv")
    return comparacao
