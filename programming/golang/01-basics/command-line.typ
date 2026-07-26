== Аргументы командной строки

Первый элемент `os.Args`, `os.Args[0]`, представляет собой имя самой команды;
остальные элементы представляют собой аргументы, которые были переданы программе, 
когда началось ее выполнение

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    var s, sep string
    sep = " "
    for i := 1; i < len(os.Args); i++ {
        s += sep + os.Args[i]
    }
    fmt.Println(s)
}
```

Но можно и так:

```go
package main

import (
    "fmt"
    "os"
)

func main() {
    s, sep := "", " "
    for _, arg := range os.Args[1:] {
        s += sep + arg
    }
    fmt.Println(s)
}
```

== Циклы

=== Цикл for

```go
for инициализация; условие; последействие {
    // тело цикла
}
```

=== Цикл while


```go
// Традиционный цикл while
for условие {
    // тело цикла
}

// Традиционный бесконечный цикл
for {
    // тело цикла
}
```

== Способы объявления

```go
s := ""
var s string
var s = ""
var s string = ""
```
