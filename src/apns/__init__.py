from apns import data
from apns.experiments import (
    export_dbscan_results,
    export_comparacao_algoritmos,
    export_hierarchical_results,
    export_kernel_fuzzy_kmeans_results,
    export_kmedoids_results,
    test_kmedoids_model,
)


def main() -> None:
    X, y = data.carregar_iris("data/iris.data.csv")

    print("Dimensões de X:", X.shape)
    print("Quantidade de rótulos:", len(y))
    print("\nDistribuição das espécies:")
    print(y.value_counts().sort_index())

    """ {DBSCAN}
    aumentar eps aumenta o raio de vizinhança. em geral, mais pontos passam a ser alcançáveis e regiões podem se unir
    aumentar minpts aumenta a  quantidade mínima de pontos necessária para formar uma região densa. em geral, fica mais difícil formar regiões e alguns pontos podem virar ruído
    """

    eps_values = [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 1.0]
    minpts_values = [3, 5, 7, 10, 15]
    dbscan_results = export_dbscan_results(
        x=X,
        y=y,
        eps_values=eps_values,
        minpts_values=minpts_values,
        distance="euclidean",
    )
    print("\nResultados e gráficos do DBSCAN exportados.")

    """ {K-Medoids}
    """
    test_kmedoids_model(X, metric="cityblock")
    kmedoids_results = export_kmedoids_results(
        x=X,
        y=y,
        metric="cityblock",
        max_n_cluster=5,
        max_iter=10,
    )
    print("\nResultados e gráficos do K-Medoids exportados.")

    hierarchical_results = export_hierarchical_results(
        x=X,
        y=y,
        max_n_cluster=5,
    )
    print("\nResultados e gráfico do agrupamento hierárquico exportados.")

    kernel_fuzzy_kmeans_results = export_kernel_fuzzy_kmeans_results(
        x=X,
        y=y,
        max_n_cluster=5,
        max_iter=10,
        m=2.0,
        n_init=5,
    )
    print("\nResultados do Kernel Fuzzy K-Means exportados.")

    comparison = export_comparacao_algoritmos(
        {
            "DBSCAN": dbscan_results,
            "K-Medoids": kmedoids_results,
            "Hierárquico": hierarchical_results,
            "Kernel Fuzzy K-Means": kernel_fuzzy_kmeans_results,
        }
    )
    print("\nComparação dos algoritmos:")
    print(comparison)


if __name__ == "__main__":
    main()
