package main

import (
    "fmt"
    "bufio"
    "os"
)

func main() {
    reader := bufio.NewReader(os.Stdin)
    data := make(map[string]string)
    var n int

    var temp1, temp2 string
    fmt.Fscan(reader, &n)
    for i := 0; i < n; i++ {
        fmt.Fscan(reader, &temp1, &temp2)
        data[temp1] = temp2
        data[temp2] = temp1
    }

    fmt.Fscan(reader, &temp1)
    fmt.Println(data[temp1])
}
