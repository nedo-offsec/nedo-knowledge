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

	nums := make([]int, n)
	for i := 0; i < n; i++ {
		fmt.Fscan(reader, &nums[i])
	}

	j := n-1
	middle := n-1

	for i := 0; i < j; i++ {
		if nums[i] == nums[j] {
			i_2, j_2 := i, j
			flag := true
			for i_2 < n && j_2 > 0 {
				if nums[i_2] != nums[j_2] {
					flag = false
					break
				}
				i_2++
				j_2--
			}
			if flag {
				middle = i
				break
			}
		}
	}

	fmt.Println(middle)
	for i := middle-1; i >= 0; i-- {
		fmt.Printf("%d", nums[i])
		if i != 0 {
			fmt.Printf(" ")
		} else {
			fmt.Printf("\n")
		}
	}
}
