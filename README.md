# lipnote

A high-precision Typst template for math lecture notes, inspired by the LIPIcs style and optimized for note-taking. Available in English and French.

> Not yet published on Typst Universe. To use it, copy `lib.typ` into your project.

## Features

- LIPIcs-inspired layout
- Theorem-like blocks: Theorem, Lemma, Corollary, Proposition, Property, Conjecture, Definition, Notation, Observation, Assertion
- Course blocks: Example, Method, Exercise, Remark, Recall, Proof, Summary, Note
- Automatic table of contents
- English / French output

## Usage

```typst
#import "lib.typ": *

#show: lipnote.with(
  // ... your parameters ...
  lang: "en", // "en" or "fr" (default: "fr")
)
```

```sh
typst compile main.typ
```

See `exemple.typ` for a full example.

## Language

`lang` sets the block titles, hyphenation and Typst's built-in labels. Your own content is not translated.

## Acknowledgements

Style inspired by the LIPIcs LaTeX class (Schloss Dagstuhl). Not affiliated with LIPIcs or Dagstuhl.

## License

MIT

<br>

<p align=center>Made with ❤️ by rk.</p>