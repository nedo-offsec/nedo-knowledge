package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	reader := bufio.NewReader(os.Stdin)

	var n int
	fmt.Fscan(reader, &n)

	a := make([]int, n)
	sum := 0
	for i := range a {
		fmt.Fscan(reader, &a[i])
		sum += a[i]
	}

	groups := n - 1
	if sum%groups != 0 {
		fmt.Println("NO")
		return
	}
	target := sum / groups

	ans := "NO"
	for i := 0; i < n && ans == "NO"; i++ {
		for j := i + 1; j < n; j++ {
			if a[i]+a[j] != target {
				continue
			}
			ok := true
			for k := 0; k < n; k++ {
				if k == i || k == j {
					continue
				}
				if a[k] != target {
					ok = false
					break
				}
			}
			if ok {
				ans = "YES"
				break
			}
		}
	}

	fmt.Println(ans)
}
