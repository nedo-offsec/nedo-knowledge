package main

import (
	"fmt"
	"bufio"
	"os"
)

func main() {
	reader := bufio.NewReader(os.Stdin)

	var n int
	fmt.Fscan(reader, &n)

	var a, b int
	
	set := make(map[int]struct{})
	for i := 1; i <= n; i++ {
		fmt.Fscan(reader, &a, &b)
		if a >= 0 && b >= 0 && (a + b == n-1) {
			set[a] = struct{}{}
		}
	}
	fmt.Println(len(set))
}
