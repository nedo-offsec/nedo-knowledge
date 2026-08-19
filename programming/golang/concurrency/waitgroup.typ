```go
type WaitGroup struct {
    // noCopy - маркер, запрещающий копирование
    noCopy noCopy
    
    // state1 - основное состояние (счетчик 32b + семафор 32b)
    state1 uint64
    
    // state2 - дополнительное состояние (для 32-битных архитектур)
    state2 uint32
}
```

Этот механизм позволяет ждать группу горутин

```go
package main

import (
  "fmt"
  "sync"
)

func worker(id int, wg *sync.WaitGroup) {
  defer wg.Done()
  fmt.Printf("Worker %d started\n", id)
}

func main() {
  var wg sync.WaitGroup

  for i := 1; i <= 3; i++ {
    wg.Add(1)
    go worker(i, &wg)
  }

  wg.Wait()
  fmt.Println("Все воркеры завершились")
}
```

Важно: WaitGroup передается по указателю (&wg), иначе будет
копия, и Done() не сработает

Важный пример на понимание:

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

func main() {
    var wg sync.WaitGroup
    wg.Add(1)

    go func() {
        fmt.Println("1. Начало работы")
        
        wg.Done() // Счетчик стал 0
        fmt.Println("2. Done() вызван, продолжаем работу")
        
        // Какая-то тяжелая работа
        time.Sleep(2 * time.Second)
        fmt.Println("3. Завершение работы горутины")
    }()

    wg.Wait() // Ждет, пока счетчик станет 0
    fmt.Println("4. main() продолжает работу")
}
```

У меня выводит так:

```bash
1. Начало работы
2. Done() вызван, продолжаем работу
4. main() продолжает работу
```

Дело в том, что wg.Wait() разблокируется как только счетчик 
станет равен 0. Вот счетчик стал равен 0 и за 2 секунды сна, 
горутина main() уже успела завершиться, в том числе поэтому
очень важно использовать defer wg.Done()

Также при неправильном использовании wg.Done() может быть
Data-race
