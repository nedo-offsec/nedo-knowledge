package main

import (
	"fmt"
	"bufio"
	"os"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	var s1, s2 string
	fmt.Fscan(reader, &s1, &s2)

	set := make(map[string]int)

	for i := 1; i < len(s1); i++ {
		set[s1[i-1:i+1]]++ 
	}
	
	genom2 := make(map[string]struct{})

	for i := 1; i < len(s2); i++ {
		genom2[s2[i-1:i+1]] = struct{}{}
	}

	result := 0
	for key, _ := range genom2 {
		result += set[key]
	}
	fmt.Println(result)
}
