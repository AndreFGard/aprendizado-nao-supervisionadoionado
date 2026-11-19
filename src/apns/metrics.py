from sklearn.metrics import (
    adjusted_rand_score,
    silhouette_score,
)
from sklearn.manifold import trustworthiness


def calcular_silhueta(X, labels, metric="euclidean"):
    """Calcula a silhueta quando há pelo menos dois grupos válidos."""
    labels = list(labels)
    grupos = set(labels) - {-1}

    if len(grupos) < 2:
        return None
    return silhouette_score(X, labels, metric=metric)


def calcular_ari(y_real, labels):
    """Compara os agrupamentos com os rótulos reais."""
    y_real = list(y_real)
    labels = list(labels)
    if len(y_real) < 2 or len(set(labels)) < 2:
        return None
    if len(y_real) != len(labels):
        raise ValueError("y_real e labels devem ter o mesmo comprimento")
    return adjusted_rand_score(y_real, labels)


def calcular_trustworthiness(X, embedding, n_neighbors=10):
    """Avalia a preservacao de vizinhanca entre os dados originais e o embedding."""
    if len(X) <= n_neighbors:
        raise ValueError("n_neighbors deve ser menor que o numero de observacoes")
    return trustworthiness(X, embedding, n_neighbors=n_neighbors)
