Правила:
+ Не копируйте мьютекс, он хранит внутреннее состояние
  (флаг блокировки, очередь ожидания). Копия нарушит логику.
  Передача только по указателю

+ Всегда разблокируйте. Используйте `defer` для гарантии
  разблокировки, особенно если в секции могут быть паника 
  или ранний `return`. 

  но иногда лучше разблокировать вручную, без `defer`
  (минус накладные расходы)

+ Не блокируйте мьютекс повторно. Одна и та же горутина
  не может вызвать `Lock()` дважды подряд без `Unlock()`
  -- это приводит к deadlock (взаимная блокировка, если есть
  другие горутины), либо к Fatal error all goroutines are asleep


== sync.Mutex (Взаимное исключение)

```go
// Упрощенная структура sync.Mutex
type Mutex struct {
    state int32   // Просто состояние (заблокирован/свободен)
    sema  uint32  // Семафор для ожидания
}

// Мутекс НЕ знает, кто его захватил!
// Поэтому при повторном Lock он просто видит:
// "state != 0" -> блокируемся
```

-- это самый простой мьютекс. Он гарантирует,
что в критическую секцию одновременно может войти
только одна горутина

Методы:
- `Lock()` -- лочит мьютекс. Если он уже залочен, то горутина
  блокируется (спит), пока мьютекс не освободят
- `Unlock()` -- анлочит мьютекс. Если вызвать на 
  незаблокированном мьютексе -- будет паника.

```go
package main

import (
    "fmt"
    "sync"
)

var (
    counter int
    mu      sync.Mutex
)

func safeIncrement(wg *sync.WaitGroup) {
    defer wg.Done()

    mu.Lock()
    counter++
    mu.Unlock()
}

func main() {
    var wg sync.WaitGroup
    for i := 0; i < 1000; i++ {
        wg.Add(1)
        go safeIncrement(&wg)
    }
    wg.Wait()
    fmt.Println(counter)
}
```

- Mutex нерекурсивный. В Go sync.Mutex не запоминает, какая горутина
  его захватила, и не считает количество захватов.

  Вот так можно в Java, но не в Go:
  ```go
  // Java - рекурсивный мьютекс
    public class Example {
        private final Object lock = new Object();
        
        public void outer() {
            synchronized(lock) {          // 1-й захват
                System.out.println("outer");
                inner();                  // Можно вызывать!
            }
        }
        
        public void inner() {
            synchronized(lock) {          // 2-й захват - ЭТО РАБОТАЕТ!
                System.out.println("inner");
            }
        }
    }
    ```


== sync.RWMutex (Читатель-Писатель)

`RWMutex` -- это улучшенная версия. Он разделяет доступ
на чтение и запись

```go
type RWMutex struct {
    w           Mutex      // Мьютекс для писателей
    writerSem   uint32     // Семафор для писателей
    readerSem   uint32     // Семафор для читателей
    readerCount int32      // Количество активных читателей
    readerWait  int32      // Сколько читателей ждут писателя
}
```

Правила:

Читатели (Rlock/RUnlock):
- Могут входить одновременно сколько угодно, 
  если нет активного писателя
- Блокируется, только если писатель уже захватил `Lock()`

Писатель (Lock/Unlock):
- Может войти только тогда, когда нет
  ни одного читателя и нет другого писателя
- Пока писатель внутри, новые читатели блокируются (ждут)

Методы:
- `RLock()` / `RUnlock()` -- для чтения
- `Lock()` / `Unlock()` -- для записи

Кэш с конкурентным доступом

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

type Cache struct {
    data map[string]string
    mu   sync.RWMutex
}

func NewCache() *Cache {
    return &Cache{data: make(map[string]string)}
}

// Чтение: много горутин могут читать одновременно
func (c *Cache) Get(key string) string {
    c.mu.RLock()         // Блокировка на чтение
    defer c.mu.RUnlock()
    return c.data[key]
}

// Запись: эксклюзивный доступ
func (c *Cache) Set(key, value string) {
    c.mu.Lock()          // Блокировка на запись
    defer c.mu.Unlock()
    c.data[key] = value
}

func main() {
    cache := NewCache()
    cache.Set("name", "Go")

    // Запускаем 10 читателей
    var wg sync.WaitGroup
    for i := 0; i < 10; i++ {
        wg.Add(1)
        go func() {
            defer wg.Done()
            fmt.Println(cache.Get("name"))
        }()
    }
    wg.Wait()
}
```
== Особенности RWMutex
=== Голодание писателя (Writer Starvation)

-- это ситуация, когда писатель не может захватить
блокировку на запись, потому что
постоянно приходят новые читатели

Согласно правилам, читатели могут входить, если
нет *АКТИВНОГО* писателя

ВАЖНО: Писатель становится АКТИВНЫМ только после того, 
как успешно захватил Lock()

То есть, пока писатель ждет выхода старых читателей, могут зайти
новые читатели, что и создает проблему

Как решать?

+ Шардирование: разбить данные на несколько независимых частей

  ```go
  type ShardedCache struct {
      shards [16]struct {
          mu   sync.RWMutex
          data map[string]string
      }
  }

  func (c *ShardedCache) getShard(key string) int {
      hash := 0
      for _, ch := range key {
          hash += int(ch)
      }
      return hash % 16
  }

  func (c *ShardedCache) Get(key string) string {
      shardIdx := c.getShard(key)
      shard := &c.shards[shardIdx]
      
      shard.mu.RLock()
      defer shard.mu.RUnlock()
      return shard.data[key]
  }

  func (c *ShardedCache) Set(key, value string) {
      shardIdx := c.getShard(key)
      shard := &c.shards[shardIdx]
      
      shard.mu.Lock()
      defer shard.mu.Unlock()
      shard.data[key] = value
  }
  ```

  Преимущество: Писатель блокирует только один шард, а не весь кэш.

+ Использование каналов с очередью

  ```go
  type Operation struct {
      IsWrite bool
      Key     string
      Value   string
      Result  chan string
  }

  type SafeMap struct {
      data    map[string]string
      ops     chan Operation
      stop    chan struct{}
  }

  func NewSafeMap() *SafeMap {
      sm := &SafeMap{
          data: make(map[string]string),
          ops:  make(chan Operation, 1000),
          stop: make(chan struct{}),
      }
      go sm.process()
      return sm
  }

  func (sm *SafeMap) process() {
      for {
          select {
          case op := <-sm.ops:
              if op.IsWrite {
                  // Запись имеет приоритет
                  sm.data[op.Key] = op.Value
              } else {
                  // Чтение
                  op.Result <- sm.data[op.Key]
              }
          case <-sm.stop:
              return
          }
      }
  }

  func (sm *SafeMap) Get(key string) string {
      ch := make(chan string, 1)
      sm.ops <- Operation{IsWrite: false, Key: key, Result: ch}
      return <-ch
  }

  func (sm *SafeMap) Set(key, value string) {
      sm.ops <- Operation{IsWrite: true, Key: key, Value: value}
  }
  ```
=== Нерекурсивность, а повторяемость Rlock()

Рекурсивный мьютекс (или reentrant mutex) -- это
мьютекс, который запоминает, какой поток его
захватил, и позволяет этому же потоку захватывать его
сколько угодно раз, пока она его держит

Такой мьютекс:
- имеет счетчик захватов (recursion count)
- имеет владельца (owner) -- поток
- если владелец пытается захватить мьютекс повторно, то
  просто увеличивается счетчик
- если другой владелец пытается захватить мьютекс,
  то происходит блокировка

А в Go владелец не отслеживается, поэтому несмотря на то, 
что можно повторно вызвать RLock() и RUnlock(),
такой мьютекс не считается рекурсивным.
(работает он через счетчик `readerCount`, но не путать
с счетчиком рекурсии)

```go
package main

import (
	"fmt"
	"sync"
)

var rwmu sync.RWMutex

func read1() {
    rwmu.RLock()
    defer rwmu.RUnlock()
    
    read2() // Можно! RLock рекурсивен
}

func read2() {
    rwmu.RLock()
    defer rwmu.RUnlock()
    
    fmt.Println("Вложенное чтение")
}

func main() {
    read1() // Работает!
}
```



== Когда что использовать?

Используйте RWMutex, если:

- Чтений значительно больше, чем записей (пропорция 10:1 или выше).
- Чтение выполняется долго (например, сериализация JSON, чтение из БД).
- Вы хотите повысить производительность за счет параллельных чтений.

Используйте обычный Mutex, если:
- Записи и чтения примерно равны по частоте.
- Критическая секция очень короткая (меньше, чем накладные расходы на RWMutex).
- RWMutex сложнее в использовании и может привести к зависаниям (см. ниже).


