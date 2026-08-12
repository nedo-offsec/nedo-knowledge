package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	var x, y, z, s string
	fmt.Fscan(reader, &x, &y, &z)
	fmt.Fscan(reader, &s)

	set := make(map[rune]struct{})
	for _, ch := range s {
		set[ch] = struct{}{}
	}

	count := len(set)
	for key := range set {
		if key == []rune(x)[0] || key == []rune(y)[0] || key == []rune(z)[0] {
			count--
		}
	}
	fmt.Println(count)
}
