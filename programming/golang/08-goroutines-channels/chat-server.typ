=== Архитектура

Чат-сервер использует 4 типа горутин:
1. `main` — принимает подключения
2. `broadcaster` — управляет клиентами и рассылает сообщения
3. `handleConn` — обрабатывает одного клиента
4. `clientWriter` — отправляет сообщения клиенту

=== Каналы

```go
type client chan<- string // канал для отправки сообщений клиенту

var (
    entering  = make(chan client)   // новый клиент
    leaving   = make(chan client)   // клиент уходит
    messages  = make(chan string)   // входящие сообщения
)
```

=== Broadcaster

```go
func broadcaster() {
    clients := make(map[client]bool) // все подключённые клиенты

    for {
        select {
        case msg := <-messages:
            // отправить сообщение всем клиентам
            for cli := range clients {
                cli <- msg
            }
        case cli := <-entering:
            clients[cli] = true
        case cli := <-leaving:
            delete(clients, cli)
            close(cli)
        }
    }
}
```

=== Обработка клиента

```go
func handleConn(conn net.Conn) {
    ch := make(chan string)
    go clientWriter(conn, ch)

    who := conn.RemoteAddr().String()
    ch <- "Вы " + who
    messages <- who + " подключился"
    entering <- ch

    input := bufio.NewScanner(conn)
    for input.Scan() {
        messages <- who + ": " + input.Text()
    }

    leaving <- ch
    messages <- who + " отключился"
    conn.Close()
}

func clientWriter(conn net.Conn, ch <-chan string) {
    for msg := range ch {
        fmt.Fprintln(conn, msg)
    }
}
```

=== Как это работает

+ `main` принимает подключения, запускает `handleConn`
+ `handleConn` создаёт канал для клиента, регистрирует его через `entering`
+ Клиент читает сообщения через `clientWriter`
+ Каждое сообщение отправляется в `messages`
+ `broadcaster` получает сообщение и отправляет его всем клиентам
+ При отключении клиент уведомляет через `leaving`

=== Ключевая мысль

Чат-сервер -- это классический пример параллельного приложения,
где горутины и каналы используются для управления множеством клиентов
без явных блокировок.
