=== Простейший эхо-сервер (синхронный)

```go
func handleConn(c net.Conn) {
    io.Copy(c, c) // читает и сразу пишет обратно
    c.Close()
}
```

=== Эхо с задержкой (синхронный)

```go
func echo(c net.Conn, shout string, delay time.Duration) {
    fmt.Fprintln(c, "\t", strings.ToUpper(shout))
    time.Sleep(delay)
    fmt.Fprintln(c, "\t", shout)
    time.Sleep(delay)
    fmt.Fprintln(c, "\t", strings.ToLower(shout))
}

func handleConn(c net.Conn) {
    input := bufio.NewScanner(c)
    for input.Scan() {
        echo(c, input.Text(), 1*time.Second) // синхронно
    }
    c.Close()
}
```

Проблема: пока обрабатывается один "крик", новый ввод не принимается.

=== Параллельный эхо-сервер

Достаточно добавить `go` перед вызовом `echo`:

```go
func handleConn(c net.Conn) {
    input := bufio.NewScanner(c)
    for input.Scan() {
        go echo(c, input.Text(), 1*time.Second) // асинхронно
    }
    c.Close()
}
```

Теперь каждый "крик" обрабатывается в своей горутине.
Ответы приходят независимо друг от друга.

=== Клиент

```go
func main() {
    conn, err := net.Dial("tcp", "localhost:8000")
    if err != nil {
        log.Fatal(err)
    }
    defer conn.Close()

    go mustCopy(os.Stdout, conn) // читаем ответ сервера
    mustCopy(conn, os.Stdin)     // отправляем ввод на сервер
}
```

Одна горутина читает ответы, другая отправляет запросы -- параллельно.

=== Важно!

При вызове `go echo(...)` аргументы вычисляются в момент вызова,
но сама функция запускается асинхронно.

=== Ключевая мысль

Одно слово `go` превращает синхронный сервер в параллельный.
Горутины позволяют обрабатывать несколько соединений и несколько операций
внутри одного соединения одновременно.

