#let results-and-discussions = [
  = Resultados e discussões

  == K-Medoids

  Foram realizadas 40 execuções, com $k in {2, 3, 4, 5}$ e dez sementes por valor de $k$. Para cada $k$, as sementes produziram soluções idênticas em silhueta, inércia, ARI e rótulos, portanto o experimento resulta em quatro configurações distintas. A @tab:kmedoids resume os resultados.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*Silhouette*], [*ARI*], [*Inércia*]),
      table.hline(),
      [2], [0,674], [0,540], [219,5],
      [3], [0,529], [0,744], [164,8],
      [4], [0,500], [0,653], [140,2],
      [5], [0,443], [0,692], [131,9],
      table.hline(),
    ),
    caption: [K-Medoids (distância city-block)],
    kind: table,
  ) <tab:kmedoids>

  A silhueta diminui com $k$ (@fig:kmed-sil), atingindo o máximo em $k = 2$ (0,674). A inércia também diminui continuamente (@fig:kmed-inercia). Entre $k = 2$ e $k = 3$, a queda é de 54,7 (24,9%); em seguida, passa a 24,6 (14,9%) e a 8,3 (5,9%), indicando visualmente um cotovelo em $k = 3$.

  #figure(
    image("../imagens/kmedoids_silhouette.png", width: 100%),
    caption: [Silhouette em função do número de agrupamentos $k$ (K-Medoids).],
  ) <fig:kmed-sil>

  #figure(
    image("../imagens/kmedoids_inertia.png", width: 100%),
    caption: [Inércia em função do número de agrupamentos $k$ (K-Medoids).],
  ) <fig:kmed-inercia>

  A análise externa mostra que o ARI é máximo em $k = 3$ (0,744). Em todas as configurações, os 50 exemplares de _Iris setosa_ ficam isolados em um agrupamento, e as diferenças principais ocorrem na região de sobreposição entre _versicolor_ e _virginica_. Para $k = 2$, um agrupamento reúne as 50 _setosa_ e 3 _versicolor_ (53 observações), e o outro reúne 47 _versicolor_ e as 50 _virginica_ (97 observações). A silhueta elevada reflete a separação nítida da _setosa_ em relação ao restante. O ARI é menor porque a partição funde duas espécies.

  #figure(
    image("../imagens/kmedoids_clusters.png", width: 100%),
    caption: [Agrupamento por K-Medoids com $k = 3$, projetado em `petal_length` × `petal_width`; os rótulos indicam a espécie majoritária de cada grupo e os marcadores em formato `X` representam os medóides.],
  ) <fig:kmed-clusters>

  Para $k = 3$, a _setosa_ permanece isolada (50/50). Dos 50 exemplares de _versicolor_, 37 ficam em um agrupamento e 13 migram para o agrupamento dominado por _virginica_, que contém 48 das 50 _virginica_, e 2 _virginica_ são atribuídas ao agrupamento de _versicolor_. No total, 15 das 150 observações (10%) são alocadas fora do agrupamento majoritário de sua espécie, e os tamanhos dos agrupamentos são 39, 50 e 61. A @fig:kmed-clusters apresenta essa configuração projetada em comprimento e largura das pétalas. Os medóides têm coordenadas (5,7; 2,8; 4,1; 1,3), (5,0; 3,4; 1,5; 0,2) e (6,5; 3,0; 5,2; 2,0), nesta ordem: sepal_length, sepal_width, petal_length e petal_width. A queda da silhueta para 0,529 é explicada pela fronteira difusa entre _versicolor_ e _virginica_. A silhueta média por agrupamento é de aproximadamente 0,79 para o grupo da _setosa_, contra 0,50 e 0,34 para os outros dois. Esse resultado é compatível com o fato de o K-Medoids, por favorecer grupos compactos, não distinguir adequadamente objetos em regiões de fronteira.

  Com $k = 4$ e $k = 5$, os grupos adicionais subdividem a região de _versicolor_ e _virginica_ sem corresponder a novas espécies. Em ambos os casos, a silhueta diminui e o ARI não supera o de $k = 3$.

  Os resultados mostram uma divergência entre os critérios: a silhueta favorece $k = 2$, enquanto o ARI e o cotovelo da inércia apontam $k = 3$. Assim, $k = 2$ apresenta a melhor separação geométrica, mas $k = 3$ oferece o melhor compromisso com as espécies, com ARI de 0,744 e silhueta moderada de 0,529. Como os atributos não foram normalizados e a distância foi city-block, atributos de maior amplitude podem ter maior influência nas partições.

  == K-Means

  Foram realizadas 40 execuções, com $k in {2, 3, 4, 5}$ e dez sementes por valor de $k$. Para cada $k$, foi selecionada a execução de menor SSE e, entre as quatro partições resultantes, o número de grupos foi escolhido por $k^* = "arg max"_k "Sil"(k)$. A @tab:kmeans resume os resultados.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*Silhouette*], [*ARI*], [*SSE*]),
      table.hline(),
      [2], [0,681], [0,540], [152,4],
      [3], [0,553], [0,730], [78,9],
      [4], [0,497], [0,646], [57,3],
      [5], [0,493], [0,615], [46,6],
      table.hline(),
    ),
    caption: [K-Means: métricas da execução de menor SSE em cada $k$.],
    kind: table,
  ) <tab:kmeans>

  A silhueta é máxima em $k = 2$ (0,681), de modo que $k^* = 2$, e a partição correspondente tem ARI de 0,540 (@fig:kmeans-sil). Em $k = 2$ as dez sementes convergiram para a mesma solução, com SSE de 152,37, indicando a estabilidade desse particionamento.

  #figure(
    image("../imagens/kmeans_silhouette.png", width: 100%),
    caption: [Silhouette em função do número de clusters $k$ (K-Means).],
  ) <fig:kmeans-sil>

  //TODO Adicionar um scatter plot comparando k2 e k3.
  A partição com $k^* = 2$ repete o padrão descrito para o K-Medoids, em que um grupo reúne as 50 _setosa_ e 3 _versicolor_, e o outro reúne 47 _versicolor_ e as 50 _virginica_. A silhueta elevada reflete a separação da _setosa_, mas o ARI comparativamente menor que o de $k^*3$ decorre da fusão entre _versicolor_ e _virginica_. A silhueta decresce de $k = 2$ até $k = 5$, enquanto o ARI é máximo em $k = 3$ (0,730), com silhueta de 0,553. A divergência entre os critérios é a mesma observada no K-Medoids, em que a silhueta favorece a separação em 2 grupos enquanto o ARI aponta para 3 grupos particionarem os dados mais condizentemente com os rótulos. Nessa partição de $k = 3$, a _setosa_ permanece isolada e 10,7%  das observações não pertencem ao grupo majoritário da espécie, também em acordo com o resultado com o K-Medoids. Contudo, a diferença entre as métricas de ambos aumenta ligeiramente em $k=5$, chegando a ≃ 0.05 para a Silhouette e ≃ 0,07 para o ARI.

  == Fuzzy K-Means

  Foram realizadas 40 execuções, com $k in {2, 3, 4, 5}$, com inicializações diferentes. Conforme descrito em @sec:metodologia, a melhor configuração por $k$ foi escolhida e, entre estas, a final foi a de maior silhueta. A @tab:fkm resume as quatro partições selecionadas.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*Silhouette*], [*ARI*], [*Objetivo ($J_m$)*]),
      table.hline(),
      [2], [0,681], [0,540], [128,9],
      [3], [0,549], [0,729], [60,6],
      [4], [0,492], [0,627], [41,7],
      [5], [0,487], [0,616], [32,8],
      table.hline(),
    ),
    caption: [Fuzzy K-Means: métricas da execução de menor $J_m$ em cada $k$, com $m = 2$.],
    kind: table,
  ) <tab:fkm>

  A silhueta decresce de 0,681 em $k = 2$ para 0,487 em $k = 5$ (@fig:fkm-sil). Assim, temos que $k^* = 2$, com silhueta 0,681 e ARI 0,540. Visto que a $J_m$ é monotonicamente decrescente com o crescimento de $k$, como a SSE, esta não é relevante para a comparação de valores de $k$, restando o ARI e a Silhuette.

  #figure(
    image("../imagens/fuzzy_kmeans_silhouette.png", width: 100%),
    caption: [Silhouette em função do n. de agrupamentos $k$ (Fuzzy K-Means).],
  ) <fig:fkm-sil>


  O ARI máximo ocorre em $k = 3$ (0,729), com silhueta 0,549, enquanto a partição de $k^* = 2$ funde _versicolor_ e _virginica_, como já observado nos modelos anteriores. Não houve variabilidade entre sementes em $k = 2$ e $k = 3$, mas em $k = 4$ e $k = 5$, 4 execuções cada alcançaram mínimos locais. Portanto, mostrou-se importante  para este algoritmo testar várias inicializações, especialmente conforme as fronteiras se tornam difusas com o aumento de $k$.

  //TODO checar a conclusao
  Além disso, embora a fuzzificação de $m=2$ suavize as fronteiras, uma vez feito _crisp_, o particionamento para $k^*$ do Fuzzy K-Means, foi idêntico ao do K-Means, e as métricas se mantém muito próximas para $k > 2$.


  == Kernel Fuzzy K-Means

  Foram realizadas 480 execuções: 48 combinações de $k in {2, 3, 4, 5}$, $m in {1,5; 2,0; 2,5}$ e $sigma^2 in {"automático"; 0,5; 1,0; 2,0}$, com dez sementes cada. As sementes produziram soluções idênticas em 34 combinações; as variações ocorreram principalmente em $k >= 3$, com $sigma^2 = 0,5$ ou $m = 2,5$. A @tab:kfkm resume os resultados agregados por $k$.

  #figure(
    table(
      columns: 5,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*Sil. média*], [*Sil. mín.*], [*ARI média*], [*ARI máx.*]),
      table.hline(),
      [2], [0,686], [0,683], [0,564], [0,568],
      [3], [0,532], [0,428], [0,765], [0,818],
      [4], [0,474], [0,230], [0,671], [0,719],
      [5], [0,396], [0,168], [0,575], [0,734],
      table.hline(),
    ),
    caption: [Kernel Fuzzy K-Means: considerando todas as combinações de $m$, $sigma^2$ e sementes.],
    kind: table,
  ) <tab:kfkm>

  A silhueta média decresce de 0,686 em $k = 2$ para 0,396 em $k = 5$, repetindo a tendência já observada, e o ARI médio é máximo em $k = 3$ (0,765), assim como o ARI máximo observado (0,818). Esses resultados evidenciam a divergência entre os critérios interno e externo.

  Pela maior silhueta, a configuração selecionada foi $k = 2$, $m = 1,5$ e $sigma^2 = 0,5$, com silhueta de 0,6864 e ARI de 0,5681. Essa solução separa a _setosa_ das demais espécies. Na @fig:kfkm-pert, a _setosa_ apresenta pertinência elevada a um agrupamento, enquanto as espécies _versicolor_ e _virginica_ mostram pertinências intermediárias na região de fronteira. A atribuição pelo maior grau de pertinência produz a partição exibida na @fig:kfkm-clusters.

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_memberships.png", width: 100%),
    caption: [Graus de pertinência da melhor configuração por silhueta ($k = 2$, $m = 1,5$, $sigma^2 = 0,5$).],
  ) <fig:kfkm-pert>

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_clusters.png", width: 100%),
    caption: [Melhor agrupamento por silhueta, projetado em `sepal_length` e `sepal_width`.],
  ) <fig:kfkm-clusters>

  A @fig:kfkm-conv mostra a convergência em 18 iterações, com estabilização a partir da iteração 12. Como os valores da função objetivo dependem de $m$ e de $sigma^2$, eles não são usados para comparar configurações.

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_objective_convergence.png", width: 100%),
    caption: [Convergência da função objetivo da melhor configuração por silhueta.],
  ) <fig:kfkm-conv>

  Para $k = 3$, o ARI máximo foi 0,818, obtido com $m = 2,0$ e $sigma^2 = 0,5$. A maior silhueta nessa configuração foi 0,549, com $m = 1,5$ e $sigma^2$ automático, associada a ARI menor (0,729). Portanto, o ARI aponta $k = 3$ como a configuração mais coerente com as espécies, enquanto a silhueta favorece $k = 2$. Valores extremos dos parâmetros produziram instabilidade: 13 das 480 execuções atingiram o limite de 100 iterações. Essa ocorrência foi concentrada em $m = 2,5$, sobretudo em $k = 5$.

  Na melhor configuração por ARI ($k = 3$, $m = 2,0$, $sigma^2 = 0,5$, semente 2), a atribuição pelo maior grau de pertinência reproduz a separação da _setosa_ e concentra as confusões entre _versicolor_ e _virginica_ (@tab:kfkm-k3-contingencia).

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Espécie*], [*Virginica*], [*Versicolor*], [*Setosa*]),
      table.hline(),
      [Setosa], [0], [0], [50],
      [Versicolor], [4], [46], [0],
      [Virginica], [38], [12], [0],
      table.hline(),
    ),
    caption: [Contingência entre espécies reais e grupos da melhor configuração por ARI com $k = 3$.],
    kind: table,
  ) <tab:kfkm-k3-contingencia>

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_k3_ari_clusters.png", width: 100%),
    caption: [Melhor configuração por ARI ($k = 3$), projetada em `petal_length` × `petal_width`; os rótulos indicam a espécie majoritária de cada grupo.],
  ) <fig:kfkm-k3-clusters>

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_k3_ari_memberships.png", width: 100%),
    caption: [Graus de pertinência da melhor configuração por ARI com $k = 3$, agrupados pelo nome da espécie majoritária.],
  ) <fig:kfkm-k3-pert>

  Na matriz de pertinências, 116 das 150 observações têm pertinência máxima abaixo de 0,6. Esse valor quantifica uma fronteira ampla de atribuição incerta, principalmente entre _versicolor_ e _virginica_; a _setosa_ apresenta atribuição mais definida. A configuração obtém silhueta de 0,5313 e ARI de 0,8178.

  Em síntese, o Kernel Fuzzy K-Means separa a _setosa_ das demais espécies e apresenta maior dificuldade na fronteira entre _versicolor_ e _virginica_. A silhueta favorece $k = 2$, mas o ARI indica $k = 3$ como a configuração mais compatível com as espécies. Como os atributos não foram normalizados, a escala dos dados pode influenciar a escolha de $sigma^2$.

  == Misturas gaussianas com EM

  Foram realizadas 40 execuções, com $k in {2, 3, 4, 5}$ e dez sementes por valor de $k$. Em cada execução, a partição _crisp_ usada nas métricas foi obtida atribuindo cada observação ao componente de maior probabilidade a posteriori, e o melhor resultado por $k$ foi o de menor log-verossimilhança negativa. A @tab:em resume as quatro execuções selecionadas.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*Silhouette*], [*ARI*], [*Objetivo ($-"log" L$)*]),
      table.hline(),
      [2], [0,686], [0,568], [215,2],
      [3], [0,337], [0,583], [190,3],
      [4], [0,262], [0,444], [153,6],
      [5], [0,167], [0,417], [141,9],
      table.hline(),
    ),
    caption: [Misturas gaussianas com EM: métricas da execução de maior log-verossimilhança em cada $k$.],
    kind: table,
  ) <tab:em>

  A silhueta das execuções selecionadas decresce continuamente e de forma mais acelerada que nos outros métodos (@fig:em-sil), de modo que $k^* = 2$, com silhueta 0,686 e ARI 0,568, e a silhueta em $k^*=5 = 0,167$, sendo a maior diferença entre os métodos abordados. A partição crisp correspondente reúne as 50 _setosa_ em um agrupamento e as 100 observações de _versicolor_ e _virginica_ no outro. A silhueta elevada reflete a separação nítida da _setosa_, e o ARI moderado decorre da fusão das duas espécies restantes, em acordo com os demais métodos.

  #figure(
    image("../imagens/em_silhouette.png", width: 100%),
    caption: [Silhouette em função do número de clusters $k$ (misturas gaussianas com EM).],
  ) <fig:em-sil>

  // TODO: gerar o scatter da partição de maior silhueta (em_clusters.png) e da menor, deve ajudar a entender a variancia tao grande

  Diferentemente dos métodos anteriores, o EM apresentou forte variabilidade entre sementes, conforme vemos em @tab:em-agregado. Em $k = 2$, foram observadas silhuetas de 0,045 a 0,392 e ARI de 0,087 a 0,355, quantificando a disparidade dos resultados das execuções.

  #figure(
    table(
      columns: 5,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*Sil. média*], [*Sil. mín.*], [*ARI média*], [*ARI máx.*]),
      table.hline(),
      [2], [0,471], [0,045], [0,411], [0,568],
      [3], [0,350], [0,184], [0,541], [0,583],
      [4], [0,282], [0,249], [0,523], [0,770],
      [5], [0,168], [0,011], [0,477], [0,582],
      table.hline(),
    ),
    caption: [Métricas das dez execuções de cada Mistura gaussianas com EM, por $k$.],
    kind: table,
  ) <tab:em-agregado>

  //TODO plotar e identificar qual é a interpretação visual pra isso.
  Dessa maneira, o desempenho das Misturas Gaussianas na silhueta foi consideravelmente inferior aos outros modelos para $k^* > 2$.

  == Agrupamento hierárquico Centroid Linkage

  Por ser determinístico, o procedimento produziu métricas idênticas nas dez repetições de cada valor de $k$, e os resultados correspondem, portanto, a quatro partições distintas, uma para cada $k in {2, 3, 4, 5}$. A @tab:hier resume a silhueta (distância euclidiana) e o ARI de cada partição.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*Grupos*], [*Silhouette*], [*ARI*]),
      table.hline(),
      [2], [2], [0,686], [0,568],
      [3], [3], [0,554], [0,759],
      [4], [4], [0,472], [0,729],
      [5], [5], [0,382], [0,718],
      table.hline(),
    ),
    caption: [Centroid Linkage (distância euclidiana).],
    kind: table,
  ) <tab:hier>

  A @fig:hier-dend apresenta o dendrograma truncado. As últimas fusões evidenciam dois grandes ramos: o ramo da _setosa_, com 50 observações, e o ramo que reúne _versicolor_ e _virginica_. Dentro desse segundo ramo, as fusões são mais graduais e não indicam uma separação clara entre as duas espécies, o que torna a divisão em três grupos menos evidente do que a divisão em dois.

  #figure(
    image("../imagens/hierarchical_dendrogram.png", width: 100%),
    caption: [Dendrograma truncado do agrupamento hierárquico (Centroid Linkage, distância euclidiana), com linha de corte para a partição em $k = 3$.],
  ) <fig:hier-dend>

  Para $k = 2$, a partição separa a _setosa_ (50 observações) das demais espécies (100 observações), a mesma partição obtida pela Mistura Gaussiana, com silhueta de 0,686 e ARI de 0,568. A silhueta elevada reflete a separação da _setosa_, e o ARI é moderado porque _versicolor_ e _virginica_ permanecem juntas.

  Para $k = 3$, a _setosa_ permanece isolada e as demais observações são divididas em grupos de 64 e 36 observações. O grupo de 64 reúne as 50 _versicolor_ e 14 _virginica_, enquanto o de 36 contém apenas _virginica_. Assim, 14 das 150 observações (9,3%) ficam fora do agrupamento majoritário de sua espécie. A silhueta cai para 0,554 e o ARI sobe para 0,759, o maior valor entre as partições avaliadas.

  #figure(
    image("../imagens/hierarchical_k3_petal_clusters.png", width: 82%),
    caption: [Centroid Linkage com $k = 3$, projetado em `petal_length` × `petal_width`; os rótulos indicam a espécie majoritária de cada grupo.],
  ) <fig:hier-k3-clusters>

  Como o Centroid Linkage não é monotônico, o `cut_tree` pode retornar menos rótulos que o $k$ solicitado. Por isso, as partições desta análise foram reconstruídas a partir das primeiras $n-k$ fusões, garantindo exatamente $k$ grupos.

  Para $k = 4$, a silhueta é 0,472 e o ARI é 0,729. Para $k = 5$, são obtidos 0,382 e 0,718, respectivamente. As subdivisões ocorrem principalmente na região de _versicolor_ e _virginica_, e ambas as partições são efetivamente diferentes da configuração com $k = 3$.

  Considerando as partições efetivamente distintas, a silhueta decresce com o número de grupos e é máxima em $k = 2$ (0,686), enquanto o ARI é máximo em $k = 3$ (0,759). A silhueta favorece a separação geométrica entre _setosa_ e as demais espécies, enquanto o ARI reconhece $k = 3$ como a configuração mais compatível com as espécies, ainda que _versicolor_ e _virginica_ não sejam totalmente separadas. Por fim, como o procedimento não é iterativo nem aleatório, não há variabilidade entre execuções a ser avaliada, e os atributos foram usados sem normalização, o que pode influenciar as distâncias entre centróides e, portanto, a hierarquia obtida.

  == DBSCAN

  Foram avaliadas 40 configurações (oito valores de `eps` e cinco de `minpts`). Em 35 delas foram identificados pelo menos dois agrupamentos. Nas cinco restantes, não há silhueta válida nem ARI interpretável: três configurações classificaram todas as observações como ruído e duas formaram um único agrupamento. Nessas configurações, o ARI foi registrado como `NaN`, em vez de 1,0.

  A @fig:dbscan-ruido mostra que o ruído diminui com o aumento de `eps` e aumenta com `minpts`. Com `eps` = 0,2, entre 115 e 150 observações são ruído; com `eps` = 1,0, a quantidade cai para entre zero e duas observações, conforme `minpts`. A @fig:dbscan-cobertura resume essa mesma relação pela porcentagem da base não descartada.

  #figure(
    image("../imagens/dbscan_noise.png", width: 100%),
    caption: [DBSCAN: pontos de ruído em função de `eps`, para cada valor de `minpts`.],
  ) <fig:dbscan-ruido>

  #figure(
    image("../imagens/dbscan_coverage.png", width: 100%),
    caption: [DBSCAN: cobertura da base em função de `eps`, para cada valor de `minpts`.],
  ) <fig:dbscan-cobertura>

  A silhueta (@fig:dbscan-sil) não varia monotonicamente com `eps`. Os maiores valores aparecem com `eps` pequeno, mas acompanham descarte elevado da base: a configuração `eps` = 0,3 e `minpts` = 7 atinge silhueta 0,846 descartando 72% das observações. Para `eps` ≥ 0,7, os valores convergem entre 0,68 e 0,73. Como silhueta e ARI excluem o ruído, devem ser interpretados junto com a cobertura.

  #figure(
    image("../imagens/dbscan_silhouette.png", width: 100%),
    caption: [DBSCAN: silhueta em função de `eps`, para cada valor de `minpts`. Configurações com menos de dois agrupamentos não aparecem.],
  ) <fig:dbscan-sil>

  A @tab:dbscan reúne configurações representativas. Nas duas configurações de alto ARI e elevado ruído (`eps` = 0,3 / `minpts` = 7 e `eps` = 0,5 / `minpts` = 15), o valor 1,0 reflete apenas a concordância entre espécies dentro dos poucos pontos não descartados. Em uma análise auxiliar que trata o ruído como um grupo adicional, esses ARI seriam cerca de 0,25 e 0,50, respectivamente.

  #figure(
    table(
      columns: 6,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*`eps`*], [*`minpts`*], [*Grupos*], [*Ruído*], [*Silhouette*], [*ARI*]),
      table.hline(),
      [0,3], [7], [2], [108 (72,0%)], [0,846], [1,000],
      [0,4], [3], [4], [22 (14,7%)], [0,474], [0,890],
      [0,5], [15], [2], [86 (57,3%)], [0,813], [1,000],
      [0,6], [5], [2], [9 (6,0%)], [0,723], [0,584],
      [1,0], [5], [2], [0 (0,0%)], [0,686], [0,568],
      table.hline(),
    ),
    caption: [Configurações representativas. Silhueta e ARI calculados sem as observações de ruído.],
    kind: table,
  ) <tab:dbscan>

  A configuração visualizada (@fig:dbscan-clusters), `eps` = 0,6 e `minpts` = 5, foi escolhida pela maior silhueta entre aquelas com no máximo 10 pontos de ruído. Com silhueta 0,723, 9 pontos de ruído (6%) e ARI 0,584, ela separa a _setosa_ das demais espécies, mas funde _versicolor_ e _virginica_ em um único agrupamento.

  #figure(
    image("../imagens/dbscan_clusters.png", width: 100%),
    caption: [DBSCAN com `eps` = 0,6 e `minpts` = 5, projetado em `sepal_length` e `sepal_width`. O rótulo −1 indica ruído.],
  ) <fig:dbscan-clusters>

  Com `eps` = 0,4 e `minpts` = 3, o DBSCAN forma quatro agrupamentos, descarta 22 observações (14,7%) e alcança o maior ARI entre configurações com até 15% de ruído: 0,890, com silhueta 0,474. Conforme a @tab:dbscan-cont, três grupos correspondem majoritariamente às espécies, enquanto um quarto agrupa poucos pontos de _versicolor_. A @fig:dbscan-petalas mostra essa fragmentação no plano das pétalas.

  #figure(
    table(
      columns: 6,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Espécie*], [*Ruído*], [*G0*], [*G1*], [*G2*], [*G3*]),
      table.hline(),
      [_Setosa_], [3], [47], [0], [0], [0],
      [_Versicolor_], [4], [0], [39], [4], [3],
      [_Virginica_], [15], [0], [0], [0], [35],
      table.hline(),
    ),
    caption: [`eps` = 0,4 e `minpts` = 3: contingência entre espécies e grupos.],
    kind: table,
  ) <tab:dbscan-cont>

  #figure(
    image("../imagens/dbscan_eps04_minpts3_petals.png", width: 100%),
    caption: [DBSCAN com `eps` = 0,4 e `minpts` = 3 no plano das pétalas.],
  ) <fig:dbscan-petalas>

  A @fig:dbscan-eps-comparacao ilustra a sensibilidade a `eps`: com 0,4 há segmentação mais fragmentada; com 1,0, as espécies adjacentes são fundidas e não há ruído.

  #figure(
    image("../imagens/dbscan_eps04_eps10_comparison.png", width: 100%),
    caption: [DBSCAN no plano das pétalas: comparação entre `eps` = 0,4 e `eps` = 1,0, com `minpts` = 5.],
  ) <fig:dbscan-eps-comparacao>

  Em resumo, valores pequenos de `eps` fragmentam os dados e geram ruído; valores grandes eliminam o ruído, mas fundem _versicolor_ e _virginica_. Nenhuma configuração com ruído baixo e silhueta elevada recupera as três espécies. Assim, a melhor separação das espécies coexiste com maior descarte de observações ou com fragmentação adicional, evidenciando a dificuldade de aplicar um único raio a grupos de densidades distintas.

  == PCA

  A @tab:pca, com as principais saídas da biblioteca utilizada, resume quanta variância cada componente explica.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Componente*], [*Autovalor*], [*Proporção*], [*Acumulado*]),
      table.hline(),
      [1], [4,225], [0,925], [0,925],
      [2], [0,242], [0,053], [0,978],
      [3], [0,079], [0,017], [0,995],
      [4], [0,024], [0,005], [1,000],
      table.hline(),
    ),
    caption: [Autovalores e proporções de variância explicada do PCA.],
    kind: table,
  ) <tab:pca>


  Como mostra a @fig:pca-var, a variância concentra-se quase inteiramente nas duas primeiras componentes, que juntas explicam 97,8% do total. A PC1 é particularmente influenciada pela _petal_length_, enquanto a PC2 é mais influenciada pelas variáveis da sépala @tab:pca-loadings.

  #figure(
    table(
      columns: 5,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Componente*], [*`sepal_length`*], [*`sepal_width`*], [*`petal_length`*], [*`petal_width`*]),
      table.hline(),
      [PC1], [0,362], [−0,082], [0,857], [0,359],
      [PC2], [0,657], [0,730], [−0,176], [−0,075],
      [PC3], [−0,581], [0,596], [0,073], [0,549],
      [PC4], [0,317], [−0,324], [−0,480], [0,751],
      table.hline(),
    ),
    caption: [PCA: vetores das componentes (autovetores da matriz de covariância).],
    kind: table,
  ) <tab:pca-loadings>

  #figure(
    image("../imagens/pca_variance.png", width: 100%),
    caption: [PCA: proporção de variância explicada por componente e variância acumulada.],
  ) <fig:pca-var>

  #figure(
    image("../imagens/pca_scatter.png", width: 100%),
    caption: [PCA: observações projetadas nas duas primeiras componentes principais, coloridas pela espécie real.],
  ) <fig:pca-scatter>

  A projeção (@fig:pca-scatter) separa claramente a _setosa_, mas ainda há sobreposição entre _versicolor_ e _virginica_, como nos métodos de agrupamento. A silhueta no plano, calculada com as espécies reais como rótulos, é 0,5344, abaixo das demais técnicas de redução. Já a trustworthiness com dez vizinhos é 0,9830, indicando que a PCA preserva bem as relações de vizinhança locais.

  == Kernel PCA

  Como a PCA, o Kernel PCA foi executado uma só vez, com o kernel rbf, e o $gamma$ foi heuristicamente definido como 0,25, o inverso do número de atributos. A decomposição espectral retornou 146 autovalores, cuja soma é 91,91; conforme descrito na metodologia, a proporção de cada componente foi calculada em relação a essa soma. A @tab:kpca apresenta as quatro primeiras componentes.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Componente*], [*Autovalor ($lambda$)*], [*Proporção*], [*Acumulado*]),
      table.hline(),
      [1], [48,082], [0,523], [0,523],
      [2], [19,092], [0,208], [0,731],
      [3], [6,624], [0,072], [0,803],
      [4], [4,313], [0,047], [0,850],
      table.hline(),
    ),
    caption: [Kernel PCA (RBF, $gamma = 0,25$): autovalores e proporções em relação à soma dos 146 autovalores retornados (91,91).],
    kind: table,
  ) <tab:kpca>

  Em contraste com a PCA linear, a variância no espaço de características induzido pelo kernel se espalha por um número maior de direções (@fig:kpca-var), de forma que a quarta componente ainda responde por 4,7% da soma dos autovalores, e a cauda do espectro se estende por dezenas de componentes.

  #figure(
    image("../imagens/kpca_variance.png", width: 100%),
    caption: [Kernel PCA (RBF, $gamma = 0,25$): proporção dos autovalores nas dez primeiras componentes e acumulado.],
  ) <fig:kpca-var>

  #figure(
    image("../imagens/kpca_scatter.png", width: 100%),
    caption: [Kernel PCA (RBF, $gamma = 0,25$): observações projetadas nas duas primeiras componentes, coloridas pela espécie real.],
  ) <fig:kpca-scatter>

  Na projeção (@fig:kpca-scatter), a _setosa_ permanece separada das demais espécies, enquanto _versicolor_ e _virginica_ apresentam maior distinção do que na PCA linear. Essa separação ocorre sobretudo na segunda componente, visto que os centróides das duas espécies quase coincidem na primeira (−0,36 e −0,42), mas se afastam na segunda (−0,36 e 0,34). Nas métricas complementares, a silhueta no plano é de 0,607, superior à da PCA linear (0,534), mas inferior às do t-SNE (0,632) e do UMAP (0,675). Já a trustworthiness com dez vizinhos cai para 0,938, contra 0,983 na PCA. Portanto, nota-se que essa representação introduziu vizinhos artificiais, indicando uma distorção na estrutura, apesar da separação melhor.

  == t-SNE

  Foram avaliadas as perplexidades 5, 10, 20 e 30, com inicialização por PCA, taxa de aprendizado automática, limite de 1000 iterações e semente 42. Todas as execuções registraram 999 iterações. A @tab:tsne resume a silhueta, calculada no espaço bidimensional com as espécies reais como rótulos, a divergência de Kullback-Leibler (KL) e a trustworthiness com dez vizinhos.

  #figure(
    table(
      columns: 5,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Perplexidade*], [*Silhouette*], [*Divergência KL*], [*Iterações*], [*Trustworthiness*]),
      table.hline(),
      [5], [0,558], [0,338], [999], [0,982],
      [10], [0,610], [0,280], [999], [0,987],
      [20], [0,629], [0,179], [999], [0,990],
      [30], [0,632], [0,119], [999], [0,990],
      table.hline(),
    ),
    caption: [t-SNE com as espécies reais.],
    kind: table,
  ) <tab:tsne>

  A silhueta cresce com a perplexidade (@fig:tsne-comp), com ganhos decrescentes: 0,052 de 5 para 10, 0,019 de 10 para 20 e 0,003 de 20 para 30. A divergência KL diminui continuamente de 0,338 para 0,119, mas seus valores não são estritamente comparáveis entre perplexidades. Portanto, ela foi usada apenas como informação complementar, e a configuração foi selecionada pela silhueta.

  Na análise de estabilidade da perplexidade 30, as sementes de 0 a 9 produziram silhueta média de 0,632 e trustworthiness média de 0,990, ambas sem desvio padrão amostral relevante. Esses resultados indicam estabilidade das métricas nesse conjunto de execuções, mas não avaliam a robustez em novas amostras ou configurações.

  #figure(
    image("../imagens/tsne_perplexity_comparison.png", width: 100%),
    caption: [t-SNE: silhueta e divergência KL em função da perplexidade.],
  ) <fig:tsne-comp>

  Os embeddings da @fig:tsne-emb mostram o efeito da perplexidade sobre a estrutura obtida. Com perplexidade 5, a ênfase na vizinhança muito local fragmenta os dados: a _setosa_ aparece dividida em três subgrupos, e _versicolor_ também se divide em vários blocos, o que produz subestruturas que não correspondem a diferenças entre espécies. Com perplexidade 10, a _setosa_ forma um único grupo alongado, enquanto _versicolor_ e _virginica_ ocupam regiões distintas, mas com alguns pontos de _versicolor_ dentro da região de _virginica_. Com perplexidades 20 e 30, a _setosa_ forma um grupo compacto e bem afastado, e _versicolor_ e _virginica_ formam uma região contínua, com sobreposição parcial na fronteira entre elas.

  #figure(
    image("../imagens/tsne_embeddings_perplexities.png", width: 100%),
    caption: [t-SNE: embeddings bidimensionais para as perplexidades 5, 10, 20 e 30, coloridos pela espécie real.],
  ) <fig:tsne-emb>

  A configuração selecionada foi a de perplexidade 30, com silhueta de 0,632 e divergência KL de 0,119. Nela, a _setosa_ está completamente isolada das demais espécies, enquanto _versicolor_ e _virginica_ formam uma faixa contínua com sobreposição parcial na fronteira. Esse resultado é consistente com os métodos de agrupamento, nos quais a _setosa_ é separada de forma consistente e a principal dificuldade ocorre entre as outras duas espécies.

  O t-SNE preserva principalmente relações de vizinhança, de modo que distâncias e tamanhos dos grupos no embedding não refletem diretamente o espaço original. A silhueta mede a separação das espécies reais no plano e não a qualidade de um agrupamento, por isso não é comparável às silhuetas dos métodos de agrupamento. Já a trustworthiness, mede a preservação dos dez vizinhos mais próximos sendo uma métrica complementar. A comparação principal foi feita com a semente 42 e atributos sem normalização.

  == UMAP

  Foram avaliadas 12 configurações, combinando `n_neighbors` ∈ {5, 10, 15, 30} e `min_dist` ∈ {0,0; 0,1; 0,5}, com distância euclidiana, dois componentes e semente 42. A silhueta foi calculada no espaço bidimensional, com as espécies reais como rótulos. A @tab:umap apresenta os resultados.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*`n_neighbors`*], [*`min_dist` = 0,0*], [*`min_dist` = 0,1*], [*`min_dist` = 0,5*]),
      table.hline(),
      [5], [0,606], [0,611], [0,614],
      [10], [*0,675*], [0,651], [0,579],
      [15], [0,623], [0,662], [0,610],
      [30], [0,668], [0,656], [0,631],
      table.hline(),
    ),
    caption: [Silhueta por configuração. Em destaque, o maior valor.],
    kind: table,
  ) <tab:umap>

  A silhueta variou entre 0,579 (`n_neighbors` = 10 e `min_dist` = 0,5) e 0,675 (`n_neighbors` = 10 e `min_dist` = 0,0), conforme a @fig:umap-sil. Com `min_dist` = 0,5, as silhuetas ficaram entre 0,579 e 0,631 para `n_neighbors` ≥ 10, enquanto as configurações com `n_neighbors` = 5 ficaram próximas (0,606--0,614). A trustworthiness com dez vizinhos permaneceu elevada em todas as configurações (0,976--0,982).

  A @tab:umap-sementes resume a estabilidade das quatro melhores configurações pela silhueta obtida com a semente 42, avaliadas em dez sementes.

  #figure(
    table(
      columns: 5,
      align: center,
      stroke: none,
      table.hline(),
      table.header(
        [*`n_neighbors`*], [*`min_dist`*], [*Silhueta média*], [*DP silhueta*], [*Trustworthiness média (DP)*]
      ),
      table.hline(),
      [10], [0,0], [0,658], [0,016], [0,978 (0,002)],
      [30], [0,0], [0,664], [0,012], [0,979 (0,001)],
      [15], [0,1], [0,643], [0,016], [0,979 (0,001)],
      [30], [0,1], [0,645], [0,011], [0,980 (0,001)],
      table.hline(),
    ),
    caption: [Estabilidade das quatro melhores configurações em dez sementes (0 a 9). Os desvios são padrões amostrais.],
    kind: table,
  ) <tab:umap-sementes>

  Entre essas configurações, `n_neighbors` = 30 e `min_dist` = 0,0 obteve a maior silhueta média (0,664 ± 0,012), seguida por `n_neighbors` = 10 e `min_dist` = 0,0 (0,658 ± 0,016). A diferença é pequena, assim como o desvio padrão das quatro configurações (0,011--0,016), com trustworthiness média entre 0,978 e 0,980. Os resultados indicam estabilidade satisfatória, sem uma vantagem expressiva de uma única configuração.

  #figure(
    image("../imagens/umap_parameter_comparison.png", width: 100%),
    caption: [UMAP: silhueta em função de `n_neighbors`, para cada valor de `min_dist`.],
  ) <fig:umap-sil>

  Os embeddings da @fig:umap-emb mostram o efeito dos parâmetros. Com `n_neighbors` = 5, a ênfase em vizinhanças locais fragmenta os dados, enquanto `min_dist` = 0,5 dispersa os pontos em estruturas mais contínuas. Com `n_neighbors` = 10 e `min_dist` = 0,0, os grupos são compactos e _versicolor_ e _virginica_ aparecem mais distintos. Em `n_neighbors` = 30, as duas espécies formam uma faixa contínua com sobreposição parcial para todos os valores de `min_dist`. A _setosa_ permanece completamente separada em todas as configurações.

  #figure(
    image("../imagens/umap_embeddings_parameters.png", width: 100%),
    caption: [UMAP: embeddings bidimensionais para as 12 combinações de `n_neighbors` e `min_dist`, coloridos pela espécie real.],
  ) <fig:umap-emb>

  A configuração selecionada foi `n_neighbors` = 10 e `min_dist` = 0,0, a de maior silhueta na semente 42 (0,675). Nela, a _setosa_ está isolada e _versicolor_ e _virginica_ ocupam regiões vizinhas, com poucos pontos misturados. A separação entre essas duas espécies não é completa. A silhueta supera a maior obtida pelo t-SNE (0,632, @tab:tsne); ambas foram calculadas no espaço bidimensional com as espécies reais.

]
