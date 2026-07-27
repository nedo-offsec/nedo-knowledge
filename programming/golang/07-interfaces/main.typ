#import "@preview/ape:0.4.4": *
#show: doc.with(
  title: "Go. Chapter VII: Interfaces",
  authors: ("nedo-offsec",),
  lang: "en",
  style: "plain",
  title-page: true,
  outline: false,
)

= Interfaces

Интерфейсные типы выражают обобщения или абстракции поведения других типов.
С помощью обобщения интерфейсы позволяют писать более гибкие и адаптируемые
функции, не привязанные к деталям одной конкретной реализации.

== Interfaces as Contracts
#include "interfaces-as-contracts.typ"

#pagebreak()
== Interface Types
#include "interface-types.typ"

#pagebreak()
== Interface Satisfaction
#include "interface-satisfaction.typ"

#pagebreak()
== flag.Value
#include "flag-value.typ"

#pagebreak()
== Interface Values
#include "interface-values.typ"

#pagebreak()
== Sorting with sort.Interface
#include "sort-interface.typ"

#pagebreak()
== HTTP Handlers
#include "http-handler.typ"

#pagebreak()
== Error Interface
#include "error-interface.typ"

#pagebreak()
== Type Assertions
#include "type-assertions.typ"

#pagebreak()
== Type Switches
#include "type-switches.typ"
