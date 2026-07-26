== Параллельная выборка URL

Важной фишкой Go является поддержка параллельного программирования

```go
package main

import (
    "fmt"
    "io"
    "io/ioutil"
    "net/http"
    "os"
    "time"
)

func main() {
    start := time.Now()
    ch := make(chan string)
    for _, url := range os.Args[1:] {
        go fetch(url, ch)
    }
    for range os.Args[1:] {
        fmt.Println(<-ch)
    }
    fmt.Printf("%.2fs elapsed\n", time.Since(start).Seconds())
}

func fetch(url string, ch chan<- string) {
    start := time.Now()
    resp, err := http.Get(url)
    if err != nil {
        ch <- fmt.Sprint(err)
        return
    }
    nbytes, err := io.Copy(ioutil.Discard, resp.Body)
    resp.Body.Close()
    if err != nil {
        ch <- fmt.Sprintf("while reading %s: %v", url, err)
        return
    }
    secs := time.Since(start).Seconds()
    ch <- fmt.Sprintf("%.2fs %7d %s", secs, nbytes, url)
}
```

`go` -- это горутины, они представляют собой параллельное выполнение
функции. _Канал_ является механизмом связи, который позволяет 
одной горутине передавать значения определенного типа другой
горутине. 

Функция `main` выполняется в горутине, а инструкция go создает
дополнительные горутины. Также функция `main` создает канал строк 
с помощью `make`. Для каждого аргумента командной строки инструкция
`go` в первом цикле по диапазону запускает новую горутину, которую
fetch вызывает асинхронно для выборки URL. При получении каждого
каждого результата `fetch` отправляет итоговую строку в канал ch, а
второй цикл получает и выводит эти строки.
