#import "@preview/ape:0.4.4": *
#show: doc.with(
  title: "Go. Chapter IX: Concurrency with Shared Variables",
  authors: ("nedo-offsec",),
  lang: "en",
  style: "plain",
  title-page: true,
  outline: false,
)

= Concurrency

В предыдущей главе мы представили несколько программ, которые используют
go-подпрограммы и каналы для выражения параллелизма непосредственным и
естественным путем. Однако, поступая так, мы затушевывали целый ряд важных
и тонких вопросов, которые программисты должны учитывать
при написании параллельного кода.

В этой главе мы более детально рассмотрим механику параллелизма.
В частности, мы укажем на некоторые из проблем, связанных с совместным
использованием переменных несколькими go-подпрограммами, и рассмотрим
аналитические методы распознавания этих проблем и шаблоны их решений.
Наконец мы поясним некоторые технические различия между
go-подпрограммами и потоками операционной системы.

== Data Races
#include "race-conditions.typ"

#pagebreak()
== Mutual Exclusion (`sync.Mutex`)
#include "mutex.typ"

#pagebreak()
== Read/Write Mutex (`sync.RWMutex`)
#include "rwmutex.typ"

#pagebreak()
== Memory Synchronization
#include "memory-sync.typ"

#pagebreak()
== sync.Once
#include "sync-once.typ"

#pagebreak()
== Race Detector
#include "race-detector.typ"

#pagebreak()
== Concurrent Cache
#include "concurrent-cache.typ"

#pagebreak()
== Goroutines vs Threads
#include "goroutines-vs-threads.typ"
