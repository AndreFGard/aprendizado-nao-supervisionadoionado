#let results-and-discussions = [
  = Resultados e discussões <sec:results>

  == K-Means

  Foram realizadas 40 execuções, com $k in {2, 3, 4, 5}$ e dez sementes por valor de $k$, com a heurística de inicialização padrão _kmeans++_. Para cada $k$, foi selecionada a execução de menor SSE e, entre as quatro partições resultantes, o número de grupos foi escolhido por $k^* = "arg max"_k "Sil"(k)$. A @tab:kmeans resume os resultados.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*Silhouette*], [*ARI*], [*SSE*]),
      table.hline(),
      [2], [0,580], [0,568], [223,7],
      [3], [0,459], [0,620], [141,0],
      [4], [0,387], [0,472], [114,4],
      [5], [0,343], [0,415], [91,1],
      table.hline(),
    ),
    caption: [K-Means (dados padronizados, `k-means++`): métricas da execução de menor SSE em cada $k$.],
    kind: table,
  ) <tab:kmeans>

  A silhueta é máxima em $k = 2$ (0,580), de modo que $k^* = 2$, e a partição correspondente tem ARI de 0,568 (@fig:kmeans-sil). Em $k = 2$ as dez sementes convergiram para a mesma solução, indicando a estabilidade desse particionamento.

  #figure(
    image("../imagens/kmeans_silhouette.png", width: 100%),
    caption: [Silhouette em função do número de clusters $k$ (K-Means).],
  ) <fig:kmeans-sil>


  A partição com $k^* = 2$ separa as 50 _setosa_ e reúne as outras duas espécies em outro, explicando a silhueta alta e o ARI moderado. O ARI é máximo em $k = 3$ (0,620), quando 25 das 150 observações (16,7%), todas de _versicolor_/_virginica_, ficam fora do grupo majoritário. Assim, nota-se que a silhueta reduz conforme $k$ aumenta, e ARI também reduz após o seu máximo.

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
      [2], [0,608], [0,531], [270,2],
      [3], [0,488], [0,665], [208,1],
      [4], [0,370], [0,611], [200,4],
      [5], [0,293], [0,492], [187,2],
      table.hline(),
    ),
    caption: [K-Medoids (distância city-block)],
    kind: table,
  ) <tab:kmedoids>

  A silhueta diminui com $k$ (@fig:kmed-sil), atingindo o máximo em $k = 2$ (0,608). A inércia também diminui continuamente (@fig:kmed-inercia). Entre $k = 2$ e $k = 3$, a queda é de 62,1 (23,0%); em seguida, passa a 7,7 (3,7%) e a 13,2 (6,6%), sem um cotovelo tão pronunciado.

  #figure(
    image("../imagens/kmedoids_silhouette.png", width: 100%),
    caption: [Silhouette em função do número de agrupamentos $k$ (K-Medoids).],
  ) <fig:kmed-sil>

  #figure(
    image("../imagens/kmedoids_inertia.png", width: 100%),
    caption: [Inércia em função do número de agrupamentos $k$ (K-Medoids).],
  ) <fig:kmed-inercia>

  A análise externa mostra que o ARI é máximo em $k = 3$ (0,665). Em todas as configurações, os 50 exemplares de _Iris setosa_ ficam isolados em um agrupamento, e as diferenças principais ocorrem na região de sobreposição entre _versicolor_ e _virginica_. Para $k = 2$, um agrupamento reúne as 50 _setosa_ e 2 _versicolor_, e o outro reúne 48 _versicolor_ e as 50 _virginica_. A silhueta elevada reflete a separação nítida da _setosa_ em relação ao restante. O ARI é menor porque a partição funde duas espécies.

  #figure(
    image("../imagens/kmedoids_clusters.png", width: 100%),
    caption: [Agrupamento por K-Medoids com $k = 3$, projetado em `petal_length` × `petal_width`; os rótulos indicam a espécie majoritária de cada grupo e os marcadores em formato `X` representam os medóides.],
  ) <fig:kmed-clusters>

  Para $k = 3$, a _setosa_ permanece isolada, mas a separação entre _versicolor_ e _virginica_ é menos precisa: o ARI é 0,665 e a silhueta é 0,488. A @fig:kmed-clusters apresenta essa configuração projetada em comprimento e largura das pétalas. Esse resultado é compatível com a fronteira difusa entre as duas espécies.

  Com $k = 4$ e $k = 5$, os grupos adicionais subdividem a região de _versicolor_ e _virginica_ sem corresponder a novas espécies. Em ambos os casos, a silhueta diminui e o ARI não supera o de $k = 3$.

  Os resultados mostram uma divergência entre os critérios: a silhueta favorece $k = 2$, enquanto o ARI favorece $k = 3$. Assim, $k = 2$ apresenta a melhor separação geométrica, mas $k = 3$ oferece o melhor compromisso com as espécies.

  == Fuzzy K-Means

  Foram realizadas 120 execuções, com $k in {2, 3, 4, 5}$ e $m in {1.5, 2.0, 2.5}$, dez sementes por combinação. Para cada par $(k, m)$, foi selecionada a execução de menor $J_m$. Em seguida, o par $(k, m)$ de maior silhueta foi escolhido, de modo que a curva $"Sil"(k)$ mostra o melhor $m$ para cada $k$. A @tab:fkm resume as quatro partições selecionadas por $k$.

  #figure(
    table(
      columns: 5,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*$m$*], [*Silhouette*], [*ARI*], [*Objetivo ($J_m$)*]),
      table.hline(),
      [2], [1,5], [0,580], [0,568], [214,8],
      [3], [1,5], [0,459], [0,620], [131,3],
      [4], [2,0], [0,401], [0,588], [74,5],
      [5], [1,5], [0,339], [0,425], [81,2],
      table.hline(),
    ),
    caption: [Fuzzy K-Means (dados padronizados): por $k$, maior silhueta entre os valores de $m$; $J_m$ mínimo entre sementes para o $(k, m)$ selecionado.],
    kind: table,
  ) <tab:fkm>

  A silhueta decresce de 0,580 em $k = 2$ para 0,339 em $k = 5$ (@fig:fkm-sil). O par selecionado foi $(k = 2, m = 1,5)$, com silhueta 0,580 e ARI 0,568; em $k = 2$ os três valores de $m$ produzem a mesma partição e a mesma silhueta, e o empate foi resolvido pelo menor $m$. Como $J_m$ não é comparável entre valores de $m$, ele não foi usado para escolher o par; a seleção de $(k, m)$ usou apenas a silhueta interna. O ARI é avaliação externa e não participa da seleção.

  #figure(
    image("../imagens/fuzzy_kmeans_silhouette.png", width: 100%),
    caption: [Silhouette em função do número de agrupamentos $k$ (Fuzzy K-Means), mostrando o melhor $m$ para cada $k$.],
  ) <fig:fkm-sil>


  Entre as partições selecionadas para cada $k$, o ARI é máximo em $k = 3$ (0,620 com $m = 1,5$), com silhueta 0,459, enquanto a partição de $k^* = 2$ isola as 50 _setosa_, como no K-Means. O máximo global de ARI no grid é 0,630 ($k = 3$, $m = 2,0$), mas esse par não maximiza a silhueta. Não houve variabilidade entre sementes em $k = 2$ e $k = 3$ para nenhum valor de $m$, mas em $k = 4$ e $k = 5$ apareceram mínimos locais. Em $k = 3$, 25 das 150 observações (16,7%) ficam fora do grupo majoritário, similarmente ao KMeans.

  Nesse sentido, destaca-se a semelhança com o K-Means também em $k^* = 2$, cuja partição crisp é idêntica à do K-Means para os três valores de $m$. A matriz de pertinências, porém, muda. Entre $m = 1,5$ e $m = 2,5$ a diferença em norma de Frobenius é 2,80, com variação máxima de 0,26 em uma observação: a suavização existe, mas desaparece quando arredondamos para um único grupo. A @fig:fkm-pert mostra os dois extremos na mesma ordenação por espécie (painéis empilhados), evidenciando pertinências mais difusas em $m = 2,5$ sem nenhuma troca de grupo. A diferença de silhueta entre $m = 1,5$ e $m = 2,0$ em $k = 3$ é de só 0,002 (0,459 contra 0,457), mas isso é uma comparação isolada. O apêndice reúne os doze pares $(k, m)$ e índices fuzzy próprios; como a silhueta é calculada sobre rótulos crisp, ela premia $m$ pequeno por construção, e PC, PE e Xie–Beni entram como contraponto, não como nova regra de escolha.

  #figure(
    image("../imagens/fuzzy_memberships.png", width: 100%),
    caption: [Fuzzy K-Means em $k = 2$: pertinências para $m = 1,5$ (selecionado, acima) e $m = 2,5$ (abaixo), na mesma ordenação por espécie. As partições crisp coincidem; a diferença entre as matrizes ($norm(Delta U)_F = 2,80$, máx. $0,26$) mede a suavização sem troca de grupo.],
  ) <fig:fkm-pert>


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
      [2], [0,580], [0,580], [0,568], [0,568],
      [3], [0,456], [0,456], [0,652], [0,652],
      [4], [0,258], [0,258], [0,612], [0,612],
      [5], [0,286], [0,286], [0,487], [0,487],
      table.hline(),
    ),
    caption: [Kernel Fuzzy K-Means: considerando todas as combinações de $m$, $sigma^2$ e sementes.],
    kind: table,
  ) <tab:kfkm>

  Para cada valor de $k$, foi selecionada pela menor função objetivo uma única partição entre as dez inicializações e combinações de parâmetros. A silhueta dessas partições decresce após $k = 2$: 0,580 em $k = 2$, 0,456 em $k = 3$, 0,258 em $k = 4$ e 0,286 em $k = 5$. Assim, $k^* = 2$ pela silhueta. O ARI da partição final é 0,568.

  Pela maior silhueta entre as partições selecionadas por objetivo, a configuração final foi $k = 2$, $m = 2,5$ e $sigma^2 = 2,0$, com silhueta de 0,5802 e ARI de 0,5681. Essa solução separa a _setosa_ das demais espécies. Na @fig:kfkm-pert, a _setosa_ apresenta pertinência elevada a um agrupamento, enquanto as espécies _versicolor_ e _virginica_ mostram pertinências intermediárias na região de fronteira. A atribuição pelo maior grau de pertinência produz a partição exibida na @fig:kfkm-clusters.

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_memberships.png", width: 100%),
    caption: [Graus de pertinência da melhor configuração por silhueta ($k = 2$, $m = 2,5$, $sigma^2 = 2,0$).],
  ) <fig:kfkm-pert>

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_clusters.png", width: 100%),
    caption: [Melhor agrupamento por silhueta, projetado em `sepal_length` e `sepal_width`.],
  ) <fig:kfkm-clusters>

  A @fig:kfkm-conv mostra a convergência da configuração selecionada. Como os valores da função objetivo dependem de $m$ e de $sigma^2$, eles não são usados para comparar configurações.

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_objective_convergence.png", width: 100%),
    caption: [Convergência da função objetivo da melhor configuração por silhueta.],
  ) <fig:kfkm-conv>

  Os ARI das outras partições por $k$ são apresentados somente como avaliação externa: 0,652 em $k = 3$, 0,612 em $k = 4$ e 0,487 em $k = 5$. Essas métricas não participam da escolha de $k^*$ nem da escolha da execução. Valores extremos dos parâmetros produziram instabilidade em algumas execuções.

  Na partição final em $k^* = 2$, a atribuição pelo maior grau de pertinência reproduz a separação da _setosa_ e concentra as confusões entre _versicolor_ e _virginica_ (@tab:kfkm-k3-contingencia).

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

  Em síntese, o Kernel Fuzzy K-Means separa a _setosa_ das demais espécies e apresenta maior dificuldade na fronteira entre _versicolor_ e _virginica_.

  == Misturas gaussianas com EM

  Foi feita a busca de parâmetros com $k in {2, 3, 4, 5}$ e $"covariance_type" in {"spherical", "diag", "tied", "full"}$, dez inicializações cada. Em cada execução, a partição _crisp_ usada nas métricas foi obtida atribuindo cada observação ao componente de maior probabilidade a posteriori. Para cada par $(k, "covariance_type")$, foi mantida a semente de menor log-verossimilhança negativa; entre os quatro tipos, foi mantido o de menor BIC. A @tab:em resume as quatro configurações selecionadas.

  #figure(
    table(
      columns: 6,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*Covariância*], [*Silhouette*], [*ARI*], [*Objetivo ($-"log" L$)*], [*BIC*]),
      table.hline(),
      [2], [`full`], [0,580], [0,568], [326,2], [797,7],
      [3], [`full`], [0,373], [0,904], [292,0], [804,5],
      [4], [`tied`], [0,317], [0,822], [347,3], [839,9],
      [5], [`tied`], [0,300], [0,727], [326,7], [823,8],
      table.hline(),
    ),
    caption: [Misturas gaussianas com EM: por $k$, tipo de covariância de menor BIC, $-$log-verossimilhança mínima, ARI],
    kind: table,
  ) <tab:em>

  A silhueta das configurações selecionadas decresce de 0,580 em $k = 2$ para 0,300 em $k = 5$ (@fig:em-sil), de modo que $k^* = 2$, como nos demais métodos. Nesse valor, a partição _crisp_ isola as 50 _setosa_ em um grupo e reúne as 100 observações de _versicolor_ e _virginica_ no outro, que é a mesma partição obtida pelo K-Means padronizado. Em $k = 2$, todas as execuções produzem essa mesma partição, diferindo apenas no número de parâmetros e, portanto, no BIC.

  #figure(
    image("../imagens/em_silhouette.png", width: 100%),
    caption: [Silhouette em função do número de clusters $k$ (misturas gaussianas com EM).],
  ) <fig:em-sil>

  O tipo de covariância, escolhido por BIC, não foi decidido por diferença marginal. A @tab:em-bic mostra o grid completo: em $k = 3$, `full` fica com 804,5, contra 855,7 de `tied`, 968,2 de `diag` e 1231,7 de `spherical`; a folga sobre o segundo colocado é 51,1. Em $k = 2$, 4 e 5 as folgas são 112,7, 8,8 e 19,6 — todas acima de 6, limiar usual de evidência forte @kass1995bayes. O menor BIC global ocorre em $k = 2$ (797,7), apontando na mesma direção da silhueta; `em_bic_decomposition.csv` registra como penalidade e verossimilhança se combinam em cada valor.

  #figure(
    table(
      columns: 6,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*Spherical*], [*Diag*], [*Tied*], [*Full*], [*Folga p/ 2º*]),
      table.hline(),
      [2], [1334,7], [1081,7], [910,4], [*797,7*], [112,7],
      [3], [1231,7], [968,2], [855,7], [*804,5*], [51,1],
      [4], [1147,9], [929,3], [*839,9*], [848,7], [8,8],
      [5], [1111,4], [925,0], [*823,8*], [843,4], [19,6],
      table.hline(),
    ),
    caption: [EM: BIC por tipo de covariância e número de componentes. Em negrito, a menor estratégia de cada $k$; a última coluna é a diferença para a segunda melhor.],
    kind: table,
  ) <tab:em-bic>

  Como diagnóstico externo, vale registrar que o ARI em $k = 3$ sobe para 0,904, contra 0,568 em $k^* = 2$; a silhueta desse modelo cai para 0,373, e é por isso que ele não foi escolhido.

  As cinco observações que saem do grupo majoritário em $k = 3$ são _versicolor_ alocadas junto às _virginica_. A @tab:em-k3-cont e `em_k3_contingency.csv` trazem as contagens, e a @fig:em-clusters-k3 mostra a partição no plano das pétalas. O mapa de posteriores (@fig:em-post) reforça a leitura: a entropia média é 0,032, a probabilidade máxima mínima é 0,635 e nenhuma observação fica abaixo de 0,6. A incerteza existe, mas é localizada nos pontos de fronteira.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Espécie*], [*G0*], [*G1*], [*G2*]),
      table.hline(),
      [Setosa], [0], [50], [0],
      [Versicolor], [45], [0], [5],
      [Virginica], [0], [0], [50],
      table.hline(),
    ),
    caption: [EM em $k = 3$: contingência entre espécies reais e o grupo de maior posterior. Os 5 erros são _versicolor_ no grupo majoritariamente _virginica_.],
    kind: table,
  ) <tab:em-k3-cont>

  #figure(
    image("../imagens/em_clusters_k3.png", width: 90%),
    caption: [EM em $k = 3$ no plano `petal_length` × `petal_width`; a legenda informa a composição de cada grupo.],
  ) <fig:em-clusters-k3>

  #figure(
    image("../imagens/em_posteriors.png", width: 100%),
    caption: [EM em $k = 3$: posteriores ordenados por espécie e confiança da atribuição no plano das pétalas; em vermelho, as observações fora do grupo majoritário.],
  ) <fig:em-post>


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
      [2], [2], [0,580], [0,568],
      [3], [3], [0,479], [0,562],
      [4], [4], [0,406], [0,552],
      [5], [5], [0,374], [0,551],
      table.hline(),
    ),
    caption: [Centroid Linkage (distância euclidiana).],
    kind: table,
  ) <tab:hier>

  A @fig:hier-dend apresenta o dendrograma truncado. As últimas fusões evidenciam dois grandes ramos: o ramo da _setosa_, com 50 observações, e o ramo que reúne _versicolor_ e _virginica_. Dentro desse segundo ramo, as fusões são mais graduais e não indicam uma separação clara entre as duas espécies, o que torna a divisão em três grupos menos evidente do que a divisão em dois.

  #figure(
    image("../imagens/hierarchical_dendrogram.png", width: 100%),
    caption: [Dendrograma truncado do agrupamento hierárquico (Centroid Linkage, distância euclidiana), com linha de corte para a partição em $k^* = 2$.],
  ) <fig:hier-dend>

  Para $k = 2$, a partição separa a _setosa_ (50 observações) das demais espécies (100 observações), a mesma partição obtida pela Mistura Gaussiana, com silhueta de 0,580 e ARI de 0,568. A silhueta elevada reflete a separação da _setosa_, e o ARI é moderado porque _versicolor_ e _virginica_ permanecem juntas.

  Para $k = 3$, a _setosa_ permanece isolada e as demais observações são divididas em grupos menores, com silhueta de 0,479 e ARI de 0,562. A separação entre _versicolor_ e _virginica_ permanece limitada.

  #figure(
    image("../imagens/hierarchical_kstar_petal_clusters.png", width: 82%),
    caption: [Centroid Linkage com $k^* = 2$, projetado em `petal_length` × `petal_width`; os rótulos indicam a espécie majoritária de cada grupo.],
  ) <fig:hier-kstar-clusters>

  Como o Centroid Linkage não é monotônico, o `cut_tree` pode retornar menos rótulos que o $k$ solicitado. Por isso, as partições desta análise foram reconstruídas a partir das primeiras $n-k$ fusões, garantindo exatamente $k$ grupos.

  Para $k = 4$, a silhueta é 0,406 e o ARI é 0,552. Para $k = 5$, são obtidos 0,374 e 0,551, respectivamente. As subdivisões ocorrem principalmente na região de _versicolor_ e _virginica_, e ambas as partições são efetivamente diferentes da configuração com $k = 3$.

  Considerando as partições efetivamente distintas, a silhueta decresce com o número de grupos e é máxima em $k = 2$ (0,580), enquanto o ARI permanece máximo em $k = 3$ (0,562). A silhueta favorece a separação geométrica entre _setosa_ e as demais espécies, enquanto o ARI reconhece a dificuldade de separar _versicolor_ e _virginica_. Por fim, como o procedimento não é iterativo nem aleatório, não há variabilidade entre execuções a ser avaliada.

  == DBSCAN

  Foram avaliadas 40 configurações (oito valores de `eps` e cinco de `minpts`). Em 32 delas foram identificados pelo menos dois agrupamentos. Nas oito restantes, não há silhueta válida nem ARI interpretável: sete configurações classificaram todas as observações como ruído e uma formou um único agrupamento. Nessas configurações, o ARI foi registrado como `NaN`, em vez de 1,0.

  A @fig:dbscan-ruido mostra que o ruído diminui com o aumento de `eps` e aumenta com `minpts`. Com `eps` = 0,2, entre 132 e 150 observações são ruído; com `eps` = 1,0, a quantidade varia entre uma e seis observações, conforme `minpts`. A @fig:dbscan-cobertura resume essa mesma relação pela porcentagem da base não descartada.

  #figure(
    image("../imagens/dbscan_noise.png", width: 100%),
    caption: [DBSCAN: pontos de ruído em função de `eps`, para cada valor de `minpts`.],
  ) <fig:dbscan-ruido>

  #figure(
    image("../imagens/dbscan_coverage.png", width: 100%),
    caption: [DBSCAN: cobertura da base em função de `eps`, para cada valor de `minpts`.],
  ) <fig:dbscan-cobertura>

  A silhueta (@fig:dbscan-sil) não varia monotonicamente com `eps`. Na configuração selecionada, `eps` = 0,7 e `minpts` = 5, a silhueta é 0,610, com 8 observações classificadas como ruído e cobertura de 94,7%. Como silhueta e ARI excluem o ruído, devem ser interpretados junto com a cobertura.

  #figure(
    image("../imagens/dbscan_silhouette.png", width: 100%),
    caption: [DBSCAN: silhueta em função de `eps`, para cada valor de `minpts`. Configurações com menos de dois agrupamentos não aparecem.],
  ) <fig:dbscan-sil>

  A @tab:dbscan reúne configurações representativas. Como a silhueta e o ARI excluem as observações de ruído, os valores obtidos em configurações com baixo número de pontos válidos devem ser interpretados junto com a cobertura.

  #figure(
    table(
      columns: 6,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*`eps`*], [*`minpts`*], [*Grupos*], [*Ruído*], [*Silhouette*], [*ARI*]),
      table.hline(),
      [0,3], [7], [2], [128 (85,3%)], [0,634], [0,000],
      [0,4], [3], [10], [39 (26,0%)], [0,418], [0,621],
      [0,5], [15], [1], [127 (84,7%)], [--], [--],
      [0,6], [5], [2], [26 (17,3%)], [0,641], [0,611],
      [1,0], [5], [2], [3 (2,0%)], [0,594], [0,568],
      table.hline(),
    ),
    caption: [Configurações representativas. Silhueta e ARI calculados sem as observações de ruído.],
    kind: table,
  ) <tab:dbscan>

  #figure(
    image("../imagens/dbscan_clusters.png", width: 100%),
    caption: [DBSCAN com `eps` = 0,7 e `minpts` = 5, projetado em `sepal_length` e `sepal_width`. O rótulo −1 indica ruído.],
  ) <fig:dbscan-clusters>

  Com `eps` = 0,4 e `minpts` = 3, o DBSCAN forma dez agrupamentos e descarta 39 observações (26,0%), obtendo silhueta 0,418 e ARI 0,621. A @tab:dbscan-cont apresenta a contingência dessa configuração normalizada com as espécies reais. A @fig:dbscan-petalas mostra essa fragmentação no plano das pétalas.

  #figure(
    table(
      columns: 12,
      align: center,
      stroke: none,
      table.hline(),
      table.header(
        [*Espécie*], [*Ruído*], [*G0*], [*G1*], [*G2*], [*G3*], [*G4*], [*G5*], [*G6*], [*G7*], [*G8*], [*G9*]
      ),
      table.hline(),
      [_Setosa_], [9], [41], [0], [0], [0], [0], [0], [0], [0], [0], [0],
      [_Versicolor_], [9], [0], [17], [19], [3], [2], [0], [0], [0], [0], [0],
      [_Virginica_], [21], [0], [5], [0], [0], [1], [3], [5], [9], [3], [3],
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
      [1], [2,930], [0,728], [0,728],
      [2], [0,927], [0,230], [0,958],
      [3], [0,148], [0,037], [0,995],
      [4], [0,021], [0,005], [1,000],
      table.hline(),
    ),
    caption: [Autovalores e proporções de variância explicada do PCA (dados padronizados).],
    kind: table,
  ) <tab:pca>


  A @fig:pca-var mostra que as duas primeiras componentes reúnem 95,8% da variância: 72,8% na PC1 e 23% na PC2. Pelos coeficientes da @tab:pca-loadings, a PC1 #footnote[Um estudo à parte comprovou que a normalização é particularmente importante para o PCA, e o seu uso tornou os coeficientes mais balanceados.] combina principalmente `sepal_length`, `petal_length` e `petal_width`, e a PC2 é dominada por `sepal_width`.

  #figure(
    table(
      columns: 5,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Componente*], [*`sepal_length`*], [*`sepal_width`*], [*`petal_length`*], [*`petal_width`*]),
      table.hline(),
      [PC1], [0,522], [−0,263], [0,581], [0,566],
      [PC2], [0,372], [0,926], [0,021], [0,065],
      [PC3], [0,721], [−0,242], [−0,141], [−0,634],
      [PC4], [−0,262], [0,124], [0,801], [−0,524],
      table.hline(),
    ),
    caption: [PCA: vetores das componentes (autovetores da matriz de correlação).],
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

  Na projeção (@fig:pca-scatter), a _setosa_ fica bem separada, enquanto _versicolor_ e _virginica_ ainda se sobrepõem. A silhueta interna é 0,613 para a partição de K-Means com $k = 2$, e resume a coesão e a separação desses grupos. Já a silhueta externa, calculada com as espécies reais, foi menos satisfatória, alcançando 0,400. Por outro lado, a trustworthiness com dez vizinhos é 0,978, indicando uma preservação forte da vizinhança local.

  == Kernel PCA

  Também com o kernel RBF, comparamos cinco valores de $gamma$ (@tab:kpca-grid). Para cada um, a silhueta interna corresponde ao melhor K-Means entre $k = 2$ e $k = 5$ no plano 2D. A configuração selecionada foi $gamma = 0,05$, que apresentou a maior trustworthiness entre os valores testados, 0,976, muito próxima ao do PCA. Para essa configuração, o solver retornou 141 autovalores. A silhueta interna dessa projeção é 0,637 ($k = 2$) e a externa, 0,427. Já a maior silhueta interna do grid (0,667, com $k = 3$) ocorre em $gamma = 0,25$, mas possuía uma trustworthiness menor.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Componente*], [*Autovalor ($eta$)*], [*Proporção*], [*Acumulado*]),
      table.hline(),
      [1], [26,677], [0,614], [0,614],
      [2], [9,022], [0,208], [0,822],
      [3], [2,503], [0,058], [0,879],
      [4], [1,857], [0,043], [0,922],
      table.hline(),
    ),
    caption: [Kernel PCA (RBF, $gamma = 0,05$): autovalores, proporções e acumulado],
    kind: table,
  ) <tab:kpca>

  A @tab:kpca-centroides resume as coordenadas médias das observações de cada espécie na projeção: _setosa_ (0,564; −0,075), _versicolor_ (−0,154; 0,176) e _virginica_ (−0,410; −0,101). Esses pontos, destacados na @fig:kpca-centroides, são os médios calculados após a projeção com os rótulos reais.

  #figure(
    table(
      columns: 3,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Espécie*], [*Componente 1*], [*Componente 2*]),
      table.hline(),
      [Setosa], [0,564], [−0,075],
      [Versicolor], [−0,154], [0,176],
      [Virginica], [−0,410], [−0,101],
      table.hline(),
    ),
    caption: [Kernel PCA: médias das coordenadas das observações de cada espécie nas duas primeiras componentes.],
    kind: table,
  ) <tab:kpca-centroides>

  #figure(
    image("../imagens/kpca_scatter_centroids.png", width: 100%),
    caption: [Kernel PCA ($gamma = 0,05$): projeção das observações e centróides das espécies.],
  ) <fig:kpca-centroides>

  As duas primeiras componentes do Kernel PCA somam 82,2% da soma dos autovalores retornados, e as quatro primeiras, 92,2% (@tab:kpca). O espectro também apresenta uma cauda longa de autovalores pequenos (@fig:kpca-var, @fig:kpca-var-log).

  #figure(
    table(
      columns: 5,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$gamma$*], [*Sil. interna*], [*$k$*], [*Sil. externa*], [*Trustworthiness*]),
      table.hline(),
      [0,05], [0,637], [2], [0,427], [*0,976*],
      [0,10], [0,647], [2], [0,447], [0,962],
      [0,25], [*0,667*], [3], [0,468], [0,932],
      [0,50], [0,649], [3], [0,456], [0,915],
      [1,00], [0,583], [3], [0,417], [0,892],
      table.hline(),
    ),
    caption: [Kernel PCA (RBF): grid sobre $gamma$; seleção pela maior trustworthiness. O $k$ informado é o do K-Means no plano 2D e serve apenas como descrição.],
    kind: table,
  ) <tab:kpca-grid>

  #figure(
    image("../imagens/kpca_variance.png", width: 100%),
    caption: [Kernel PCA (RBF, $gamma = 0,05$): proporção dos autovalores nas dez primeiras componentes e acumulado.],
  ) <fig:kpca-var>

  Como a cauda é longa, @fig:kpca-var-log repete os autovalores em escala logarítmica. Nela fica mais fácil ver que, depois das duas primeiras componentes, os valores decaem sem um novo salto.

  #figure(
    image("../imagens/kpca_scree_log.png", width: 100%),
    caption: [Kernel PCA ($gamma = 0,05$): todos os autovalores em escala logarítmica.],
  ) <fig:kpca-var-log>

  #figure(
    image("../imagens/kpca_scatter.png", width: 100%),
    caption: [Kernel PCA (RBF, $gamma = 0,05$, configuração selecionada): observações projetadas nas duas primeiras componentes, coloridas pela espécie real.],
  ) <fig:kpca-scatter>

  Na projeção (@fig:kpca-scatter), a _setosa_ permanece separada das demais espécies, com sobreposição entre _versicolor_ e _virginica_ semelhante à do PCA linear. Na configuração escolhida, a trustworthiness com dez vizinhos é 0,976: abaixo dos 0,978 da PCA linear, como era esperado para uma projeção não linear, mas acima dos 0,932 de $gamma = 0,25$. As silhuetas dessa configuração são 0,637 ($k = 2$, interna) e 0,427 (externa) e ficam apenas como descrição. O grid mostra que a trustworthiness cai de 0,976 em $gamma = 0,05$ para 0,892 em $gamma = 1,0$: quanto mais estreito o kernel, mais a projeção distorce vizinhanças, mesmo quando a silhueta interna sobe. Por isso o critério adotado foi fidelidade de vizinhança, e não compactação do plano.

  == t-SNE

  Foram avaliadas as perplexidades 5, 10, 20 e 30, com inicialização por PCA, taxa de aprendizado automática, limite de 1000 iterações e semente 42. Todas as execuções registraram 999 iterações. A @tab:tsne resume a silhueta não supervisionada, obtida por K-Means no embedding, a silhueta externa pelas espécies reais, a divergência de Kullback-Leibler (KL) e a trustworthiness com dez vizinhos.

  #figure(
    table(
      columns: 7,
      align: center,
      stroke: none,
      table.hline(),
      table.header(
        [*Perplexidade*],
        [*Sil. não sup.*],
        [*$k$ K-Means*],
        [*Sil. externa*],
        [*Divergência KL*],
        [*Iterações*],
        [*Trustworthiness*],
      ),
      table.hline(),
      [5], [0,588], [5], [0,267], [0,330], [999], [0,981],
      [10], [0,664], [2], [0,455], [0,309], [999], [0,985],
      [20], [0,819], [2], [0,508], [0,195], [999], [0,990],
      [30], [*0,865*], [2], [0,483], [0,164], [999], [0,989],
      table.hline(),
    ),
    caption: [t-SNE: silhueta não supervisionada por K-Means e avaliação externa pelas espécies reais.],
    kind: table,
  ) <tab:tsne>

  A silhueta não supervisionada cresce com a perplexidade, selecionando perplexidade 30, resultando em 0,865. A silhueta externa pelas espécies reais é apresentada apenas como referência e não participa da seleção. A divergência KL foi usada como informação complementar.

  Na análise de estabilidade da perplexidade 30, as sementes de 0 a 9 produziram silhueta não supervisionada média de 0,865 e trustworthiness média de 0,989, ambas sem variação observável. A silhueta externa média foi 0,483. Esses resultados indicam estabilidade das métricas nesse conjunto de execuções, mas não avaliam a robustez em novas amostras ou configurações.

  #figure(
    image("../imagens/tsne_perplexity_comparison.png", width: 100%),
    caption: [t-SNE: silhueta e divergência KL em função da perplexidade.],
  ) <fig:tsne-comp>

  Os embeddings da @fig:tsne-emb mostram o efeito da perplexidade sobre a estrutura obtida. Com perplexidade 5, a ênfase na vizinhança muito local fragmenta os dados: a _setosa_ aparece dividida em três subgrupos, e _versicolor_ também se divide em vários blocos, o que produz subestruturas que não correspondem a diferenças entre espécies. Com perplexidade 10, a _setosa_ forma um único grupo alongado, enquanto _versicolor_ e _virginica_ ocupam regiões distintas, mas com alguns pontos de _versicolor_ dentro da região de _virginica_. Com perplexidades 20 e 30, a _setosa_ forma um grupo compacto e bem afastado, e _versicolor_ e _virginica_ formam uma região contínua, com sobreposição parcial na fronteira entre elas.

  #figure(
    image("../imagens/tsne_embeddings_perplexities.png", width: 100%),
    caption: [t-SNE: embeddings bidimensionais para as perplexidades 5, 10, 20 e 30, coloridos pela espécie real.],
  ) <fig:tsne-emb>

  O t-SNE preserva principalmente relações de vizinhança, de modo que distâncias e tamanhos dos grupos no embedding não refletem diretamente o espaço original. A silhueta mede a separação das espécies reais no plano e não a qualidade de um agrupamento, por isso não é comparável às silhuetas dos métodos de agrupamento. Já a trustworthiness mede a preservação dos dez vizinhos mais próximos e é uma métrica complementar.

  == UMAP

  Foram avaliadas 12 configurações, combinando `n_neighbors` ∈ {5, 10, 15, 30} e `min_dist` ∈ {0,0; 0,1; 0,5}, com distância euclidiana, dois componentes e semente 42. A silhueta não supervisionada foi calculada no espaço bidimensional com rótulos preditos por K-Means; a silhueta pelas espécies reais foi mantida apenas como avaliação externa. A @tab:umap apresenta os resultados.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*`n_neighbors`*], [*`min_dist` = 0,0*], [*`min_dist` = 0,1*], [*`min_dist` = 0,5*]),
      table.hline(),
      [5], [0,760], [0,712], [0,597],
      [10], [0,820], [0,783], [0,720],
      [15], [0,864], [0,800], [0,863],
      [30], [*0,902*], [0,893], [0,686],
      table.hline(),
    ),
    caption: [Silhueta não supervisionada por configuração. Em destaque, o maior valor.],
    kind: table,
  ) <tab:umap>

  A silhueta não supervisionada variou entre 0,597 (`n_neighbors` = 5 e `min_dist` = 0,5) e 0,902 (`n_neighbors` = 30 e `min_dist` = 0,0), conforme a @fig:umap-sil. A trustworthiness com dez vizinhos variou entre 0,971 e 0,980.

  A @tab:umap-sementes resume a estabilidade das quatro melhores configurações pela silhueta não supervisionada obtida com a semente 42, avaliadas em dez sementes.

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
      [30], [0,0], [0,893], [0,025], [0,977 (0,002)],
      [30], [0,1], [0,876], [0,023], [0,977 (0,002)],
      [15], [0,0], [0,854], [0,023], [0,975 (0,002)],
      [15], [0,5], [0,781], [0,051], [0,979 (0,001)],
      table.hline(),
    ),
    caption: [Estabilidade das quatro melhores configurações em dez sementes (0 a 9). Os desvios são padrões amostrais.],
    kind: table,
  ) <tab:umap-sementes>

  Entre essas configurações, `n_neighbors` = 30 e `min_dist` = 0,0 obteve a maior silhueta não supervisionada média (0,893 ± 0,025). A trustworthiness média ficou entre 0,975 e 0,979. Os resultados indicam estabilidade satisfatória dessa configuração selecionada sem utilização dos rótulos reais.

  #figure(
    image("../imagens/umap_parameter_comparison.png", width: 100%),
    caption: [UMAP: silhueta em função de `n_neighbors`, para cada valor de `min_dist`.],
  ) <fig:umap-sil>

  Os embeddings da @fig:umap-emb mostram o efeito dos parâmetros. Com `n_neighbors` = 5, a ênfase em vizinhanças locais fragmenta os dados, enquanto `min_dist` = 0,5 dispersa os pontos em estruturas mais contínuas. Com `n_neighbors` = 10 e `min_dist` = 0,0, os grupos são compactos e _versicolor_ e _virginica_ aparecem mais distintos. Em `n_neighbors` = 30, as duas espécies formam uma faixa contínua com sobreposição parcial para todos os valores de `min_dist`. A _setosa_ permanece completamente separada em todas as configurações.

  #figure(
    image("../imagens/umap_embeddings_parameters.png", width: 100%),
    caption: [UMAP: embeddings bidimensionais para as 12 combinações de `n_neighbors` e `min_dist`, coloridos pela espécie real.],
  ) <fig:umap-emb>

]
