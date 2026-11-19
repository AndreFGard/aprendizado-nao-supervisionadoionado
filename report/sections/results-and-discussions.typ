#let results-and-discussions = [
  = Resultados e discussões

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

  //TODO Adicionar um scatter plot comparando k2 e k3.
  A partição com $k^* = 2$ isola as 50 _setosa_ em um grupo e reúne as 100 observações de _versicolor_ e _virginica_ no outro. A silhueta reflete a separação da _setosa_, mas o ARI decorre da fusão entre _versicolor_ e _virginica_. A silhueta decresce de $k = 2$ até $k = 5$, enquanto o ARI é máximo em $k = 3$ (0,620), com silhueta de 0,459. A divergência entre os critérios é similar à observada no K-Medoids, em que a silhueta favorece 2 grupos, mas o ARI 3. Nessa partição de $k = 3$, a _setosa_ permanece isolada, mas  25 das 100 observações das outras espécies não pertencem ao respectivo grupo majoritário. Com $k = 4$ e $k = 5$, a _setosa_ passa a ser subdividida (27/23), acompanhada do decrescimento de ambas as métricas.

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


  Entre as partições selecionadas para cada $k$, o ARI é máximo em $k = 3$ (0,620 com $m = 1,5$), com silhueta 0,459, enquanto a partição de $k^* = 2$ isola as 50 _setosa_ perfeitamente, como no K-Means. O máximo global de ARI no grid é 0,630 ($k = 3$, $m = 2,0$; não mostrado na tabela), mas esse par não maximiza a silhueta e não foi selecionado; o ARI é mostrado apenas como avaliação externa. Não houve variabilidade entre sementes em $k = 2$ e $k = 3$ para nenhum valor de $m$; em $k = 4$ e $k = 5$ houve mínimos locais, sobretudo em $k = 5$ com $m = 1,5$ (silhueta entre 0,339 e 0,395). Em $k = 3$, 25 das 150 observações (16,7%) ficam fora do grupo majoritário, e em $k = 4$ a _setosa_ passa a ser dividida (49/1), também em acordo com o K-Means.

  Além disso, embora a fuzzificação suavize as fronteiras, uma vez feito _crisp_, o particionamento para $k^*$ do Fuzzy K-Means foi idêntico ao do K-Means, e as métricas se mantêm muito próximas para $k > 2$. A diferença entre $m = 1,5$ e $m = 2,0$ é pequena (por exemplo, 0,459 contra 0,457 em $k = 3$), indicando baixa sensibilidade a $m$ neste conjunto.


  == Kernel Fuzzy K-Means

  Foram realizadas 480 execuções: 48 combinações de $k in {2, 3, 4, 5}$, $m in {1,5; 2,0; 2,5}$ e $sigma^2 in {"automático"; 0,5; 1,0; 2,0}$, com dez sementes por combinação e cinco inicializações internas por execução. Em cada combinação, a menor função objetivo entre as dez sementes identificou a melhor execução. Na @tab:kfkm, essa melhor execução é apresentada por $k$, junto da combinação $(m, sigma^2)$ de maior silhueta para aquele $k$.

  #figure(
    table(
      columns: 6,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$k$*], [*$m$*], [*$sigma^2$*], [*Silhouette*], [*ARI*], [*Objetivo*]),
      table.hline(),
      [2], [1,5], [1,0], [0,580], [0,568], [76,72],
      [3], [2,5], [0,5], [0,540], [0,529], [24,87],
      [4], [1,5], [2,0], [0,398], [0,587], [34,46],
      [5], [2,5], [1,0], [0,374], [0,495], [10,29],
      table.hline(),
    ),
    caption: [Kernel Fuzzy K-Means: melhor combinação $(m, sigma^2)$ por $k$, segundo a silhueta, após a seleção da melhor semente pela função objetivo dentro de cada combinação.],
    kind: table,
  ) <tab:kfkm>

  A silhueta máxima entre as configurações ocorre em $k = 2$, com $m = 1,5$ e $sigma^2 = 1,0$. A configuração final apresenta silhueta de 0,5802 e ARI de 0,5681. As demais curvas decrescem até $k = 5$; a única diferença relevante é $k = 4$, cujo ARI é 0,587, mas que não supera a silhueta de $k = 2$. O ARI foi utilizado somente como avaliação externa e não participou da escolha da configuração ou de $k^*$.

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_silhouette.png", width: 100%),
    caption: [Silhouette por $k$ do Kernel Fuzzy K-Means, mostrando a melhor combinação $(m, sigma^2)$ por cada valor de $k$.],
  ) <fig:kfkm-sil>

  A configuração final separa perfeitamente as 50 observações de _setosa_ das demais espécies, conforme a @tab:kfkm-k2-contingencia. As confusões ficam concentradas entre _versicolor_ e _virginica_.

  #figure(
    table(
      columns: 3,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Espécie*], [*Setosa*], [*Versicolor*]),
      table.hline(),
      [Setosa], [50], [0],
      [Versicolor], [0], [50],
      [Virginica], [0], [50],
      table.hline(),
    ),
    caption: [Contingência entre espécies reais e grupos da melhor configuração por silhueta com $k = 2$.],
    kind: table,
  ) <tab:kfkm-k2-contingencia>

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_k2_ari_clusters.png", width: 100%),
    caption: [Melhor configuração por silhueta ($k = 2$, $m = 1,5$, $sigma^2 = 1,0$), projetada em `petal_length` × `petal_width`.],
  ) <fig:kfkm-k2-clusters>

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_k2_ari_memberships.png", width: 100%),
    caption: [Graus de pertinência da melhor configuração por silhueta com $k = 2$.],
  ) <fig:kfkm-k2-pert>

  A @fig:kfkm-conv mostra a convergência da função objetivo da configuração final. O objetivo diminui até estabilizar em 76,7187 após 18 iterações. Como os valores dependem de $m$ e de $sigma^2$, foram usados apenas para selecionar a melhor semente dentro de cada configuração e não para ordenar configurações diferentes.

  #figure(
    image("../imagens/kernel_fuzzy_kmeans_objective_convergence.png", width: 100%),
    caption: [Convergência da função objetivo da melhor configuração por silhueta ($k = 2$, $m = 1,5$, $sigma^2 = 1,0$).],
  ) <fig:kfkm-conv>

  Em síntese, a busca atual adapta o procedimento do Fuzzy K-Means: dentro de cada tripla $(k, m, sigma^2)$, a função objetivo escolhe a melhor dentre as dez sementes; em seguida, a silhueta compara as combinações de parâmetros e seleciona o modelo final. Essa abordagem evita que diferenças de escala em $J_m$ decorrentes de $m$ ou $sigma^2$ favoreçam diretamente uma configuração.

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
    caption: [Misturas gaussianas com EM: por $k$, tipo de covariância de menor BIC, $-$log-verossimilhança mínima entre sementes para o tipo selecionado, ARI],
    kind: table,
  ) <tab:em>

   O efeito da covariância cresce com $k$: em $k = 2$ todas as formas recuperaram a mesma partição, diferindo só na complexidade e BIC, e em $k = 3$ as formas flexíveis capturaram a fronteira _versicolor_/_virginica_ (ARI 0,904 com `full`/`tied`), mas `spherical`teve uma perda considerável no ARI. Em ambos os casos, o `full` foi escolhido pelo BIC, mas em $k >= 4$ perdeu silhueta e o `tied` foi escolhido pelo BIC. 
   
   A silhueta das configurações selecionadas decresce de 0,580 em $k = 2$ para 0,300 em $k = 5$ (@fig:em-sil), um pouco mais rapidamente que em outros métodos, de modo que $k^* = 2$, com silhueta 0,580 e ARI 0,568. A partição crisp deste $k$ isola as 50 _setosa_ em um agrupamento, e as 100 observações de _versicolor_ e _virginica_ no outro, idêntica à do K-Means padronizado.

  #figure(
    image("../imagens/em_silhouette.png", width: 100%),
    caption: [Silhouette em função do número de clusters $k$ (misturas gaussianas com EM).],
  ) <fig:em-sil>



  Além disso, foi observada uma mudança positiva na estabilidade do algoritmo com o uso da inicialização por K-Means ao invés da aleatória. No entanto, o ganho principal da Mistura Gaussiana está em $k = 3$, que, apesar da silhueta modesta, teve o ARI  0,904, o melhor entre os observados no estudo, com apenas 5 das 150 observações fora do grupo majoritário, obtendo partições bem isoladas entre as espécies, particularmente devido à melhor captura da fronteira _versicolor_/_virginica_.
  //TODO urgente: fazer o codigo pra produzir a tabela de pertencimento a partição nesse k = 3.

  //TODO ADicioanr plot mostrando como ficou bem dividido aqui?

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


  Como mostra a @fig:pca-var, a variância concentra-se nas duas primeiras componentes, que juntas explicam 95,8% do total. A PC1 é formada por uma combinação equilibrada de `petal_length`, `petal_width` e `sepal_length`, enquanto a PC2 é dominada por `sepal_width` @tab:pca-loadings. Notou-se, aqui, a importância da normalização dos dados para obter componentes mais balanceados.

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

  A projeção (@fig:pca-scatter) separa claramente a _setosa_, mas ainda há sobreposição entre _versicolor_ e _virginica_, como nos métodos de agrupamento. No plano, a silhueta interna por K-Means é 0,613 ($k = 2$), enquanto a silhueta externa com as espécies reais é 0,400. Já a trustworthiness com dez vizinhos é 0,978, indicando que a PCA segue preservando bem vizinhanças locais.

  == Kernel PCA

  Foram avaliados cinco valores de $gamma$ com kernel RBF. Para cada configuração, a silhueta interna foi calculada por K-Means no plano 2D e a externa com as espécies reais, além da trustworthiness com dez vizinhos (@tab:kpca-grid). O melhor $gamma$ foi 0,25 — o default heurístico da biblioteca — com silhueta interna 0,667 ($k = 3$), externa 0,468 e trustworthiness 0,932. A decomposição espectral dessa configuração retornou 146 autovalores, cuja soma é 98,22; conforme descrito na metodologia, a proporção de cada componente foi calculada em relação a essa soma. A @tab:kpca apresenta as quatro primeiras componentes dessa configuração.

  #figure(
    table(
      columns: 4,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*Componente*], [*Autovalor ($lambda$)*], [*Proporção*], [*Acumulado*]),
      table.hline(),
      [1], [39,132], [0,398], [0,398],
      [2], [17,792], [0,181], [0,580],
      [3], [8,677], [0,088], [0,668],
      [4], [7,782], [0,079], [0,747],
      table.hline(),
    ),
    caption: [Kernel PCA (RBF, $gamma = 0,25$, configuração selecionada): autovalores e proporções em relação à soma dos autovalores retornados (98,22).],
    kind: table,
  ) <tab:kpca>

  Em contraste com a PCA linear, a variância no espaço de características induzido pelo kernel se espalha por um número maior de direções (@fig:kpca-var), concentrando-a menos, e a cauda do espectro se estende por dezenas de componentes.

  #figure(
    table(
      columns: 5,
      align: center,
      stroke: none,
      table.hline(),
      table.header([*$gamma$*], [*Sil. interna*], [*$k$*], [*Sil. externa*], [*Trustworthiness*]),
      table.hline(),
      [0,05], [0,637], [2], [0,427], [0,976],
      [0,10], [0,647], [2], [0,447], [0,962],
      [0,25], [*0,667*], [3], [0,468], [0,932],
      [0,50], [0,649], [3], [0,456], [0,915],
      [1,00], [0,583], [3], [0,417], [0,892],
      table.hline(),
    ),
    caption: [Kernel PCA (RBF): grid sobre $gamma$; seleção pela maior silhueta interna.],
    kind: table,
  ) <tab:kpca-grid>

  #figure(
    image("../imagens/kpca_variance.png", width: 100%),
    caption: [Kernel PCA (RBF, $gamma = 0,25$): proporção dos autovalores nas dez primeiras componentes e acumulado.],
  ) <fig:kpca-var>

  #figure(
    image("../imagens/kpca_scatter.png", width: 100%),
    caption: [Kernel PCA (RBF, $gamma = 0,25$, configuração selecionada): observações projetadas nas duas primeiras componentes, coloridas pela espécie real.],
  ) <fig:kpca-scatter>

  Na projeção (@fig:kpca-scatter), a _setosa_ permanece separada das demais espécies, com sobreposição entre _versicolor_ e _virginica_ semelhante à do PCA linear. Nas métricas complementares, a silhueta interna selecionada é de 0,667 ($k = 3$) e a externa é 0,468. A trustworthiness com dez vizinhos é 0,932, abaixo do PCA linear (0,978), indicando maior distorção de vizinhança conforme $gamma$ cresce (de 0,976 em $gamma = 0,05$ a 0,892 em $gamma = 1,0$).

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
