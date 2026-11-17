#let methodology = [
  = Algoritmos de agrupamento

  == Procedimento metodológico

  Os experimentos foram conduzidos sobre a base Iris, utilizando quatro atributos numéricos: comprimento e largura da sépala e comprimento e largura da pétala. A variável de espécie foi mantida separada e não foi fornecida aos algoritmos, sendo utilizada somente na avaliação externa. Os dados foram organizados em uma matriz de atributos ($X$) e em um vetor de rótulos reais ($y$), com verificação de valores ausentes. Os atributos foram utilizados em seus valores originais, sem a necessidade de padronização ou normalização.
  Cada algoritmo foi executado com seus parâmetros específicos. Quando aplicável, foram avaliadas diferentes configurações por meio da variação dos parâmetros de interesse. A avaliação utilizou o Silhouette Score como métrica interna e o Adjusted Rand Index (ARI) como métrica externa. O cálculo dessas métricas seguiu as particularidades de cada algoritmo, incluindo o tratamento de observações classificadas como ruído.

  == K-Means

  == Fuzzy K-Means

  == Misturas gaussianas com EM

  == DBSCAN

  O DBSCAN é um algoritmo de agrupamento baseado em densidade. Diferentemente dos métodos que exigem a definição prévia da quantidade de grupos, ele identifica regiões densas de observações e permite classificar como ruído os pontos que não pertencem a nenhuma região suficientemente densa. Dessa forma, pode identificar agrupamentos de formatos variados e tratar explicitamente observações isoladas. O DBSCAN é determinado principalmente por dois parâmetros: $"eps"$, que define o raio da vizinhança, e $"minpts"$, que estabelece a quantidade mínima de observações para caracterizar uma região como densa. 
  Na implementação do Scikit-learn, a própria observação $p$ é incluída nessa contagem. Sua vizinhança é definida por: $N_("eps")(p) = {q in X : d(p,q) <= "eps"}$ em que $d(p,q)$ representa a distância entre as observações $p$ e $q$. Uma observação é um ponto central quando sua vizinhança contém pelo menos $"minpts"$ observações. Um ponto de fronteira não atende a esse requisito, mas pertence à vizinhança de um ponto central. Um ponto de ruído não é alcançado por nenhum ponto central e não é associado a um agrupamento.
  O algoritmo foi implementado por meio da classe `DBSCAN` da biblioteca Scikit-learn, com distância euclidiana. Foram avaliadas todas as combinações dos seguintes valores: $"eps" in {0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 1.0}$; $"minpts" in {3, 5, 7, 10, 15}$. Ao todo, foram analisadas 40 configurações. Para cada uma, foram registrados o número de agrupamentos e a quantidade de pontos de ruído. O número de agrupamentos foi calculado desconsiderando o rótulo $-1$, utilizado pelo Scikit-learn para representar o ruído.
  O Silhouette Score foi calculado somente para os pontos não classificados como ruído e apenas quando foram identificados pelo menos dois agrupamentos. O ARI também foi calculado sobre os pontos não classificados como ruído, comparando seus rótulos com as respectivas espécies reais. Os resultados foram exportados em tabelas e em gráficos que relacionam $"eps"$ às métricas de silhueta e à quantidade de pontos de ruído, com curvas distintas para cada valor de $"minpts"$.

  == Kernel Fuzzy K-Means

  O Kernel Fuzzy K-Means combina a atribuição fuzzy do Fuzzy K-Means com uma transformação implícita dos dados para um espaço de características. Assim, cada observação pode apresentar diferentes graus de pertinência aos agrupamentos. Para calcular as métricas e produzir a visualização dos grupos, cada observação foi associada ao agrupamento de maior pertinência. A transformação foi realizada por meio do kernel gaussiano de função de base radial (RBF): $K(x_i,x_j) = exp(-gamma ||x_i - x_j||^2), quad gamma = 1/(2 sigma^2)$ em que $"sigma2"$ controla a largura do kernel. O parâmetro $"m"$ controla o grau de fuzzyficação das pertinências; valores maiores produzem atribuições menos concentradas em um único agrupamento.

  O algoritmo foi implementado pela classe `KernelFuzzyKMeans`. A matriz de pertinências é inicializada aleatoriamente e atualizada iterativamente a partir das distâncias aos protótipos implícitos no espaço do kernel. Foram utilizadas no máximo 100 iterações por ajuste, com tolerância $10^(-5)$ para a variação da função objetivo. Para cada configuração, foram realizadas cinco inicializações internas, mantendo-se a solução de menor valor da função objetivo.

  Na avaliação experimental, foram testados valores de $k$ entre 2 e 5, $"m" in {1.5, 2.0, 2.5}$ e $"sigma2" in {"None", 0.5, 1.0, 2.0}$. Isso resultou em 48 combinações de parâmetros. Cada combinação foi executada dez vezes, com sementes distintas, totalizando 480 execuções. Para cada execução, foram registrados o Silhouette Score, o ARI, o valor final da função objetivo e o número de iterações realizadas. A configuração usada nas visualizações do agrupamento, dos graus de pertinência e da convergência da função objetivo foi selecionada pelo maior Silhouette Score entre as execuções avaliadas.

  == K-Medoids

  O K-Medoids é um método particional que representa cada agrupamento por um medóide, isto é, uma observação efetivamente presente na base. Diferentemente do K-Means, seus protótipos não precisam ser centróides abstratos, e o método pode ser aplicado diretamente com diferentes medidas de distância.

  Neste trabalho, o algoritmo foi implementado por meio da classe `KMedoids` da biblioteca Scikit-learn-extra, utilizando a distância city-block (Manhattan). A inicialização dos medóides foi heurística e o procedimento de otimização utilizado foi o método alternate, com limite máximo de 300 iterações por ajuste. Após o treinamento, cada observação foi associada ao medóide mais próximo.

  Foram avaliados valores de $k$ entre 2 e 5. Para cada valor de $k$, o modelo foi executado dez vezes, utilizando sementes distintas, totalizando 40 execuções. Em cada execução, foram registrados o Silhouette Score, calculado com a distância city-block, o ARI e a inércia. A inércia corresponde à soma das distâncias das observações aos medóides atribuídos. Para cada valor de $k$, foi selecionada a execução de menor inércia. A configuração utilizada na visualização do agrupamento foi selecionada, entre todas as execuções válidas, pelo maior Silhouette Score. Os resultados também foram organizados em gráficos que relacionam $k$ à silhueta e à inércia.

  == Agrupamento hierárquico Centroid Linkage

  O agrupamento hierárquico aglomerativo inicia com cada observação em um agrupamento separado e une progressivamente os agrupamentos até formar uma estrutura hierárquica. No método Centroid Linkage, também denominado UPGMC, a distância entre dois agrupamentos é calculada entre seus centróides. Essa sequência de fusões é representada por um dendrograma.

  Neste trabalho, o algoritmo foi implementado pela classe `HierarchicalCentroid`, utilizando a função `linkage` da biblioteca SciPy com o método centroid e distância euclidiana. A matriz de ligação foi construída sobre os atributos originais e cortada posteriormente para obter partições com diferentes valores de $k$. Foram avaliados valores de $k$ entre 2 e 5. Para cada valor, a partição foi obtida por meio da função `cut_tree` e o procedimento foi registrado dez vezes, totalizando 40 registros. Em cada configuração, foram calculados o Silhouette Score, utilizando a distância euclidiana, e o ARI em relação às espécies reais. Também foi gerado um dendrograma a partir da matriz de ligação para representar a estrutura hierárquica completa.

  = Técnicas de redução de dimensionalidade
]