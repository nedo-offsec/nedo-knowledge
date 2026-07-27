=== Два стиля интерфейсов

+ *Полиморфизм подтипов* -- интерфейс определяет поведение (методы).  
  Примеры: `io.Reader`, `http.Handler`, `sort.Interface`.

+ *Распознаваемое объединение* -- интерфейс хранит один из множества типов.  
  Акцент на том, *какой* это тип, а не на методах.

=== Пример: `sqlQuote`

Функция преобразует значение любого типа в SQL-литерал:

```go
func sqlQuote(x interface{}) string {
    switch x := x.(type) {
    case nil:
        return "NULL"
    case int, uint:
        return fmt.Sprintf("%d", x)   // x — interface{}, но мы знаем, что это число
    case bool:
        if x {
            return "TRUE"
        }
        return "FALSE"
    case string:
        return sqlQuoteString(x)      // x — string
    default:
        panic(fmt.Sprintf("unexpected type %T: %v", x, x))
    }
}
```

=== Синтаксис

```go
switch x := x.(type) {
case nil:
    // x — interface{} (nil)
case int:
    // x — int
case string:
    // x — string
case bool, uint:
    // x — interface{} (несколько типов в одном case)
default:
    // x — interface{}
}
```

=== Как это работает

`x.(type)` -- это специальная форма для switch.

В каждом `case` переменная x имеет конкретный тип этого case.

Если в одном case несколько типов (например, `int`, `uint`), то `x`
остаётся `interface{}`.

=== Порядок важен

Если один тип является интерфейсом, он может "поглотить" другие. Например:

```go
switch x.(type) {
case fmt.Stringer:
    // ...
case string:
    // ...
}
```

Здесь `string` никогда не выполнится, потому что `string` реализует `fmt.Stringer`.

=== Где используется

- Парсинг JSON/YAML.
- Обработка SQL-запросов (как в примере).
- Логирование значений разных типов.
- Работа с `interface{}` в обобщённых функциях.

=== Ключевая мысль

Выбор типа -- это способ заглянуть внутрь `interface{}` и сделать разную
логику для разных типов. Это как `switch`, но не по значению, а по типу.
