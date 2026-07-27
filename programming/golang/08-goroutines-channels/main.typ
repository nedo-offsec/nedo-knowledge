#import "@preview/ape:0.4.4": *
#show: doc.with(
  title: "Go. Chapter VIII: Goroutines and Channels",
  authors: ("nedo-offsec",),
  lang: "en",
  style: "plain",
  title-page: true,
  outline: false,
)

= Gorouties and channels

Go обеспечивает два стиля параллельного программирования. В этой главе пред-
ставлены go-подпрограммы (goroutines) и каналы, которые поддерживают взаимодей-
ствующие последовательные процессы (communicating sequential processes — CSP),

модель параллелизма, в которой между независимыми процессами (go-подпрограм-
мами) передаются значения, но переменные по большей части ограничиваются од-
ним процессом.

== Goroutines
#include "goroutines.typ"

#pagebreak()
== EXAMPLE: Concurrent echo-server
#include "echo-server.typ"

#pagebreak()
== Channels
#include "channels.typ"

#pagebreak()
== Select
#include "select.typ"

#pagebreak()
== Cancellation
#include "cancel.typ"

#pagebreak()
== EXAMPLE: Chat Server
#include "chat-server.typ"
