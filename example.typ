// ============================================================================
//  example.typ : exemple d'utilisation du modèle `lib.typ`
//  Ce mini-cours d'analyse utilise chaque environnement du modèle au moins
//  une fois : il sert à la fois d'exemple et d'aide-mémoire.

#import "lib.typ": *

// Autres façons de renseigner l'auteur :
//   auteur: ("Camille Martin", "Alex Durand")
//   auteur: ((nom: "Camille Martin", affiliation: [Université de Démonstration]),)
//
// Pour numéroter les équations hors texte, ajouter : numeroter-equations: true

#show: cours.with(
  // La langue par défaut est le français ; utiliser lang: "en" pour l'anglais.
  lang: "fr",
  titre: [Analyse réelle : suites numériques],
  titre-court: [Analyse réelle],
  sous-titre: [Notes de cours de première année de licence de mathématiques],
  auteur: "Camille Martin",
  enseignant: [Cours du Pr Dupont],
  institution: [Université de Démonstration],
  annee: [2026–2027],
  date: datetime.today(),
  resume: [
    Ces notes présentent les premières propriétés des suites réelles : définition de la limite, unicité, opérations, théorème des gendarmes et théorème de la limite monotone. Chaque environnement du modèle (théorème, définition, démonstration, remarque, etc.) y est employé au moins une fois.
  ],
  //etiquette: [ANALYSE · L1],
  table-des-matieres: true,
)




= Suites convergentes <chap:convergence>

== Premières définitions

Une suite est une manière d'énumérer des nombres réels indexée par les entiers naturels#footnote[Plus généralement, on peut indexer une suite par les entiers supérieurs ou égaux à un entier $n_0$ fixé.]. Les énoncés de ce chapitre (@def:suite, @def:limite, etc.) sont numérotés par chapitre et peuvent être cités avec `@étiquette`.

#definition(nom: [Suite réelle])[
  Une *suite réelle* est une application $u : NN -> RR$. On note $u_n$ l'image de l'entier $n$, et $(u_n)_(n in NN)$, ou simplement $(u_n)$, la suite elle-même.
] <def:suite>

#notation[
  On note $RR^NN$ l'ensemble des suites réelles.
]

#note[
  Dans ces notes, l'ensemble $NN$ contient $0$.
]

#exemple[
  Voici trois suites définies pour tout $n in NN$ :
  - $u_n = 1 / (n + 1)$, définie par une formule explicite ;
  - $u_0 = 1$ et $u_(n+1) = 2 u_n$, définie par récurrence (ici $u_n = 2^n$) ;
  - $u_n = (-1)^n$, qui alterne entre $1$ et $-1$.
]

== Limite d'une suite

#definition(nom: [Limite])[
  Soit $(u_n)$ une suite réelle et $ell in RR$. On dit que $(u_n)$ *converge vers* $ell$ si
  $ forall eps > 0, quad exists N in NN, quad forall n >= N, quad abs(u_n - ell) <= eps $
  On note alors $u_n -> ell$ ou $lim_(n -> infinity) u_n = ell$. Une suite qui ne converge pas est dite *divergente*.
] <def:limite>

Autrement dit, quel que soit l'écart $eps > 0$ toléré, tous les termes de la suite sont à distance au plus $eps$ de $ell$ à partir d'un certain rang (voir @fig:bande).

#figure(
  box(width: 10cm, height: 4cm, {
    let y(u) = 3.8cm - u * 2.2cm
    let x(n) = 4mm + n * 6mm

    place(
      top + left,
      dy: y(1.25),
      rect(
        width: 9cm,
        height: y(0.75) - y(1.25),
        fill: couleurs.jaune.transparentize(70%),
        stroke: none,
      ),
    )
    
    place(top + left, dy: y(0), line(length: 9.4cm, stroke: 0.5pt + couleurs.gris))
    place(
      top + left,
      dy: y(1),
      line(length: 9cm, stroke: (paint: couleurs.gris, thickness: 0.5pt, dash: "dashed")),
    )

    for n in range(1, 15) {
      let u = 1 + calc.pow(-1, n) / n
      place(
        top + left,
        dx: x(n) - 0.8mm,
        dy: y(u) - 0.8mm,
        circle(radius: 0.8mm, fill: couleurs.gris),
      )
    }

    place(top + right, dy: y(1.25) - 2.5mm, $ell + eps$)
    place(top + right, dy: y(1) - 2.5mm, $ell$)
    place(top + right, dy: y(0.75) - 2.5mm, $ell - eps$)
  }),
  caption: [La suite $u_n = 1 + (-1)^n / n$ converge vers $ell = 1$ : pour $eps = 1 / 4$, tous les termes d'indice $n >= 4$ sont dans la bande jaune.],
) <fig:bande>

#proposition(nom: [Unicité de la limite])[
  Une suite réelle admet au plus une limite.
] <prop:unicite>

#preuve[
  Supposons que $(u_n)$ converge à la fois vers $ell$ et vers $ell'$, avec $ell != ell'$. Posons $eps = abs(ell - ell') / 3 > 0$. Il existe deux rangs $N_1$ et $N_2$ tels que $abs(u_n - ell) <= eps$ pour $n >= N_1$ et $abs(u_n - ell') <= eps$ pour $n >= N_2$. Pour $n >= max(N_1, N_2)$, l'inégalité triangulaire donne
  $ abs(ell - ell') <= abs(ell - u_n) + abs(u_n - ell') <= 2 eps = 2 / 3 abs(ell - ell'), $
  ce qui entraîne $abs(ell - ell') <= 0$, donc $ell = ell'$ : contradiction.
]

#propriete(nom: [Opérations sur les limites])[
  Soient $(u_n)$ et $(v_n)$ deux suites avec $u_n -> ell$ et $v_n -> ell'$. Alors :
  + $u_n + v_n -> ell + ell'$ ;
  + $u_n v_n -> ell ell'$ ;
  + si $ell' != 0$, alors $v_n != 0$ à partir d'un certain rang et $u_n / v_n -> ell / ell'$.
] <prop:operations>

== Suites bornées

#definition[
  Une suite $(u_n)$ est *bornée* s'il existe $M in RR$ tel que $abs(u_n) <= M$ pour tout $n in NN$.
]

#proposition[
  Toute suite convergente est bornée.
] <prop:bornee>

#preuve[
  Soit $(u_n)$ de limite $ell$. En prenant $eps = 1$ dans la définition de la limite (@def:limite), on obtient un rang $N$ tel que $abs(u_n - ell) <= 1$, donc $abs(u_n) <= abs(ell) + 1$, pour tout $n >= N$. Le réel
  $ M = max(abs(u_0), dots, abs(u_(N-1)), abs(ell) + 1) $
  majore alors $abs(u_n)$ pour tout $n in NN$.
]

#remarque[
  La réciproque est fausse : la suite $((-1)^n)$ est bornée mais ne converge pas (voir @exo:alternee).
]


= Théorèmes de convergence <chap:theoremes>

== Comparaison de suites

#theoreme(nom: [des gendarmes])[
  Soient $(u_n)$, $(v_n)$ et $(w_n)$ trois suites réelles et $ell in RR$. Si $u_n <= v_n <= w_n$ à partir d'un certain rang, et si $u_n -> ell$ et $w_n -> ell$, alors $v_n -> ell$.
] <thm:gendarmes>

#preuve[
  Notons $N_0$ un rang à partir duquel $u_n <= v_n <= w_n$, et soit $eps > 0$. Par hypothèse, il existe $N_1$ et $N_2$ tels que $ell - eps <= u_n$ pour $n >= N_1$ et $w_n <= ell + eps$ pour $n >= N_2$. Pour $n >= max(N_0, N_1, N_2)$, on a donc
  $ ell - eps <= u_n <= v_n <= w_n <= ell + eps, $
  c'est-à-dire $abs(v_n - ell) <= eps$. Ainsi $v_n -> ell$.
]

#corollaire[
  Si $abs(v_n) <= w_n$ à partir d'un certain rang et si $w_n -> 0$, alors $v_n -> 0$.
]

#preuve[
  À partir d'un certain rang, $-w_n <= v_n <= w_n$, et $-w_n -> 0$. Il suffit d'appliquer le théorème des gendarmes (@thm:gendarmes) avec $u_n = -w_n$ et $ell = 0$.
]

== Suites monotones

#rappel(nom: [Borne supérieure])[
  Toute partie non vide et majorée $A$ de $RR$ admet une borne supérieure, notée $sup A$ : c'est le plus petit des majorants de $A$.
]

#theoreme(nom: [de la limite monotone])[
  Soit $(u_n)$ une suite croissante.
  + Si $(u_n)$ est majorée, alors elle converge et $lim_(n -> infinity) u_n = sup {u_n | n in NN}$.
  + Sinon, $u_n -> +infinity$.
] <thm:monotone>

#preuve[
  Notons $A = {u_n | n in NN}$.

  *Premier cas : $(u_n)$ est majorée.* L'ensemble $A$ est non vide et majoré, donc il admet une borne supérieure $ell$. Soit $eps > 0$.

  #assertion(numero: false)[
    Il existe $N in NN$ tel que $ell - eps < u_N$.
  ]

  #preuve-assertion[
    Comme $ell$ est le plus petit des majorants de $A$, le réel $ell - eps$ n'est pas un majorant de $A$. Il existe donc un élément $u_N$ de $A$ tel que $ell - eps < u_N$.
  ]

  Pour tout $n >= N$, la croissance de $(u_n)$ donne $ell - eps < u_N <= u_n <= ell$, donc $abs(u_n - ell) <= eps$. Ainsi $u_n -> ell$.

  *Second cas : $(u_n)$ n'est pas majorée.* Soit $M in RR$. Comme $M$ ne majore pas $(u_n)$, il existe $N$ tel que $u_N > M$. Par croissance, $u_n >= u_N > M$ pour tout $n >= N$. Donc $u_n -> +infinity$, ce qui conclut.
]

== Suites géométriques

#lemme(nom: [Inégalité de Bernoulli])[
  Pour tout réel $x >= -1$ et tout entier $n in NN$, on a $(1 + x)^n >= 1 + n x$.
] <lem:bernoulli>

#preuve[
  Par récurrence sur $n$. Pour $n = 0$, l'inégalité s'écrit $1 >= 1$. Supposons-la vraie au rang $n$. Comme $1 + x >= 0$,
  $ (1 + x)^(n+1) = (1 + x)^n (1 + x) >= (1 + n x)(1 + x) = 1 + (n + 1) x + n x^2 >= 1 + (n + 1) x, $
  ce qui est l'inégalité au rang $n + 1$.
]

#corollaire[
  Soit $q in RR$. Si $q > 1$, alors $q^n -> +infinity$. Si $abs(q) < 1$, alors $q^n -> 0$.
] <cor:geometrique>

#preuve[
  Si $q > 1$, posons $x = q - 1 > 0$. D'après le lemme de Bernoulli (@lem:bernoulli), $q^n >= 1 + n x$ pour tout $n$, et $1 + n x -> +infinity$, donc $q^n -> +infinity$.

  Si $q = 0$, la suite est nulle à partir du rang $1$ et le résultat est immédiat. Si $0 < abs(q) < 1$, alors $1 / abs(q) > 1$, donc $abs(q)^(-n) -> +infinity$ d'après le premier cas, ce qui s'écrit $abs(q)^n -> 0$. Comme $abs(q^n) = abs(q)^n$, on conclut que $q^n -> 0$.
]

=== Un exemple détaillé

#exemple[
  La suite $u_n = (2^n + 1) / 3^n$ s'écrit $u_n = (2 / 3)^n + (1 / 3)^n$. D'après le @cor:geometrique, chacun des deux termes tend vers $0$, donc $u_n -> 0$ par la @prop:operations.
]

==== Remarque de méthode

Les titres de niveau 4 et 5 ne sont pas numérotés : ils servent d'intertitres à l'intérieur d'une sous-section.

===== Point d'attention

Un titre de niveau 5 est composé en italique, dans une taille légèrement plus discrète.

#methode(nom: [Montrer qu'une suite converge])[
  + Conjecturer la limite $ell$ en calculant les premiers termes.
  + Encadrer la suite entre deux suites de même limite (@thm:gendarmes), ou montrer qu'elle est monotone et bornée (@thm:monotone).
  + À défaut, revenir à la définition (@def:limite) et chercher un rang $N$ en fonction de $eps$.
]

#exercice[
  Déterminer la limite de la suite définie par $u_n = (2 n^2 + n) / (n^2 + 3)$.
]

#exercice[
  Montrer que $sqrt(n + 1) - sqrt(n) -> 0$. _Indication : utiliser la quantité conjuguée._
]

#exercice[
  Montrer que la suite $((-1)^n)_(n in NN)$ diverge. _Indication :_ raisonner par l'absurde, prendre $eps = 1 / 2$ dans @def:limite et comparer deux termes consécutifs.
] <exo:alternee>

== Quelques limites usuelles

Le @tab:usuelles rassemble quelques limites à connaître.

#figure(
  table(
    columns: (4cm, 3cm, 4cm),
    table.header([Suite], [Limite], [Condition]),
    [$1 / n^alpha$], [$0$], [$alpha > 0$],
    [$q^n$], [$0$], [$abs(q) < 1$],
    [$q^n$], [$+infinity$], [$q > 1$],
    [$root(n, n)$], [$1$], [—],
    [$(1 + 1 / n)^n$], [$e$], [—],
  ),
  caption: [Quelques limites usuelles.],
) <tab:usuelles>

== Expérimenter avec Python

#conjecture(nom: [de Syracuse])[
  Soit $u_0 in NN^*$ et $(u_n)$ la suite définie par
  $ u_(n+1) = cases(u_n / 2 quad "si" u_n "est pair", 3 u_n + 1 quad "sinon") $
  Alors il existe un rang $n$ tel que $u_n = 1$.
]

#observation[
  Pour $u_0 = 7$, la suite prend les valeurs $7, 22, 11, 34, 17, 52, 26, 13, 40, 20, 10, 5, 16, 8, 4, 2, 1$ : elle atteint $1$ en $16$ étapes.
]

Le @lst:syracuse calcule ces valeurs pour n'importe quel entier de départ.

#figure(
  ```python
  def syracuse(u0):
      u = u0
      while u != 1:
          yield u
          u = u // 2 if u % 2 == 0 else 3 * u + 1
      yield 1
  ```,
  caption: [Calcul du « vol » de Syracuse ; `list(syracuse(7))` redonne la liste ci-dessus.],
) <lst:syracuse>


#heading(numbering: none)[Pour aller plus loin]

Quelques notions à aborder ensuite :

- les *suites extraites* et le théorème de Bolzano–Weierstrass :
  - toute suite bornée admet une suite extraite convergente ;
  - les valeurs d'adhérence d'une suite ;
- les *suites de Cauchy* et la complétude de $RR$ ;
- les *suites adjacentes*.

Pour étudier une suite $(u_n)$ définie par récurrence, on peut procéder ainsi :

+ étudier la monotonie de $(u_n)$ :
  + en calculant la différence $u_(n+1) - u_n$ ;
  + ou le quotient $u_(n+1) / u_n$ lorsque $u_n > 0$ ;
+ montrer que $(u_n)$ est bornée ;
+ conclure avec @thm:monotone et chercher la valeur de la limite.

#remarque(numero: false)[
  Le modèle fournit aussi quelques raccourcis pour les cours d'algèbre : $Card(A)$, $Ker(f)$, $Im(f)$, $rg(M)$, $Tr(M)$, $pgcd(a, b)$, ainsi que $eps$ pour le symbole $eps$.
]
