package main

import (
	"fmt"
	"os"
	"bufio"
)

func main() {
	reader := bufio.NewReader(os.Stdin)

	var n int
	fmt.Fscan(reader, &n)

	set := make(map[int]struct{})

	var a, b int
	for i := 0; i < n; i++ {
		fmt.Fscan(reader, &a, &b)
		set[a] = struct{}{}
	}

	fmt.Println(len(set))
}
