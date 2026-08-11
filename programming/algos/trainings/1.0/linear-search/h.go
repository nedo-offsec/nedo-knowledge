package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"slices"
)

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanWords)

	nums := []int{}
	for scanner.Scan() {
		num, _ := strconv.Atoi(scanner.Text())
		nums = append(nums, num)
	}

	if len(nums) < 3 {
		return
	}

	arr := []int{nums[0], nums[1], nums[2]}
	slices.Sort(arr)
	min1, min2, min3 := arr[0], arr[1], arr[2]
	max1, max2, max3 := arr[2], arr[1], arr[0]

	for _, num := range nums[3:] {
		if num > max1 {
			max3 = max2
			max2 = max1
			max1 = num
		} else if num > max2 {
			max3 = max2
			max2 = num
		} else if num > max3 {
			max3 = num
		}

		if num < min1 {
			min3 = min2
			min2 = min1
			min1 = num
		} else if num < min2 {
			min3 = min2
			min2 = num
		} else if num < min3 {
			min3 = num
		}
	}

	res1 := max1 * max2 * max3
	res2 := max1 * max2 * min1
	res3 := max1 * min1 * min2

	if res1 >= res2 && res1 >= res3 {
		fmt.Println(max3, max2, max1)
	} else if res2 >= res1 && res2 >= res3 {
		fmt.Println(min1, max2, max1)
	} else {
		fmt.Println(min1, min2, max1)
	}
}
