=== Суть
В Go веб-сервер строится на интерфейсе `http.Handler`:

```go
package http

type Handler interface {
    ServeHTTP(w ResponseWriter, r *Request)
}
```

Любой тип, у которого есть метод ServeHTTP, является обработчиком HTTP-запросов.

=== Простейший сервер

```go
type database map[string]float64

func (db database) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    for item, price := range db {
        fmt.Fprintf(w, "%s: %.2f\n", item, price)
    }
}

func main() {
    db := database{"shoes": 50, "socks": 5}
    log.Fatal(http.ListenAndServe("localhost:8000", db))
}
```

Сервер принимает любой запрос и выводит все товары.

=== Маршрутизация по URL

```go
func (db database) ServeHTTP(w http.ResponseWriter, r *http.Request) {
    switch r.URL.Path {
    case "/list":
        for item, price := range db {
            fmt.Fprintf(w, "%s: %.2f\n", item, price)
        }
    case "/price":
        item := r.URL.Query().Get("item")
        price, ok := db[item]
        if !ok {
            http.Error(w, "not found", http.StatusNotFound)
            return
        }
        fmt.Fprintf(w, "%.2f\n", price)
    default:
        http.Error(w, "not found", http.StatusNotFound)
    }
}
```

=== Использование ServeMux (мультиплексор)

```go
func main() {
    db := database{"shoes": 50, "socks": 5}
    mux := http.NewServeMux()
    mux.Handle("/list", http.HandlerFunc(db.list))
    mux.Handle("/price", http.HandlerFunc(db.price))
    log.Fatal(http.ListenAndServe("localhost:8000", mux))
}
```

ServeMux -- это роутер. Он сопоставляет URL с обработчиками.

=== Функция как обработчик (http.HandlerFunc)

```go
type HandlerFunc func(w ResponseWriter, r *Request)

func (f HandlerFunc) ServeHTTP(w ResponseWriter, r *Request) {
    f(w, r)
}
`HandlerFunc` -- это адаптер. Любая функция с сигнатурой `func(w http.ResponseWriter, r *http.Request)` может стать `http.Handler` через преобразование типа.
```

```go
mux.Handle("/list", http.HandlerFunc(db.list))  // явно
mux.HandleFunc("/list", db.list)               // сокращённо
```

=== Глобальный DefaultServeMux

```go
func main() {
    db := database{"shoes": 50, "socks": 5}
    http.HandleFunc("/list", db.list)   // регистрирует в глобальном роутере
    http.HandleFunc("/price", db.price)
    log.Fatal(http.ListenAndServe("localhost:8000", nil)) // nil = DefaultServeMux
}
```

=== Важно!

Каждый HTTP-запрос обрабатывается в своей go-подпрограмме. Если обработчик меняет общие данные -- используй sync.Mutex, чтобы избежать гонок.

=== Ключевая мысль

Интерфейс `http.Handler` и `ServeMux` делают веб-серверы гибкими.
Можно регистрировать любые обработчики, не меняя структуру сервера.
