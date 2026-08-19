package main

import (
    "fmt"
)

func main() {
	s := "При\xffвет" // невалидный байт \xff
	for i, r := range s {
		fmt.Printf("%d: %U\n", i, r)
	}
	// 0: U+041F
	// 2: U+0440
	// 4: U+0438
	// 6: U+FFFD (ошибка)
	// 7: U+0432
	// 9: U+0435
	// 11: U+0442
}
