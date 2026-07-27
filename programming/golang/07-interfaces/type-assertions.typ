=== Суть
Декларация типа (type assertion) — это операция, которая извлекает значение из интерфейса.

Синтаксис: `x.(T)`
- `x` — значение интерфейсного типа
- `T` — декларируемый тип

=== Два варианта

==== Вариант 1: Конкретный тип

Если `T` — конкретный тип, то `x.(T)` проверяет, хранит ли `x` именно этот тип.

```go
var w io.Writer
w = os.Stdout

f := w.(*os.File)       // OK: f == os.Stdout
c := w.(*bytes.Buffer)  // Паника: интерфейс хранит *os.File, а не *bytes.Buffer
```

==== Вариант 2: Интерфейс

Если `T` -- интерфейс, то `x.(T)` проверяет, реализует ли динамический тип `x`
интерфейс `T`.

```go
var w io.Writer = os.Stdout
rw := w.(io.ReadWriter) // OK: *os.File реализует io.ReadWriter
```

=== Безопасная форма (с проверкой)

```go
f, ok := w.(*os.File)
if ok {
    // f — *os.File, можно использовать
} else {
    // w хранит не *os.File
}
```

Если декларация неудачна, `ok == false`, а значение - нулевое для этого типа.

=== Пример: распознавание ошибок

Пакет os определяет структуру PathError:

```go
type PathError struct {
    Op   string
    Path string
    Err  error
}

func (e *PathError) Error() string {
    return e.Op + " " + e.Path + ": " + e.Err.Error()
}
```

Функция `os.IsNotExist` использует декларацию типа для проверки:

```go
func IsNotExist(err error) bool {
    if pe, ok := err.(*PathError); ok {
        err = pe.Err
    }
    return err == syscall.ENOENT || err == ErrNotExist
}
```

Теперь можно отличить "файл не найден" от других ошибок.

```go
err := os.Open("/no/such/file")
fmt.Println(os.IsNotExist(err)) // true
```

=== Ключевая мысль

Декларация типа (`x.(T)`) -- это способ заглянуть внутрь интерфейса и
получить конкретное значение или проверить, какой тип там хранится.
Используй безопасную форму с `ok`, чтобы избежать паники.
