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
├── src/            # Código Python reutilizável
├── results/        # Tabelas, gráficos e resultados exportados
├── docs/           # Decisões metodológicas e documentação
├── tests/          # Testes
├── .gitignore
├── README.md
└── requirements.txt
```

## Ambiente de desenvolvimento

Recomendamos Python com ambiente virtual (`venv`). Depois de criar e ativar o ambiente, instale as dependências:

```bash
python -m venv .venv
```

Linux/macOS:

```bash
source .venv/bin/activate
```

Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

Instale as dependências com:

```bash
python -m pip install -r requirements.txt
```
