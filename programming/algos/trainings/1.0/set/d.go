package main

import (
	"fmt"
	"bufio"
	"os"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanWords)

	set := make(map[string]struct{})

	for scanner.Scan() {
		set[scanner.Text()] = struct{}{}
	}
	fmt.Println(len(set))
}
