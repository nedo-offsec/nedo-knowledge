=== Суть
Пакет `flag` позволяет создавать свои собственные флаги для командной строки. 
Для этого нужно реализовать интерфейс `flag.Value`:

```go
package flag

type Value interface {
    String() string
    Set(string) error
}
```

- String() -- как отображать значение флага.

- Set(string) -- как парсить строку, переданную в флаг, и сохранять значение.


=== Пример: Свой флаг для температуры

Программа позволяет передавать температуру в формате "100C" или "212F" и преобразует её в градусы Цельсия.

=== Как это работает

```go
type celsiusFlag struct{ Celsius }          // Встраивание типа
func (f *celsiusFlag) Set(s string) error {
    var value float64
    var unit string
    fmt.Sscanf(s, "%f%s", &value, &unit)   // Парсинг числа и буквы
    switch unit {
    case "C", "°C":
        f.Celsius = Celsius(value)
    case "F", "°F":
        f.Celsius = FToC(Fahrenheit(value))
    default:
        return fmt.Errorf("неверная температура %q", s)
    }
    return nil
}
```

=== Функция-конструктор

```go
func CelsiusFlag(name string, value Celsius, usage string) *Celsius {
    f := celsiusFlag{value}
    flag.CommandLine.Var(&f, name, usage)  // Регистрация в системе флагов
    return &f.Celsius
}
```

=== Использование

```go
var temp = CelsiusFlag("temp", 20.0, "температура")
func main() {
    flag.Parse()
    fmt.Println(*temp)  // Автоматически вызовется String()
}
```

=== Запуск

```bash
$ ./tempflag -temp -18C
-18°C

$ ./tempflag -temp 212°F
100°C
```

== Ключевая мысль
Интерфейс `flag.Value` даёт возможность расширить стандартную библиотеку Go,
не меняя её код. Достаточно определить свой тип и реализовать два метода --
`String()` и `Set()`.
