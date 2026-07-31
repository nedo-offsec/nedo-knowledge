// template.typ — общий шаблон для всех конспектов

#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2cm),
  numbering: "1",
  number-align: center,
)
#set text(font: "Linux Libertine", size: 11pt)

#set heading(numbering: "1.1")
#show heading: set text(size: 1.2em, weight: "regular")
#show heading: it => [
  #if it.level == 1 [
    #set text(size: 1.8em, weight: "semibold")
    #counter(heading).display() #it.body
  ] else [
    #counter(heading).display("1.1") #it.body
  ]
]

#let codeblock(body) = [
  #set par(leading: 0.5em)
  #block(
    fill: rgb("#1e1e1e"),
    inset: (x: 0.6em, y: 0.4em),
    radius: 0.3em,
    width: 100%,
    stroke: none,
    breakable: true,
  )[
    #set text(fill: rgb("#d4d4d4"), size: 9pt, font: "JetBrains Mono")
    #body
  ]
]

#let note(body) = [
  #block(
    fill: rgb("#2d2d2d"),
    inset: (x: 1em, y: 0.6em),
    radius: 0.3em,
    width: 100%,
    stroke: (left: 0.3em + rgb("#ffaa00")),
    breakable: true,
  )[
    #set text(fill: rgb("#ffcc66"), size: 10pt)
    #body
  ]
]

#let doc(
  title: "Заголовок",
  subtitle: "Подзаголовок",
  authors: ("Автор",),
  lang: "ru",
  style: "plain",
  title-page: true,
  outline: true,
) = [
  #set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2cm),
    fill: rgb("#fafafa"),
  )
  #align(center + horizon)[
    #v(5em)
    #text(size: 3em, weight: "bold", fill: rgb("#1a1a2e"))[#title]
    #v(0.8em)
    #text(size: 1.5em, fill: rgb("#4a4a6a"))[#subtitle]
    #v(3em)
    #line(length: 40%, stroke: 0.8pt + rgb("#aaaaaa"))
    #v(1.5em)
    #text(size: 1.2em, fill: rgb("#333333"))[#authors.join(", ")]
    #v(0.3em)
    #text(size: 1em, fill: rgb("#666666"))[#datetime.today().display()]
    #v(6em)
    #line(length: 60%, stroke: 0.5pt + rgb("#cccccc"))
    #v(0.5em)
    #text(size: 0.8em, fill: rgb("#999999"))[
      Подготовка к техническому собеседованию
    ]
  ]
  #pagebreak()
  #if outline [
    #outline()
    #pagebreak()
  ]
]
