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

	set := make(map[string]int)
	

	var s string
	var amount int

	for i := 0; i < n; i++ {
		fmt.Fscan(reader, &amount)	
		for j := 0; j < amount; j++ {
			fmt.Fscan(reader, &s)
			set[s]++
		}
	}

	languages := []string{}
	for key, _ := range set {
		if set[key] == n {
			languages = append(languages, key)
		}
	}

	fmt.Println(len(languages))
	for i := 0; i < len(languages); i++ {
		fmt.Println(languages[i])
	}

	fmt.Println(len(set))
	for key, _ := range set {
		fmt.Println(key)
	}
}
