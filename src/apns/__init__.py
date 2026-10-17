from apns import data


def main() -> None:
    X, y = data.carregar_iris("data/iris.data.csv")

    print("Dimensões de X:", X.shape)
    print("Quantidade de rótulos:", len(y))
    print("\nDistribuição das espécies:")
    print(y.value_counts().sort_index())


if __name__ == "__main__":
    main()
