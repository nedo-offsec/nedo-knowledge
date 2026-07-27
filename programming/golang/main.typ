#import "@preview/ape:0.4.4": *
#show: doc.with(
  title: "The Go Programming Language",
  authors: ("nedo-offsec",),
  lang: "ru",
  style: "plain",
  title-page: true,
  outline: true,
)

// #include "01-basics/main.typ"

= Structures
#include "02-structure/main.typ"

#pagebreak()
= Data-Types
#include "03-data-types/main.typ"

// #include "04-composite-types/main.typ"
// #include "05-functions/main.typ"
// #include "06-methods/main.typ"

#pagebreak()
= Interfaces
#include "07-interfaces/main.typ"

#pagebreak()
= Gorouties and channels
#include "08-goroutines-channels/main.typ"

#pagebreak()
= Concurrency
#include "09-concurrency-sync/main.typ"
// #include "10-packages-tools/main.typ"
// #include "11-testing/main.typ"
// #include "12-reflection/main.typ"
// #include "13-low-level/main.typ"
