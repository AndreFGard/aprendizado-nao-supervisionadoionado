#let results-and-discussions = [
  = Resultados e discussões

  == K-Means

  == K-Medoids

  Foram realizadas 40 execuções, com $k in {2, 3, 4, 5}$ e dez sementes por valor de $k$. Para cada $k$, as dez execuções produziram resultados idênticos em silhueta, inércia, ARI e rótulos, o que é coerente com a inicialização heurística, que é determinística. As repetições não constituem, portanto, amostras independentes, e o experimento resulta em quatro soluções distintas, uma por $k$. Nesse cenário, a execução de menor inércia e a de maior silhueta coincidem para cada $k$. A @tab:kmedoids resume os resultados.

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

  A silhueta decresce de forma monótona com $k$ (@fig:kmed-sil), atingindo o máximo em $k = 2$ (0,674). Já a inércia diminui continuamente (@fig:kmed-inercia), como esperado, pois a função objetivo tende a decrescer com o aumento de $k$. Os ganhos marginais, porém, reduzem-se de forma acentuada: de $k = 2$ para $k = 3$ a inércia cai 54,7 (24,9%), de $k = 3$ para $k = 4$ cai 24,6 (14,9%) e de $k = 4$ para $k = 5$ cai 8,3 (5,9%). Esse comportamento indica um cotovelo em $k = 3$, embora o critério seja visual e não conclusivo isoladamente.

  #figure(
    image("../imagens/kmedoids_silhouette.png", width: 100%),
    caption: [Silhouette em função do número de agrupamentos $k$ (K-Medoids).],
  ) <fig:kmed-sil>

  #figure(
    image("../imagens/kmedoids_inertia.png", width: 100%),
    caption: [Inércia em função do número de agrupamentos $k$ (K-Medoids).],
  ) <fig:kmed-inercia>

  A análise externa mostra que o ARI é máximo em $k = 3$ (0,744) e não é monótono: $k = 5$ (0,692) supera $k = 4$ (0,653), mas permanece abaixo de $k = 3$. Em todos os valores de $k$, os 50 exemplares de _Iris setosa_ ficam isolados em um único agrupamento, e as variações entre configurações decorrem da região de sobreposição entre _versicolor_ e _virginica_.

  Para $k = 2$, um agrupamento reúne as 50 _setosa_ e 3 _versicolor_ (53 observações), e o outro reúne 47 _versicolor_ e as 50 _virginica_ (97 observações). A silhueta elevada reflete a separação nítida da _setosa_ em relação ao restante. O ARI é menor porque a partição funde duas espécies. A configuração selecionada por silhueta (@fig:kmed-clusters) corresponde, portanto, a uma estrutura mais grosseira que a das espécies. Na @fig:kmed-clusters, os dados são projetados apenas em `sepal_length` e `sepal_width`; como o agrupamento utiliza os quatro atributos, a projeção não reflete integralmente a separação obtida no espaço original, e a sobreposição visual entre os grupos é esperada.

  #figure(
    image("../imagens/kmedoids_clusters.png", width: 100%),
    caption: [Melhor agrupamento por silhueta ($k = 2$), projetado em `sepal_length` e `sepal_width`.],
  ) <fig:kmed-clusters>

  Para $k = 3$, a _setosa_ permanece isolada (50/50). Dos 50 exemplares de _versicolor_, 37 ficam em um agrupamento e 13 migram para o agrupamento dominado por _virginica_, que contém 48 das 50 _virginica_, e 2 _virginica_ são atribuídas ao agrupamento de _versicolor_. No total, 15 das 150 observações (10%) são alocadas fora do agrupamento majoritário de sua espécie, e os tamanhos dos agrupamentos são 39, 50 e 61. A queda da silhueta para 0,529 é explicada pela fronteira difusa entre _versicolor_ e _virginica_. A silhueta média por agrupamento é de aproximadamente 0,79 para o grupo da _setosa_, contra 0,50 e 0,34 para os outros dois. Esse resultado é compatível com o fato de o K-Medoids, por favorecer grupos compactos, não distinguir adequadamente objetos em regiões de fronteira.

  Com $k = 4$ e $k = 5$, os agrupamentos adicionais subdividem a região de _versicolor_ e _virginica_ sem corresponder a novas espécies, o que reduz a silhueta e, em relação a $k = 3$, não melhora a concordância com as espécies. Em $k = 5$, por exemplo, surge um agrupamento de apenas 13 observações, com _versicolor_ e _virginica_ fragmentadas em vários grupos.

  Os resultados evidenciam uma divergência entre os critérios. A silhueta, por ser uma métrica interna que avalia coesão e separação geométrica sem conhecer as espécies, favorece $k = 2$. O ARI e o cotovelo da inércia apontam $k = 3$, que coincide com o número real de espécies. Assim, $k = 2$ é a melhor escolha do ponto de vista da separação geométrica, enquanto $k = 3$ oferece o melhor compromisso entre compacidade e correspondência com as espécies, com 0,744 de ARI e silhueta ainda moderada (0,529). Por fim, como os atributos foram usados sem normalização e com distância city-block, atributos de maior amplitude têm maior peso no cálculo das dissimilaridades, o que pode influenciar as partições obtidas.

  == Fuzzy K-Means

  == Kernel Fuzzy K-Means
  
  == Misturas gaussianas com EM

  == Agrupamento hierárquico Centroid Linkage
  
  == DBSCAN

]


