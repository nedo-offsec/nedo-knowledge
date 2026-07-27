=== Важные интерфейсы из пакета io

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Closer interface {
    Close() error
}
```

=== Встраивание интерфейсов (Interface Embedding)

Интерфейсы можно встраивать друг в друга, как структуры.

```go
type ReadWriter interface {
    Reader
    Writer
}

type ReadWriteCloser interface {
    Reader
    Writer
    Closer
}
```

Эквивалентно (без встраивания):

```go
type ReadWriter interface {
    Read(p []byte) (n int, err error)
    Write(p []byte) (n int, err error)
}
```

=== Комбинация стилей

```go
type ReadWriter interface {
    Read(p []byte) (n int, err error)
    Writer
}
```

=== Правила встраивания

Порядок методов не важен. Важно только их наличие.

Дублирование методов недопустимо. Если два встроенных интерфейса имеют методы
с одинаковыми именами и сигнатурами, это нормально. Если сигнатуры разные --
ошибка компиляции.

Встраивание работает только для интерфейсов.
Встраивать структуры в интерфейсы *НЕЛЬЗЯ*.

=== Что важно запомнить

- Интерфейс определяет поведение.
- Конкретный тип реализует интерфейс неявно.
- Встраивание помогает строить сложные интерфейсы из простых.

=== Пример: fmt.Fprintf и io.Writer

```go
func Fprintf(w io.Writer, format string, args ...interface{}) (int, error)
Fprintf не знает, что за тип передан в w:
```
- Это файл?
- Это буфер в памяти?
- Это сетевое соединение?
- Ему важно только одно: у типа есть метод Write.
