-- это примитив синхронизации, который гарантирует разовое выполнение
(мастхев для безопасной ленивой инициализации глоб переменных,
подключений к базе данных или паттерна Singletone)

Устройство:
```go
type Once struct {
    done uint32     // атомарный флаг: 0 — не выполнено, 1 — выполнено
    m    Mutex      // мьютекс для синхронизации
}
```

Сценарий 1: Последовательность вызовов (без горутин)

```go
func main() {
    var once sync.Once
    
    once.Do(func() { fmt.Println("Первый") })
    once.Do(func() { fmt.Println("Второй") })
    once.Do(func() { fmt.Println("Третий") })
}
```

Вывод:

```bash
Первый
```

Сценарий 2: Смешанные вызовы

```go
func main() {
    var once sync.Once
    var wg sync.WaitGroup

    once.Do(func() { fmt.Println("Обычный вызов") })

    for i := 0; i < 5; i++ {
        wg.Add(1)
        go func(id int) {
            defer wg.Done()
            once.Do(func() {
                fmt.Printf("Горутина %d\n", id)
            })
        }(i)
    }

    wg.Wait()
}
```

Вывод:
```bash
Обычный вызов
```

Сценарий 3: Паника внутри Once
```go
func main() {
    var once sync.Once
    
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("Поймали панику:", r)
        }
    }()
    
    // 1
    once.Do(func() {
        fmt.Println("Выполняем...")
        panic("ошибка!")
    })
    
    // Этот вызов не выполнится!
    once.Do(func() {
        fmt.Println("Повторная попытка")
    })
}
```

Вывод:
```bash
Выполняем...
Поймали панику: ошибка!
```

Паника разматывает стек до ближайшего `recover`, 
пропуская все, что было написано между точкой паники и 
местом восстановления.

В документации `sync.Once.Do` написано:\
если `f` паникует, `Do` считает, что она отработала
-- повторные вызовы `f` уже не выполнят

Почему: в реализации

```go
func (o *Once) doSlow(f func()) {
	o.m.Lock()
	defer o.m.Unlock()
	if !o.done.Load() {
		defer o.done.Store(true)
		f()
	}
}```

При панике внутри `f()` отложенные вызовы все равно отрабатывают
во время размотки стека -- значит `done` становится true
несмотря на панику


Сценарий 4. Антипаттерн. Бесконечная блокировка
```go
func main() {
    var once sync.Once
    
    once.Do(func() {
        fmt.Println("Начинаем...")
        // Опасный рекурсивный вызов!
        once.Do(func() {
            fmt.Println("Вложенный вызов")
        })
    })
}
```

Получим Deadlock.
Почему?

+ Первый вызов захватил мьютекс
+ Внутри колбэка происходит второй вызов Do()
+ Второй вызов видит done == 0, пытается захватить мьютекс
+ Мьютекс уже захвачен первым вызовом -> взаимная блокировка

Сценарий 5. Мутабельный синглтон

```go
var config *Config
var once sync.Once

func GetConfig() *Config {
    once.Do(func() {
        config = &Config{Port: 8080}
    })
    return config
}

// Где-то в коде:
func handler1() {
    cfg := GetConfig()
    cfg.Port = 9090 // Меняем глобальное состояние!
}

func handler2() {
    cfg := GetConfig()
    fmt.Println(cfg.Port) // 9090 — поведение неожиданное
}
```

Чтобы избежать проблем, можно вернуть копию (`*config`)

Сценарий 6. Подключение к БД
```go
var (
    db   *sql.DB
    once sync.Once
)

func GetDB() *sql.DB {
    once.Do(func() {
        // Подключение к БД — это ресурс, который должен быть ОДНИМ
        // Это НЕ антипаттерн!
        db, _ = sql.Open("postgres", os.Getenv("DATABASE_URL"))
        db.SetMaxOpenConns(10)
    })
    return db
}

// Почему это безопасно?
// 1. *sql.DB потокобезопасен
// 2. Мы НЕ меняем подключение (не переопределяем)
// 3. Это разделяемый ресурс, которым пользуются все
```

Также полезно использовать этот примитив синхронизации для
инициализаций логгера, метрик и тп.
