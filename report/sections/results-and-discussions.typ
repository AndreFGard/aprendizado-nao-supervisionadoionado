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

  Para $k = 2$, um agrupamento reúne as 50 _setosa_ e 3 _versicolor_ (53 observações), e o outro reúne 47 _versicolor_ e as 50 _virginica_ (97 observações). A silhueta elevada reflete a separação nítida da _setosa_ em relação ao restante. O ARI é menor porque a partição funde duas espécies.

  #figure(
    image("../imagens/kmedoids_clusters.png", width: 100%),
    caption: [Agrupamento por K-Medoids com $k = 3$, projetado em `petal_length` × `petal_width`; os rótulos indicam a espécie majoritária de cada grupo e os marcadores em formato `X` representam os medóides.],
  ) <fig:kmed-clusters>

  Para $k = 3$, a _setosa_ permanece isolada (50/50). Dos 50 exemplares de _versicolor_, 37 ficam em um agrupamento e 13 migram para o agrupamento dominado por _virginica_, que contém 48 das 50 _virginica_, e 2 _virginica_ são atribuídas ao agrupamento de _versicolor_. No total, 15 das 150 observações (10%) são alocadas fora do agrupamento majoritário de sua espécie, e os tamanhos dos agrupamentos são 39, 50 e 61. A @fig:kmed-clusters apresenta essa configuração projetada em comprimento e largura das pétalas. Os medóides têm coordenadas (5,7; 2,8; 4,1; 1,3), (5,0; 3,4; 1,5; 0,2) e (6,5; 3,0; 5,2; 2,0), nesta ordem: sepal_length, sepal_width, petal_length e petal_width. A queda da silhueta para 0,529 é explicada pela fronteira difusa entre _versicolor_ e _virginica_. A silhueta média por agrupamento é de aproximadamente 0,79 para o grupo da _setosa_, contra 0,50 e 0,34 para os outros dois. Esse resultado é compatível com o fato de o K-Medoids, por favorecer grupos compactos, não distinguir adequadamente objetos em regiões de fronteira.

  Com $k = 4$ e $k = 5$, os agrupamentos adicionais subdividem a região de _versicolor_ e _virginica_ sem corresponder a novas espécies, o que reduz a silhueta e, em relação a $k = 3$, não melhora a concordância com as espécies. Em $k = 5$, por exemplo, surge um agrupamento de apenas 13 observações, com _versicolor_ e _virginica_ fragmentadas em vários grupos.

  Os resultados evidenciam uma divergência entre os critérios. A silhueta, por ser uma métrica interna que avalia coesão e separação geométrica sem conhecer as espécies, favorece $k = 2$. O ARI e o cotovelo da inércia apontam $k = 3$, que coincide com o número real de espécies. Assim, $k = 2$ é a melhor escolha do ponto de vista da separação geométrica, enquanto $k = 3$ oferece o melhor compromisso com a correspondência das espécies, com 0,744 de ARI e silhueta ainda moderada (0,529). Por fim, como os atributos foram usados sem normalização e com distância city-block, atributos de maior amplitude têm maior peso no cálculo das dissimilaridades, o que pode influenciar as partições obtidas.

  == Fuzzy K-Means

  == Kernel Fuzzy K-Means

  Foram realizadas 480 execuções, correspondentes a 48 combinações de parâmetros ($k in {2, 3, 4, 5}$, $m in {1,5; 2,0; 2,5}$ e $sigma^2 in {"automático"; 0,5; 1,0; 2,0}$) com dez sementes cada. Em 34 das 48 combinações, as dez sementes levaram a resultados idênticos em silhueta e ARI. Nas 14 restantes houve variação, concentrada em $k >= 3$ e, em geral, associada a $sigma^2 = 0,5$ ou $m = 2,5$. Para $k = 2$, o maior desvio-padrão da silhueta entre sementes foi de 0,001, o que indica solução praticamente única. A @tab:kfkm resume as métricas por valor de $k$, considerando todas as 120 execuções de cada $k$.

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
    caption: [Kernel Fuzzy K-Means: métricas por número de agrupamentos, considerando todas as combinações de $m$ e $sigma^2$ e todas as sementes.],
    kind: table,
  ) <tab:kfkm>

  A silhueta média decresce monotonicamente com $k$, de 0,686 em $k = 2$ para 0,396 em $k = 5$, e o valor mínimo observado cai para 0,168, o que mostra que valores elevados de $k$, combinados com certos parâmetros, produzem partições mal separadas no espaço original. O ARI médio é máximo em $k = 3$ (0,765) e o ARI máximo também (0,818), enquanto $k = 2$ apresenta o menor ARI (0,568), pois a partição em dois grupos não pode corresponder às três espécies.

  Seguindo o critério de seleção descrito na metodologia, a configuração de maior silhueta foi $k = 2$, $m = 1,5$ e $sigma^2 = 0,5$, com silhueta de 0,6864 e ARI de 0,5681. Esse valor de silhueta é compartilhado por outras sete das doze combinações com $k = 2$, de modo que a escolha entre elas não altera as métricas. O ARI obtido é idêntico ao de uma partição que separa exatamente a _setosa_ das demais espécies (0,568), o que é consistente com o mapa de pertinências da @fig:kfkm-pert. Nele, as amostras de 0 a 49, que correspondem à _setosa_ na ordenação original da base, apresentam pertinência elevada ao agrupamento 0, enquanto as demais pertencem predominantemente ao agrupamento 1. Nesse segundo grupo, as pertinências são mais baixas e há regiões de valores intermediários, principalmente entre as amostras de índices aproximados 78 e 110, indicando observações de fronteira. Esse tipo de informação é preservado pela partição fuzzy, mas é perdido quando cada observação é atribuída apenas ao agrupamento de maior pertinência, como na @fig:kfkm-clusters. Nessa figura, os dados são projetados apenas em `sepal_length` e `sepal_width`, e a sobreposição visual entre os grupos não reflete integralmente a separação obtida com os quatro atributos.

  #figure(
    image("kernel_fuzzy_kmeans_memberships.png", width: 100%),
    caption: [Graus de pertinência da melhor configuração por silhueta ($k = 2$, $m = 1,5$, $sigma^2 = 0,5$).],
  ) <fig:kfkm-pert>

  #figure(
    image("kernel_fuzzy_kmeans_clusters.png", width: 100%),
    caption: [Melhor agrupamento por silhueta, projetado em `sepal_length` e `sepal_width`.],
  ) <fig:kfkm-clusters>

  A @fig:kfkm-conv mostra a convergência da função objetivo dessa configuração, que terminou em 18 iterações. A função decresce de aproximadamente 85,2 até 80,33 e permanece praticamente estável a partir da iteração 12. Há um patamar nas primeiras iterações, seguido de queda acentuada entre as iterações 6 e 10. Esse comportamento é compatível com o critério de parada por tolerância de $10^(-5)$. Vale observar que os valores da função objetivo dependem de $m$ e de $sigma^2$ e não são comparáveis entre configurações. Para $k = 2$ e $m = 1,5$, por exemplo, o valor médio é 27,7 com $sigma^2$ automático, 80,3 com $sigma^2 = 0,5$, 62,4 com $sigma^2 = 1,0$ e 43,4 com $sigma^2 = 2,0$. Por isso, a função objetivo foi usada apenas para a convergência e para a escolha entre as inicializações internas, e não para comparar configurações.

  #figure(
    image("kernel_fuzzy_kmeans_objective_convergence.png", width: 100%),
    caption: [Convergência da função objetivo da melhor configuração por silhueta.],
  ) <fig:kfkm-conv>

  Para $k = 3$, o ARI máximo (0,8178) foi obtido com $m = 2,0$ e $sigma^2 = 0,5$, com silhueta de 0,531. Valores muito próximos (0,8176) ocorreram com $m = 1,5$ e $sigma^2 in {0,5; 1,0}$. Já a maior silhueta válida para $k = 3$ foi de 0,549, com $m = 1,5$ e $sigma^2$ automático, associada a um ARI menor (0,729). Há, portanto, uma divergência entre os critérios: a silhueta, calculada no espaço original, favorece $k = 2$ e, dentro de $k = 3$, configurações com menor concordância com as espécies, enquanto o ARI aponta $k = 3$ como o número de agrupamentos mais compatível com a classificação real. É importante ressaltar que o ARI máximo foi usado apenas para análise posterior dos resultados, pois depende dos rótulos reais e não faz parte do critério de seleção. Além disso, a silhueta é calculada no espaço original, enquanto o agrupamento é feito no espaço de características induzido pelo kernel, de modo que ela não avalia diretamente a geometria em que o algoritmo opera.

  Quanto aos hiperparâmetros, a média das métricas indica efeitos moderados. Em $k = 3$, o ARI médio foi maior com $sigma^2 = 1,0$ (0,793) do que com $sigma^2$ automático (0,743), $sigma^2 = 0,5$ (0,746) e $sigma^2 = 2,0$ (0,777), e foi ligeiramente menor com $m = 2,5$ (0,746) do que com $m = 1,5$ (0,775) e $m = 2,0$ (0,773). Para $k = 4$ e $k = 5$, o ARI médio foi maior com $m = 2,5$ (0,689 e 0,593) do que com $m = 1,5$ (0,657 e 0,568). A largura menor do kernel ($sigma^2 = 0,5$) reduziu a silhueta média para $k >= 4$ (0,427 em $k = 4$ e 0,358 em $k = 5$, contra 0,494 e 0,412 com $sigma^2$ automático).

  Os parâmetros extremos também produziram instabilidade. Com $k = 3$, $m = 2,5$ e $sigma^2 = 0,5$, as dez sementes geraram quatro soluções distintas, com silhueta entre 0,428 e 0,686. Em duas dessas execuções, silhueta e ARI coincidiram com os de $k = 2$ (0,6864 e 0,5681), o que indica que, provavelmente, um dos três agrupamentos ficou sem observações após a atribuição por maior pertinência. Além disso, 13 das 480 execuções atingiram o limite de 100 iterações: uma em $k = 3$ ($m = 2,5$, $sigma^2 = 0,5$), duas em $k = 4$ e todas as dez em $k = 5$ ($m = 2,5$, $sigma^2 = 1,0$). Nesses casos, o critério de tolerância não foi atingido, e os resultados devem ser interpretados com cautela. Isso inclui os valores de ARI máximo em $k = 4$ (0,719) e $k = 5$ (0,734), obtidos justamente nessa combinação de parâmetros.

  Em síntese, o Kernel Fuzzy K-Means separa consistentemente a _setosa_ das demais espécies, e as dificuldades de agrupamento concentram-se na fronteira entre _versicolor_ e _virginica_. A silhueta no espaço original favorece $k = 2$, enquanto $k = 3$ alcança as maiores concordâncias com as espécies (ARI de até 0,818) em configurações com $sigma^2$ moderado e $m$ entre 1,5 e 2,0. Valores de $m$ e $sigma^2$ extremos tendem a gerar soluções instáveis ou de convergência incompleta. Por fim, o uso dos atributos sem normalização influencia as distâncias que alimentam o kernel gaussiano, o que pode afetar a escolha adequada de $sigma^2$.
  
  == Misturas gaussianas com EM

  == Agrupamento hierárquico Centroid Linkage
  
  == DBSCAN

]
