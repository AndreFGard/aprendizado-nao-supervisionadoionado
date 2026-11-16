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

  == K-Medoids com distância city-block

  == Agrupamento hierárquico Centroid Linkage (UPGMC)

  = Técnicas de redução de dimensionalidade
]