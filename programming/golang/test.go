package main

import (
    "fmt"
		"sync"
)

func main() {
    var once sync.Once
    
    defer func() {
        if r := recover(); r != nil {
            fmt.Println("Поймали панику:", r)
        }
    }()
    
    // 1
    once.Do(func() {
        fmt.Println("Выполняем...")
        panic("ошибка!")
    })
    
    // Этот не вызов выполнится!
    once.Do(func() {
        fmt.Println("Повторная попытка")
    })
}

