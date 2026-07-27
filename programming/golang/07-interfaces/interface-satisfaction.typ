Тип соответствует (удовлетворяет) интерфейсу, если он обладает всеми методами,
которые требует интерфейс.

Правило присваиваемости интерфейсов очень простое:

выражение может быть присвоено интерфейсу, только если его тип соответствует этому интерфейсу.

Таким образом:

```go
var w io.Writer
w = os.Stdout           // OK: *os.File имеет метод Write
w = new(bytes.Buffer)   // OK: *bytes.Buffer имеет метод Write
w = time.Second         // Ошибка: у time.Duration нет метода Write

var rwc io.ReadWriteCloser
rwc = os.Stdout         // OK: *os.File имеет методы Read, Write, Close
rwc = new(bytes.Buffer) // Ошибка: у *bytes.Buffer нет метода Close
```

Это правило применимо даже тогда, когда правая сторона сама по себе является
интерфейсом:

```go
w = rwc                 // OK: io.ReadWriteCloser имеет метод Write
rwc = w                 // Ошибка: io.Writer не имеет метода Close
```

=== Тонкий момент: Получатель (Pointer vs Value)

Метод с получателем-указателем (`*`T) и метод с получателем-значением (T) — это разные вещи.

Если метод объявлен как func (t `*`T) Method(), то интерфейсу удовлетворяет только `*`T.

Если метод объявлен как func (t T) Method(), то интерфейсу удовлетворяют и T, и `*`T.

*ПРИМЕР:*

```go
type IntSet struct { /* ... */ }
func (*IntSet) String() string  // метод с получателем-указателем

var s IntSet

var _ fmt.Stringer = &s // OK: *IntSet имеет метод String
var _ fmt.Stringer = s  // Ошибка: у IntSet нет метода String
```

=== Композиция интерфейсов
Если интерфейс A встроен в интерфейс B,
то для удовлетворения B нужно реализовать все методы A и B.

``` go
type Reader interface { Read(p []byte) (n int, err error) }
type Writer interface { Write(p []byte) (n int, err error) }
type ReadWriter interface {
    Reader
    Writer
}
```

=== Пустой интерфейс interface{}
interface{} не имеет методов. Ему удовлетворяет любой тип.

```go
var any interface{}
any = true
any = 42
any = "hello"
any = map[string]int{"one": 1}
```
