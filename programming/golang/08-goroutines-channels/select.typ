`select` позволяет ждать несколько операций с каналами одновременно.

```go
select {
case <-ch1:
    // ch1 готов
case x := <-ch2:
    // ch2 готов, x — полученное значение
case ch3 <- y:
    // можно отправить в ch3
default:
    // ничего не готово (неблокирующий режим)
}
```

=== Как работает

- select блокируется, пока один из каналов не станет готов.
- Если готово несколько — выбирает случайный.
- Если есть default — не блокируется.

=== Пример: таймер и отмена

```go
func main() {
    abort := make(chan struct{})
    go func() {
        os.Stdin.Read(make([]byte, 1))
        abort <- struct{}{}
    }()

    fmt.Println("Обратный отсчёт. Enter — отмена.")
    select {
    case <-time.After(10 * time.Second):
        launch()
    case <-abort:
        fmt.Println("Отменено!")
    }
}
```

=== Таймеры

```go
ticker := time.NewTicker(1 * time.Second)
defer ticker.Stop()

for countdown := 10; countdown > 0; countdown-- {
    fmt.Println(countdown)
    select {
    case <-ticker.C:
        // прошла секунда
    case <-abort:
        fmt.Println("Отменено!")
        return
    }
}
time.Tick удобен, но создаёт утечку горутины, если не остановить. Используй time.NewTicker и ticker.Stop().
```

=== Неблокирующий select (с default)

```go
select {
case <-abort:
    fmt.Println("Отменено!")
    return
default:
    // ничего не делаем, продолжаем
}
```

=== nil-каналы

Операции с `nil`-каналом блокируются навсегда.
Это позволяет включать/выключать варианты в select.

=== Ключевая мысль

`select` -- это switch для каналов.
Он позволяет ждать несколько событий одновременно и реагировать на первое готовое.
