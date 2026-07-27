=== Суть
В Go ошибка -- это не магия. Это просто интерфейс:

```go
type error interface {
    Error() string
}
```

Любой тип, у которого есть метод `Error() string`, автоматически является ошибкой.

=== Как создать ошибку

```go
import "errors"

err := errors.New("something went wrong")
```

Внутри `errors.New` возвращает указатель на структуру `errorString`, которая реализует `error`.

```go
package errors

type errorString struct { text string }

func (e *errorString) Error() string { return e.text }
```

=== Почему там указатель, а не значение?

Чтобы две ошибки с одинаковым текстом не были равны:

```go
fmt.Println(errors.New("EOF") == errors.New("EOF")) // false
```

Если бы использовалась структура, а не указатель, они могли бы быть равны,
и это нарушило бы логику работы с `io.EOF`.

=== Форматирование ошибок

```go
import "fmt"

err := fmt.Errorf("file %s not found", filename)
```

`fmt.Errorf` -- это обёртка над `errors.New`, которая сначала форматирует строку.

=== Пример: системная ошибка

```go
package syscall

type Errno uintptr

var errors = [...]string{
    1: "operation not permitted",
    2: "no such file or directory",
}

func (e Errno) Error() string {
    if int(e) < len(errors) {
        return errors[e]
    }
    return fmt.Sprintf("errno %d", e)
}
```

Теперь `syscall.Errno(2)` -- это ошибка с текстом "no such file or directory".

=== Ключевая мысль

Интерфейс error -- это просто контракт на метод `Error()`.
Это даёт гибкость: можно возвращать ошибки разных типов,
но работать с ними через один интерфейс.
