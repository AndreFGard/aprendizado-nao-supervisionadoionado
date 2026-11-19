#let results-and-discussions = [
  = Resultados e discussões

  == K-Means

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

  == Fuzzy K-Means

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

  A silhueta média decresce de 0,686 em $k = 2$ para 0,396 em $k = 5$, indicando que a separação geométrica é favorecida por menos grupos. Em contraste, o ARI médio é máximo em $k = 3$ (0,765), assim como o ARI máximo observado (0,818). Esses resultados evidenciam a divergência entre os critérios interno e externo.

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

  Para $k = 2$, a partição separa a _setosa_ (50 observações) das demais espécies (100 observações), com silhueta de 0,686 e ARI de 0,568. A silhueta elevada reflete a separação da _setosa_; o ARI é moderado porque _versicolor_ e _virginica_ permanecem juntas.

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

  == Kernel PCA

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
      table.header([*`n_neighbors`*], [*`min_dist`*], [*Silhueta média*], [*DP silhueta*], [*Trustworthiness média (DP)*]),
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
