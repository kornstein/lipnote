// Template de prise de notes de maths/cours de maths, librement inspiré du modèle LIPIcs (LaTeX).
// Nécessite Typst 0.13 ou plus récent.

#let couleurs = (
  jaune: rgb(99%, 78%, 7%),
  gris: rgb(31%, 31%, 33%),
  gris-puce: rgb(60%, 60%, 61%),
  gris-trait: rgb(51%, 50%, 52%),
  gris-clair: rgb(85%, 85%, 86%),
)

#let polices = (
  sans: ("New Computer Modern Sans", "New Computer Modern"),
  serif: "New Computer Modern",
  math: "New Computer Modern Math",
  mono: ("New Computer Modern Mono", "DejaVu Sans Mono"),
)

#let _traductions = (
  fr: (
    theoreme: [Théorème], lemme: [Lemme], corollaire: [Corollaire],
    proposition: [Proposition], propriete: [Propriété], conjecture: [Conjecture],
    observation: [Observation], definition: [Définition], exemple: [Exemple],
    methode: [Méthode], exercice: [Exercice], notation: [Notation],
    note: [Note], remarque: [Remarque], rappel: [Rappel], assertion: [Assertion],
    preuve: [Démonstration], resume: [Résumé], table-matieres: [Table des matières],
  ),
  en: (
    theoreme: [Theorem], lemme: [Lemma], corollaire: [Corollary],
    proposition: [Proposition], propriete: [Property], conjecture: [Conjecture],
    observation: [Observation], definition: [Definition], exemple: [Example],
    methode: [Method], exercice: [Exercise], notation: [Notation],
    note: [Note], remarque: [Remark], rappel: [Recall], assertion: [Assertion],
    preuve: [Proof], resume: [Summary], table-matieres: [Table of contents],
  ),
)

#let _tr(cle, lang: "fr") = _traductions.at(lang).at(cle)

#let Card = math.op("Card")
#let Ker = math.op("Ker")
#let Im = math.op("Im")
#let Vect = math.op("Vect")
#let rg = math.op("rg")
#let Tr = math.op("Tr")
#let Id = math.op("Id")
#let pgcd = math.op("pgcd")
#let ppcm = math.op("ppcm")

#let eps = sym.epsilon.alt


#let _groupes-env = ("cours-env", "cours-exercice")

#let _numero-env(..n) = {
  let chapitre = counter(heading).get().first()
  if chapitre == 0 {
    numbering("1", ..n)
  } else {
    numbering("1.1", chapitre, ..n)
  }
}

#let _symbole(plein) = text(
  size: 13pt,
  fill: couleurs.gris,
  if plein { sym.triangle.filled.r } else { sym.triangle.r },
)

#let _t(titre, plein: true, gras: true, italique: false, groupe: "cours-env") = (
  titre: titre,
  plein: plein,
  gras: gras,
  italique: italique,
  groupe: groupe,
)

#let _types-env = (
  theoreme: _t("theoreme", italique: true),
  lemme: _t("lemme", italique: true),
  corollaire: _t("corollaire", italique: true),
  proposition: _t("proposition", italique: true),
  propriete: _t("propriete", italique: true),
  conjecture: _t("conjecture", italique: true),
  observation: _t("observation", italique: true),
  definition: _t("definition"),
  exemple: _t("exemple"),
  methode: _t("methode"),
  exercice: _t("exercice", groupe: "cours-exercice"),
  notation: _t("notation", gras: false),
  note: _t("note", gras: false),
  remarque: _t("remarque", gras: false),
  rappel: _t("rappel", gras: false),
  assertion: _t("assertion", plein: false, gras: false),
)

#let _env(nature, corps, nom: none, numero: true) = {
  let cfg = _types-env.at(nature)
  let groupe = cfg.groupe
  let titre = context { _tr(cfg.titre, lang: state("lang").get()) }

  let intitule = {
    titre
    if nom != none { [~(#nom)] }
    [.]
  }

  figure(
    kind: groupe,
    supplement: titre,
    numbering: if numero { _numero-env } else { none },
    outlined: false,
    align(left, block(
      spacing: 5mm,
      width: 100%,
      breakable: false,
      {
        set par(first-line-indent: 0cm)
        _symbole(cfg.plein)
        h(1mm)
        text(
          font: polices.sans,
          weight: if cfg.gras { "bold" } else { "regular" },
          underline(intitule),
        )
        parbreak()
        text(style: if cfg.italique { "italic" } else { "normal" }, corps)
      },
    ),)
  )
}

#let theoreme = _env.with("theoreme")
#let lemme = _env.with("lemme")
#let corollaire = _env.with("corollaire")
#let proposition = _env.with("proposition")
#let propriete = _env.with("propriete")
#let conjecture = _env.with("conjecture")
#let observation = _env.with("observation")
#let definition = _env.with("definition")
#let exemple = _env.with("exemple")
#let methode = _env.with("methode")
#let exercice = _env.with("exercice")
#let notation = _env.with("notation")
#let note = _env.with("note")
#let remarque = _env.with("remarque")
#let rappel = _env.with("rappel")
#let assertion = _env.with("assertion")

#let _bloc-preuve(corps, titre, style-titre, symbole) = block(
  spacing: 5mm,
  width: 100%,
  {
    set par(first-line-indent: 0cm)
    style-titre(titre + [.])
    parbreak()
    corps
    h(1fr)
    symbole
  },
)

#let preuve(corps, titre: none) = {
  let titre = if titre == none { context { _tr("preuve", lang: state("lang").get()) } } else { titre }
  _bloc-preuve(
    corps,
    titre,
    text.with(font: polices.sans, weight: "bold"),
    text(size: 13pt, fill: couleurs.gris, sym.triangle.filled.l),
  )
}

#let preuve-assertion(corps, titre: none) = {
  let titre = if titre == none { context { _tr("preuve", lang: state("lang").get()) } } else { titre }
  _bloc-preuve(
    corps,
    titre,
    text.with(font: polices.sans, fill: couleurs.gris),
    text(size: 13pt, fill: couleurs.gris, sym.triangle.l),
  )
}



#let cours(
  titre: [Titre du cours],
  lang: "fr",
  titre-court: auto,
  sous-titre: none,
  auteur: none,
  enseignant: none,
  institution: none,
  annee: none,
  date: none,
  resume: none,
  intitule-resume: auto,
  etiquette: none,
  table-des-matieres: false,
  profondeur-table: 2,
  accent: couleurs.jaune,
  taille: 10pt,
  numeroter-equations: false,
  corps,
) = {
  let titre-court = if titre-court == auto { titre } else { titre-court }
  state("lang").update(lang)

  let auteurs = if auteur == none {
    ()
  } else if type(auteur) == array {
    auteur
  } else {
    (auteur,)
  }
  let auteurs = auteurs.map(a => if type(a) == dictionary { a } else { (nom: a) })
  let auteurs-courts = auteurs.map(a => a.nom).join(", ")

  let date-texte = if type(date) == datetime {
    date.display("[day]/[month]/[year]")
  } else {
    date
  }
  let infos = (enseignant, institution, annee, date-texte).filter(x => x != none)

  let b = 3.5mm
  set page(
    "a4",
    numbering: "1",
    margin: (inside: 32mm, outside: 38mm, top: 35.5mm, bottom: 36.5mm + b),
    header: context {
      let n = counter(page).get().first()
      if n > 1 {
        set text(11pt, font: polices.sans, weight: "bold")
        block(
          width: 100%,
          {
            if calc.even(n) {
              place(dx: -10mm, [#n])
              titre-court
            } else {
              place(right, dx: 16mm, [#n])
              let chapitres = query(heading.where(level: 1).before(here()))
              if chapitres.len() > 0 {
                let ch = chapitres.last()
                if ch.numbering != none {
                  numbering(ch.numbering, ..counter(heading).at(ch.location()))
                  h(2mm)
                }
                ch.body
              } else {
                auteurs-courts
              }
            }
          },
        )
      }
    },
    header-ascent: 10.8mm,
    footer: context {
      let n = counter(page).get().first()
      if etiquette != none and calc.odd(n) {
        block(
          width: 100%,
          place(
            right,
            dx: 4cm,
            dy: 9mm,
            box(
              width: 4cm,
              height: 7mm,
              inset: 2mm,
              fill: accent,
              align(
                horizon + left,
                text(
                  size: 9pt,
                  tracking: 1.5pt,
                  font: polices.sans,
                  weight: "bold",
                  etiquette,
                ),
              ),
            ),
          ),
        )
      }
    },
    footer-descent: b,
  )

  set text(taille, font: polices.serif, lang: lang)
  show math.equation: set text(font: polices.math)
  show math.equation: set block(breakable: true)
  set math.equation(numbering: "(1)") if numeroter-equations
  set par(justify: true)

  set footnote.entry(
    separator: {
      line(length: 40mm)
      v(1.3mm)
    },
  )
  show footnote.entry: it => context {
    place(
      dy: -1mm,
      text(6pt, numbering(it.note.numbering, ..counter(footnote).at(it.note.location()))),
    )
    h(3mm)
    it.note.body
  }

  {
    set par(spacing: 0cm, leading: 0.63em, justify: false)
    v(-8mm)
    par(
      leading: 1em,
      text(17.28pt, tracking: 0.6pt, spacing: 85%, weight: "bold", font: polices.sans, titre),
    )
    if sous-titre != none {
      v(2.5mm)
      par(text(12pt, font: polices.sans, fill: couleurs.gris, sous-titre))
    }

    v(5.5mm)
    for a in auteurs {
      par(text(12pt, spacing: 80%, tracking: -0.1pt, weight: 600, a.nom))
      let aff = a.at("affiliation", default: none)
      if aff != none {
        v(2mm)
        par(text(size: 9pt, tracking: 0.12pt, aff))
      }
      v(3.5mm)
    }

    if infos.len() > 0 {
      par(text(size: 9pt, tracking: 0.12pt, infos.join([~·~])))
      v(3.5mm)
    }

    v(2.1mm)

    if resume != none {
      grid(
        columns: (7mm, auto, 1fr),
        align: horizon,
        column-gutter: 1.6mm,
        line(length: 100%, stroke: 0.5pt + couleurs.gris-trait),
        text(11pt, font: polices.sans, tracking: 0.01em, if intitule-resume == auto { _tr("resume", lang: lang) } else { intitule-resume }),
        line(length: 100%, stroke: 0.5pt + couleurs.gris-trait),
      )
      v(3.1mm)
      par(leading: 2.1mm, justify: true, text(size: 9pt, resume))
      v(5mm)
    }
  }
  v(1.4mm)

  set par(first-line-indent: 15pt, spacing: 0.65em, leading: 0.62em)
  set heading(numbering: "1.1")

  show heading.where(level: 1): it => {
    counter(figure.where(kind: "cours-env")).update(0)
    counter(figure.where(kind: "cours-exercice")).update(0)
    context {
      let num = if it.numbering == none {
        none
      } else {
        numbering(it.numbering, ..counter(heading).at(it.location()))
      }
      block(
        above: 9mm,
        below: 5mm,
        sticky: true,
        grid(
          columns: (5.9mm, 1fr),
          column-gutter: 5mm,
          align: horizon,
          block(
            fill: accent,
            width: 100%,
            height: 5.2mm,
            align(
              center + horizon,
              text(font: polices.sans, size: 12pt, weight: "bold", num),
            ),
          ),
          text(font: polices.sans, size: 12pt, weight: "bold", it.body),
        ),
      )
    }
  }

  show heading.where(level: 2).or(heading.where(level: 3)): it => context {
    let num = if it.numbering == none {
      none
    } else {
      numbering(it.numbering, ..counter(heading).at(it.location()))
    }
    block(
      above: 7mm,
      below: 5mm,
      sticky: true,
      {
        set par(first-line-indent: 0cm, justify: false)
        set text(
          font: polices.sans,
          size: if it.level == 2 { 12pt } else { 11pt },
          weight: "bold",
        )
        if num != none {
          num
          h(5mm)
        }
        it.body
      },
    )
  }

  show heading.where(level: 4): it => block(
    above: 5.5mm,
    below: 2.5mm,
    sticky: true,
    text(font: polices.sans, size: 10.5pt, weight: "bold", it.body),
  )

  show heading.where(level: 5): it => block(
    above: 4mm,
    below: 2.5mm,
    sticky: true,
    text(font: polices.sans, size: 10pt, weight: "regular", style: "italic", it.body),
  )

  set list(
    marker: (
      box(width: 2.4mm, height: 1.2mm, fill: couleurs.gris-puce),
      box(width: 1.8mm, height: 0.9mm, fill: couleurs.gris-puce),
    ),
    body-indent: 3mm,
    spacing: 2.5mm,
  )

  set enum(
    full: true,
    numbering: (..n) => {
      let nums = n.pos()
      let motifs = ("1.", "a.", "i.")
      let motif = motifs.at(calc.min(nums.len(), motifs.len()) - 1)
      text(
        font: polices.sans,
        weight: "bold",
        fill: couleurs.gris,
        numbering(motif, nums.last()),
      )
    },
  )

  set table(
    align: center + horizon,
    stroke: (col, row) => (
      top: if row <= 1 { 0.5pt } else { 0pt },
      bottom: 0.5pt,
    ),
  )

  show raw: set text(font: polices.mono)
  show raw.where(block: true): it => block(
    width: 100%,
    inset: 3mm,
    fill: couleurs.gris-clair.lighten(50%),
    it,
  )

  show figure: it => {
    if it.kind in _groupes-env {
      it.body
    } else if it.kind == raw {
      block(width: 100%, spacing: 5mm, {
        it.caption
        v(1.5mm)
        it.body
      })
    } else if it.kind == table {
      block(width: 100%, spacing: 6mm, breakable: false, {
        it.caption
        v(2.5mm)
        align(center, it.body)
      })
    } else {
      block(width: 100%, spacing: 6mm, breakable: false, {
        align(center, it.body)
        v(2.5mm)
        it.caption
      })
    }
  }

  show figure.caption: it => context {
    set align(left)
    box(fill: accent, width: 2.8mm, height: 2.8mm)
    h(3mm)
    text(font: polices.sans, weight: "bold", {
      it.supplement
      if it.numbering != none {
        [~]
        numbering(it.numbering, ..counter(figure.where(kind: it.kind)).get())
      }
    })
    h(2mm)
    it.body
  }

  if table-des-matieres {
    show outline.entry.where(level: 1): it => {
      v(2mm, weak: true)
      strong(it)
    }
    outline(title: _tr("table-matieres", lang: lang), depth: profondeur-table, indent: 5mm)
    pagebreak(weak: true)
  }

  corps
}
