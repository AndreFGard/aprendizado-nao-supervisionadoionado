# Projeto Aprendizado de Máquina não Supervisionado 

O projeto utiliza a base **Iris** para explorar algoritmos de agrupamento e técnicas de redução de dimensionalidade.

## Objetivos

###  Agrupamento

Executar e comparar os seguintes algoritmos:

- K-means
- Fuzzy k-means
- Misturas gaussianas com EM
- DBSCAN
- Kernel fuzzy k-means
- K-medoids com distância city-block
- Agrupamento hierárquico Centroid Linkage (UPGMC)

As análises incluem, conforme aplicável, seleção de parâmetros, cálculo da silhueta, índice de Rand ajustado (ARI), gráficos e discussão dos resultados.

### Redução de dimensionalidade

Executar e analisar:

- PCA
- Kernel PCA
- t-SNE
- UMAP

Serão apresentadas visualizações bidimensionais e comentários sobre os resultados.

## Estrutura do repositório

```text
aprendizado-nao-supervisionado/
├── data/           # Dados locais ou instruções para obtê-los
├── notebooks/      # Exploração e experimentos em Jupyter
├── src/apns/       # Pacote Python reutilizável
├── results/        # Tabelas, gráficos e resultados exportados
├── docs/           # Decisões metodológicas e documentação
├── pyproject.toml  # Metadados e dependências do projeto
├── .python-version
├── .gitignore
└── README.md
```

## Ambiente de desenvolvimento

O projeto usa [uv](https://docs.astral.sh/uv/), é preciso tê-lo instalado.

```bash
uv sync         
uv run apns    
uv run
```

Use `uv format` e instale a extensão 'Ruff', para manter o codigo padronizado.
