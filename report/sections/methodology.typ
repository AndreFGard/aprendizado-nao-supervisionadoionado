#let methodology = [
  = Algoritmos de agrupamento

  == Procedimento metodológico

  Os experimentos foram conduzidos sobre a base Iris com 150 observações, três espécies com 50 observações cada e quatro atributos numéricos: comprimento e largura da sépala e comprimento e largura da pétala. A variável de espécie foi mantida separada e não foi fornecida aos algoritmos, sendo utilizada somente na avaliação externa. Os dados foram organizados em uma matriz de atributos ($X$) e em um vetor de rótulos reais ($y$), com verificação de dimensões, valores ausentes e quantidade de espécies. Os atributos foram utilizados em seus valores originais, sem padronização ou normalização.
  Cada algoritmo foi executado com seus parâmetros específicos, e quando aplicável, foram avaliadas diferentes configurações por meio da variação dos parâmetros de interesse e de sementes aleatórias. A avaliação utilizou o Silhouette Score como métrica interna e o Adjusted Rand Index (ARI) como métrica externa. O Silhouette Score mede a separação dos grupos em relação à coesão interna, enquanto o ARI mede a concordância entre os agrupamentos e as espécies reais, corrigida pelo acordo esperado ao acaso. O cálculo dessas métricas seguiu as particularidades de cada algoritmo, incluindo o tratamento de observações classificadas como ruído.

  == K-Means

  == K-Medoids

  O K-Medoids é um método particional que representa cada agrupamento por um medóide, isto é, uma observação efetivamente presente na base de dados. Diferentemente do K-Means, cujos protótipos são centróides, o K-Medoids utiliza observações reais como representantes dos grupos e permite a utilização de diferentes medidas de dissimilaridade.

  Neste trabalho, o algoritmo foi implementado por meio da classe `KMedoids` da biblioteca Scikit-learn-extra, utilizando a distância city-block (Manhattan). A inicialização dos medóides foi heurística e o procedimento de otimização utilizado foi o método alternate, com limite máximo de 300 iterações por execução. Após o treinamento, cada observação foi associada ao medóide mais próximo.

  Foram avaliados valores de $k$ entre 2 e 5, com dez execuções para cada configuração, utilizando sementes aleatórias distintas, totalizando 40 execuções. Em cada execução, foram registrados o Silhouette Score, calculado com a distância city-block, o ARI e a inércia, que corresponde à soma das distâncias das observações aos respectivos medóides. Para cada valor de $k$, foi selecionada a execução de menor inércia, enquanto a configuração utilizada na visualização do agrupamento foi escolhida, entre as execuções com Silhouette Score válido, pelo maior valor dessa métrica. Os resultados das execuções também foram apresentados em gráficos que relacionam o número de agrupamentos $k$ aos valores de silhueta e inércia.

  == Fuzzy K-Means

  == Kernel Fuzzy K-Means

  O Kernel Fuzzy K-Means combina a atribuição fuzzy do Fuzzy K-Means com uma transformação implícita dos dados para um espaço de características, permitindo que cada observação apresente diferentes graus de pertinência aos agrupamentos. Para calcular as métricas e produzir a visualização dos grupos, cada observação foi associada ao agrupamento de maior pertinência, obtendo-se uma partição discreta. A transformação foi realizada por meio do kernel gaussiano de função de base radial (RBF): $K(x_i,x_j) = exp(-gamma ||x_i - x_j||^2), quad gamma = 1/(2 sigma^2)$ em que $sigma^2$ controla a largura do kernel. O parâmetro $"m"$ controla o grau de fuzzyficação das pertinências: valores maiores tendem a produzir atribuições mais distribuídas entre os agrupamentos.

  O algoritmo foi implementado pela classe `KernelFuzzyKMeans`. A matriz de pertinências é inicializada aleatoriamente e atualizada iterativamente com base nas distâncias entre as observações e os protótipos implícitos no espaço de características. Foram utilizadas, no máximo, 100 iterações por ajuste, com critério de convergência baseado na diferença absoluta entre os valores da função objetivo de iterações consecutivas, utilizando tolerância de $10^(-5)$. Para cada execução experimental, foram realizadas cinco inicializações internas, sendo selecionada aquela que apresentou o menor valor da função objetivo.

  Na avaliação experimental, foram testados valores de $k$ entre 2 e 5, $"m" in {1.5, 2.0, 2.5}$ e $sigma^2 in {"automático", 0.5, 1.0, 2.0}$. Na configuração automática, utilizada quando $sigma^2$ = None, o valor foi definido pela variância global dos dados. Esse planejamento resultou em 48 combinações de parâmetros. Cada combinação foi executada dez vezes, com sementes distintas, totalizando 480 execuções experimentais, cada uma com cinco inicializações internas. 
  
  Para cada execução, foram registrados o Silhouette Score, o ARI, o valor final da função objetivo e o número de iterações realizadas. As métricas Silhouette Score e ARI foram calculadas a partir dos rótulos discretos obtidos pela maior pertinência de cada observação. A silhueta foi calculada utilizando os dados originais como entrada. Por fim, a configuração com maior Silhouette Score entre as execuções avaliadas foi selecionada, e o modelo foi ajustado novamente com seus respectivos parâmetros e semente para gerar as visualizações do agrupamento, dos graus de pertinência e da convergência da função objetivo.

  == Misturas gaussianas com EM

  == Agrupamento hierárquico Centroid Linkage

  O agrupamento hierárquico aglomerativo inicia com cada observação em um agrupamento separado e realiza fusões sucessivas até formar uma estrutura hierárquica. No método Centroid Linkage, também denominado UPGMC, a distância entre dois agrupamentos é calculada a partir da distância euclidiana entre seus centróides. A sequência de fusões é representada por um dendrograma.

  Neste trabalho, o algoritmo foi implementado pela classe `HierarchicalCentroid`, utilizando a função linkage da biblioteca SciPy com o método centroid e distância euclidiana. A matriz de ligação foi construída sobre os atributos originais e utilizada para obter partições com diferentes valores de $k$. Para evitar o efeito das inversões do Centroid Linkage sobre a função `cut_tree`, a partição com $k$ grupos é obtida pela reconstrução dos componentes após exatamente $n-k$ fusões da matriz de ligação. Foram avaliados valores de $k$ entre 2 e 5. Como o procedimento é determinístico e não utiliza inicialização aleatória, as repetições realizadas para cada valor de $k$ produzem os mesmos resultados, não representando execuções independentes. Para cada partição, foram calculados o Silhouette Score, com distância euclidiana, e o ARI, em comparação com as espécies reais. Também foi gerado um dendrograma a partir da matriz de ligação para representar a estrutura hierárquica obtida.
  
  == DBSCAN

  O DBSCAN é um algoritmo de agrupamento baseado em densidade. Diferentemente dos métodos que exigem a definição prévia da quantidade de grupos, ele identifica regiões densas de observações e permite classificar como ruído os pontos que não pertencem a nenhuma região suficientemente densa. Dessa forma, pode identificar agrupamentos de formatos variados e tratar explicitamente observações isoladas. O algoritmo é determinado principalmente por dois parâmetros: $"eps"$, que define o raio da vizinhança, e $"minpts"$, que estabelece a quantidade mínima de observações para caracterizar uma região como densa. Na implementação do Scikit-learn, a própria observação $p$ é incluída nessa contagem. Sua vizinhança é definida por: $N_("eps")(p) = {q in X : d(p,q) <= "eps"}$ em que $d(p,q)$ representa a distância entre as observações $p$ e $q$. Uma observação é um ponto central quando sua vizinhança contém pelo menos $"minpts"$ observações. Um ponto de fronteira não atende a esse requisito, mas pertence à vizinhança de um ponto central. Já um ponto de ruído não é central nem alcançável por densidade a partir de qualquer ponto central, não sendo associado a um agrupamento.
  
  O algoritmo foi implementado por meio da classe `DBSCAN` da biblioteca Scikit-learn, utilizando a distância euclidiana. Foram avaliadas todas as combinações dos seguintes valores: $"eps" in {0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 1.0}$; $"minpts" in {3, 5, 7, 10, 15}$, totalizando 40 configurações. Para cada configuração, foram registrados o número de agrupamentos identificados e a quantidade de pontos classificados como ruído. O número de agrupamentos foi calculado desconsiderando o rótulo $-1$, utilizado pelo Scikit-learn para representar os pontos ruído.
  O Silhouette Score foi calculado exclusivamente sobre as observações não classificadas como ruído, desde que fossem identificados pelo menos dois agrupamentos. O ARI também foi calculado considerando apenas essas observações, comparando os rótulos dos agrupamentos com as respectivas espécies reais. Configurações sem observações válidas ou com um único agrupamento recebem ARI indefinido (`NaN`) e não são utilizadas como configuração selecionada. Dessa forma, ambas as métricas avaliam a qualidade dos agrupamentos formados sem considerar os pontos descartados como ruído. A configuração visualizada foi selecionada pelo maior Silhouette Score entre aquelas com no máximo 10 observações de ruído; em caso de empate, o critério usa o menor `"eps"` e, em seguida, o menor `"minpts"`. Os resultados foram exportados em tabelas e gráficos que relacionam `"eps"` às métricas de silhueta, à cobertura e à quantidade de pontos de ruído, utilizando curvas distintas para cada valor de `"minpts"`.

  = Técnicas de redução de dimensionalidade

  == PCA

  == Kernel PCA

  == t-SNE

  O t-SNE foi utilizado para representar os quatro atributos numéricos da base Iris em um espaço bidimensional, preservando principalmente relações de vizinhança. Para isso, converte as distâncias no espaço original em em probabilidades de afinidade e busca aproximar as distribuições de probabilidade de vizinhança nos espaços original e reduzido, utilizando uma distribuição t de Student no espaço de baixa dimensão.

  O algoritmo foi implementado com a classe `TSNE` do Scikit-learn, utilizando inicialização PCA, taxa de aprendizado automática, limite de 1000 iterações e semente aleatória 42. Os quatro atributos numéricos foram utilizados como entrada, sem os rótulos de espécie. Foram avaliadas as perplexidades $5$, $10$, $20$ e $30$, que controlam o número efetivo de vizinhos considerados pelo algoritmo. Para cada configuração, foram registrados a divergência de Kullback-Leibler, o número de iterações realizadas e a trustworthiness com dez vizinhos. Como análise adicional de estabilidade, a perplexidade 30 foi executada com dez sementes ($0$ a $9$), preservando os demais parâmetros; nessa análise foram calculadas a média e o desvio padrão amostral da silhueta e da trustworthiness.

  A avaliação dos embeddings foi realizada pelo Silhouette Score no espaço bidimensional, utilizando as espécies reais apenas como referência para avaliar sua separação. A configuração com maior silhueta foi selecionada para a visualização final. Os resultados, incluindo os embeddings e as métricas calculadas, foram exportadas em tabelas e gráficos.

  == UMAP

  Assim como o t-SNE, o UMAP foi utilizado para representar os quatro atributos numéricos da base Iris em um espaço bidimensional. O método constrói um grafo de vizinhanças no espaço original e otimiza uma representação de baixa dimensão que busca preservar sua estrutura local, podendo também manter aspectos das relações globais entre as observações.

  O algoritmo foi implementado com a classe `UMAP` da biblioteca umap-learn, utilizando distância euclidiana, dois componentes e semente aleatória 42. Os atributos foram utilizados em seus valores originais, sem os rótulos de espécie. Foram avaliados os valores de n_neighbors $in {5, 10, 15, 30}$ e min_dist $in {0.0, 0.1, 0.5}$, totalizando 12 configurações. O parâmetro n_neighbors controla o tamanho da vizinhança utilizada na construção do grafo, enquanto min_dist controla o grau de compactação dos pontos no espaço de baixa dimensão.

  A avaliação dos embeddings foi realizada pelo Silhouette Score no espaço bidimensional, utilizando as espécies reais apenas como referência para avaliar sua separação, e pela trustworthiness com dez vizinhos, calculada a partir dos dados originais e dos embeddings. Como análise adicional de estabilidade, as quatro melhores configurações segundo a silhueta obtida com a semente 42 foram executadas novamente com dez sementes ($0$ a $9$); para cada configuração, foram registradas a média e o desvio padrão amostral da silhueta e da trustworthiness. A configuração com maior silhueta na análise inicial foi selecionada para a visualização final. As métricas foram exportadas em tabelas e os embeddings e resultados das avaliações foram representados em gráficos comparativos.

]