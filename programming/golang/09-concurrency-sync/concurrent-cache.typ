=== Проблема

Нужно кешировать результаты дорогих вызовов функций (например, HTTP-запросов).
Кеш должен быть безопасным при параллельном доступе и не блокировать
другие запросы.

=== Эволюция дизайна

==== Версия 1: Простой кеш (небезопасный)

```go
type Memo struct {
    f     Func
    cache map[string]result
}

func (memo *Memo) Get(key string) (interface{}, error) {
    res, ok := memo.cache[key]
    if !ok {
        res.value, res.err = memo.f(key)
        memo.cache[key] = res
    }
    return res.value, res.err
}
```

Гонка данных при параллельном доступе.

==== Версия 2: С мьютексом (безопасно, но медленно)

```go
type Memo struct {
    f     Func
    mu    sync.Mutex
    cache map[string]result
}

func (memo *Memo) Get(key string) (interface{}, error) {
    memo.mu.Lock()
    defer memo.mu.Unlock()
    // ... та же логика
}
```

Безопасно. Блокирует все вызовы, даже уже закешированные.

==== Версия 3: Двойная блокировка (быстрее, но дублирует работу)

```go
func (memo *Memo) Get(key string) (interface{}, error) {
    memo.mu.Lock()
    res, ok := memo.cache[key]
    memo.mu.Unlock()

    if !ok {
        res.value, res.err = memo.f(key)
        memo.mu.Lock()
        memo.cache[key] = res
        memo.mu.Unlock()
    }
    return res.value, res.err
}
```

Быстрее. Дублирует вычисления (две горутины могут вычислять один ключ).

==== Версия 4: Подавление повторений (без дублирования)

```go
type entry struct {
    res   result
    ready chan struct{} // закрывается, когда res готов
}

type Memo struct {
    f     Func
    mu    sync.Mutex
    cache map[string]*entry
}

func (memo *Memo) Get(key string) (interface{}, error) {
    memo.mu.Lock()
    e := memo.cache[key]
    if e == nil {
        e = &entry{ready: make(chan struct{})}
        memo.cache[key] = e
        memo.mu.Unlock()

        e.res.value, e.res.err = memo.f(key)
        close(e.ready) // сигнал готовности
    } else {
        memo.mu.Unlock()
        <-e.ready // ждём готовности
    }
    return e.res.value, e.res.err
}
```

Безопасно, быстро, без дублирования.

=== Монитор (управляющая горутина)

Альтернативный подход — ограничить кеш одной горутиной и общаться через каналы.

```go
type request struct {
    key      string
    response chan result
}

func (memo *Memo) server(f Func) {
    cache := make(map[string]*entry)
    for req := range memo.requests {
        e := cache[req.key]
        if e == nil {
            e = &entry{ready: make(chan struct{})}
            cache[req.key] = e
            go e.call(f, req.key)
        }
        go e.deliver(req.response)
    }
}
```

=== Ключевая мысль

Параллельный кеш -- это классическая задача, показывающая эволюцию дизайна:

- Наивное решение (гонки)
- Безопасное решение (мьютекс)
- Оптимизированное решение (подавление повторений)
- Альтернативный подход (монитор через каналы)
