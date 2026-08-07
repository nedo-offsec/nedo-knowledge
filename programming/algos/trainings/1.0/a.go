package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanWords)

	last := 0
	count := 0
	flag := true

	for scanner.Scan() {
		num, _ := strconv.Atoi(scanner.Text())
		if count == 0 {
			last = num
			count++
			continue
		}
		if (num - last) <= 0 {
			flag = false
			break
		}
		last = num
	}
	if flag {
		fmt.Printf("YES")
	} else {
		fmt.Printf("NO")
	}
}
