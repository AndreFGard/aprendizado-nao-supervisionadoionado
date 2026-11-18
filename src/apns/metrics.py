from sklearn.metrics import (
    adjusted_rand_score,
    silhouette_score,
)


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
