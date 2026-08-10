package main

import (
	"fmt"
	"bufio"
	"os"
	"strconv"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanWords)

	nums := []int{}
	for scanner.Scan() {
		num, _ := strconv.Atoi(scanner.Text())
		nums = append(nums, num)
	}
	
	max1, max2, min1, min2 := nums[0], nums[1], nums[1], nums[0]

	if max1 <= max2 {
		max1, max2, min1, min2 = nums[1], nums[0], nums[0], nums[1]
	}

	for ind, num := range nums {
		if ind <= 1 {
			continue
		}

		if num > max1 {
			max2 = max1
			max1 = num
		} else if num > max2 {
			max2 = num
		}

		if num < min1 {
			min2 = min1
			min1 = num
		} else if num < min2 {
			min2 = num
		}
	}

	if max1 * max2 > min1 * min2 {
		fmt.Println(max2, max1)
	} else {
		fmt.Println(min1, min2)
	}
}
