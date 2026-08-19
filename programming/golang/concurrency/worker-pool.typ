Суть в создании фиксированного количества горутин (воркеров),
которые читают задачи из одного общего канала

1. Класичесская архитектура (Каналы + sync.WaitGroup)

```go
package main

import (
    "fmt"
    "sync"
)

func worker(id int, jobs <-chan int, results chan<- int, wg *sync.WaitGroup) {
    defer wg.Done() // Сообщаем, что воркер завершился
    for job := range jobs { // Цикл завершится, когда канал закроют
        fmt.Printf("Worker %d processing job %d\n", id, job)
        results <- job * 2 // Имитация работы
    }
}

func main() {
    const numWorkers = 3
    jobs := make(chan int, 10)
    results := make(chan int, 10)

    var wg sync.WaitGroup
    wg.Add(numWorkers)

    // Запускаем пул
    for i := 0; i < numWorkers; i++ {
        go worker(i, jobs, results, &wg)
    }

    // Отправляем задачи
    for i := 0; i < 5; i++ {
        jobs <- i
    }
    close(jobs) // Без закрытия воркеры зависнут в deadlock

    // Ждем завершения ВСЕХ воркеров
    wg.Wait()
    close(results) // Теперь можно закрыть канал результатов

    // Читаем результаты
    for res := range results {
        fmt.Println("Result:", res)
    }
}
```

Важно понимать, Worker Pool очень похож на Fan-Out/In, это не спроста

Worker-pool это бизнес-паттерн, задача

Fan-Out/In это технический паттерн, необходимые способы организации
потоков данных

Но сами по себе Fan-Out / Fan-In это реализация идеи Worker Pool
в Go (решение задачи)

Здесь нужно разобрать вариации
использования неиспользования
каждого из пары Fan-Out / Fan-In

Случай 1. Нет Fan-Out, Нет Fan-In (Ручное управление).
Как выглядит:\

Один диспетчер (главная горутина) сам решает,
какую задачу какому воркеру отдать, через личный канал каждого воркера.
Воркеры не соревнуются за общий канал задач и не собираются в общий канал
результатов (пишут ответ в свой собственный канал или слайс).


Round-Robin:

```go
type Worker struct {
    id       int
    tasks    chan int
    results  chan int // Личный канал для ответа
}

func (w *Worker) Run(wg *sync.WaitGroup) {
    defer wg.Done()
    for task := range w.tasks {
        w.results <- task * 2
    }
}

func main() {
    workers := make([]*Worker, 3)
    for i := 0; i < 3; i++ {
        w := &Worker{id: i, tasks: make(chan int, 1), results: make(chan int, 1)}
        workers[i] = w
        go w.Run(&wg)
    }

    // Диспетчер сам раздает задачи (Fan-Out отсутствует)
    for i := 0; i < 10; i++ {
        workers[i%3].tasks <- i
    }
    // Читаем результаты из личных каналов каждого (Fan-In отсутствует)
    for _, w := range workers {
        close(w.tasks)
    }
    wg.Wait()
    // Собираем результаты вручную из w.results
}
```

Случай 2. Есть Fan-Out, Нет Fan-In (Однонаправленный поток)
Как выглядит:\

Несколько воркеров читают из общего канала задач (Fan-Out есть),
но результаты им не нужно возвращать. Они пишут ответ сразу
во внешнюю систему (БД, HTTP-ответ, Kafka) или просто выполняют
действие (fire-and-forget).

```go
func main() {
    jobs := make(chan string, 100)
    
    // Fan-Out есть: 5 воркеров дергают письма
    for i := 0; i < 5; i++ {
        go func() {
            for email := range jobs {
                sendEmail(email) // Пишет в SMTP, результат не нужен
            }
        }()
    }

    for _, email := range massiveEmailList {
        jobs <- email
    }
    close(jobs)
    wg.Wait() // Ждем, пока все письма улетят
}
```

Случай 3. Нет Fan-Out, Есть Fan-In (Сток данных)

Как выглядит:\

Есть заранее известный набор горутин (например, парсеры сайтов),
которые работают параллельно. Fan-Out не нужен, потому что каждая горутина
знает свою задачу (свой URL). Но результаты они сливают в один общий
канал (Fan-In есть).

```go
func main() {
    results := make(chan Page, 10) // Общий сток (Fan-In)
    var wg sync.WaitGroup

    urls := []string{"https://site1.com", "https://site2.com", "https://site3.com"}

    for _, url := range urls {
        wg.Add(1)
        go func(u string) {
            defer wg.Done()
            // Нет Fan-Out: задача жестко закреплена за этой горутиной
            page := fetch(u) 
            results <- page // Fan-In: все сливают в один канал
        }(url)
    }

    // Отдельная горутина для сборки результатов (Fan-In Receiver)
    go func() {
        wg.Wait()
        close(results)
    }()

    for page := range results {
        fmt.Println(page)
    }
}
```

Случай 4. Есть Fan-Out и Есть Fan-In (Классика)

разобран в самом начале

