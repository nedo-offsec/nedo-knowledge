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

	nums := make([]int, n)

	var max int
	var max_ind int
	
	ind := 0
	for i := 0; i < n; i++ {
		fmt.Fscan(reader, &nums[i])
		if nums[i] > max {
			max = nums[i]
			max_ind = ind
		}
		ind++
	}


	vasya := -1
	for i := 0; i < len(nums)-1; i++ {
		if nums[i] % 10 == 5 && nums[i+1] < nums[i] && i > max_ind {
			if nums[i] > vasya {
				vasya = nums[i]
			}
		}
	}

	if vasya == -1 {
		fmt.Println(0)
	} else {
		place := 1
		for j := 0; j < n; j++ {
			if nums[j] > vasya {
				place++
			}
		}
		fmt.Println(place)
	}
}
