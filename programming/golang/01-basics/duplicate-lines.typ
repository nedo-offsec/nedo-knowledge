== Поиск повторяющихся строк

```go
package main

import (
    "bufio"
    "fmt"
    "os"
)

func main() {
    counts := make(map[string]int)
    input := bufio.NewScanner(os.Stdin)
    for input.Scan() {
        counts[input.Text()]++
    }
    for line, n := range counts {
        if n > 1 {
            fmt.Printf("%d\t%s\n", n, line)
        }
    }
}
```

Про fmt.Printf:

#table(
  columns: (auto, auto),
  [*Аттрбут*], [*Описание*],
  [`%d`], [Десятичное целое],
  [`%x`, `%o`, `%b`], [Целое в hex, oct, bin представлениях],
  [`%f`, `%g`, `%e`], [Числа с плавающей точкой: 3.141593, 3.141592653589793, 3.141593е+00],
  [`%t`], [Булево значение: true или false],
  [`%c`], [Руна (символ Unicode)],
  [`%s`], [Строка],
  [`%q`], [Выводит в кавычках строку типа "abc" или символ типа 'c'],
  [`%v`], [Любое значение в естественном формате],
  [`%T`], [Тип любого значения],
  [`%%`], [Символ процента не требует операнда],
)

Простейшая программа которая выводит текст каждой строки, которая
появляется во входных данных более одного раза:

```go
package main

import (
    "bufio"
    "fmt"
    "os"
)

func main() {
    counts := make(map[sting]int)
    files := os.Args[1:]
    if len(files) == 0 {
        countLines(os.Stdin, counts)
    } else {
        for _, arg := range files {
            f, err := os.Open(arg)
            if err != nil {
                fmt.Fprintf(os.Stderr, "dup2: %v\n", err)
                continue
            }
            countLines(f, counts)
            f.Close()
        }
    }
    for line, n := range counts {
        if n > 1 {
            fmt.Printf("%d\t%s\n", n, line)
        }
    }
}

func countLines(f *os.File, counts map[string]int) {
    input := bufio.NewScanner(f)
    for input.Scan() {
        counts[input.Text()]++
    }
}
```
