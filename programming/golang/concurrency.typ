= Concurrency

-- это система организации параллельной работы(с т.з. пк)

#pagebreak()
= Fan-In & Fan-Out каналы
#include("concurrency/fan.typ")

= Координация: sync

Каналы -- это способ обмена данными.
Но иногда нужно просто скоординировать работу.

= Data Race
#include("concurrency/data-race.typ")

#pagebreak()
= sync.WaitGroup
#include("concurrency/waitgroup.typ")

#pagebreak()
= Mutex / RWMutex
#include("concurrency/mutex.typ")

#pagebreak()
= sync.Once
#include("concurrency/once.typ")

#pagebreak()
= sync.Pool
#include("concurrency/pool.typ")

#pagebreak()
= Concurrency Patterns

== Fan-In / Fan-Out
#include("concurrency/fan.typ")

== Worker Pool
#include("concurrency/worker-pool.typ")


