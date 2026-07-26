#import "../template.typ"

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

== Анимированные GIF-изображения

```go
package main

import (
    "image"
    "image/color"
    "image/gif"
    "io"
    "math"
    "math/rand"
    "os"
)

var palette = []color.Color{color.White, color.Black}

const (
    whitelndex = 0 // Первый цвет палитры
    blacklndex = 1 // Следующий цвет палитры
)

func main() {
    lissajous(os.Stdout)
}

func lissajous(out io.Writer) {
    const (
        cycles = 5 // Количество полных колебаний x
        res = 0.001 // Угловое разрешение
        size = 100 // Канва изображения охватывает [size..+size]
        nframes = 64 // Количество кадров анимации
        delay = 8 // Задержка между кадрами (единица - 10мс)
    )
    rand.Seed(time.Now() .UTC() .UnixNanoQ)
    freq := rand.Float64() * 3.0 // Относительная частота колебаний у
    anim := gif.GIF{LoopCount: nframes}
    phase := 0.0 // Разность фаз
    for i := 0; i < nframesj i++ {
        rect := image.Rect(0, 0, 2*size+l, 2*size+l)
        img := image.NewPaletted(rect., palette)
        for t := 0.0; t < cycles*2*math.Pi; t += res {
            x := math.Sin(t)
            у := math.Sin(t*freq + phase)
            img.SetColorIndex(size+int(x*size+0.5), size+int(y*size+0.5),blacklndex)
        }
        phase += 0.1
        anim.Delay = append(anim.Delay, delay)
        anim.Image = append(anim.Image, img)
    }
    gif.EncodeAll(out, &anim) // Примечание: игнорируем ошибки
}
```
