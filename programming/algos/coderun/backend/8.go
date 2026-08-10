package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	reader := bufio.NewReader(os.Stdin)
	line, _ := reader.ReadString('\n')
	line = line[:len(line)-1] // убираем \n

	stack := []rune{}
	pairs := map[rune]rune{
		')': '(',
		']': '[',
		'}': '{',
	}

	for _, ch := range line {
		if ch == '(' || ch == '[' || ch == '{' {
			stack = append(stack, ch)
		} else {
			if len(stack) == 0 || stack[len(stack)-1] != pairs[ch] {
				fmt.Println("no")
				return
			}
			stack = stack[:len(stack)-1] // pop
		}
	}

	if len(stack) == 0 {
		fmt.Println("yes")
	} else {
		fmt.Println("no")
	}
}
