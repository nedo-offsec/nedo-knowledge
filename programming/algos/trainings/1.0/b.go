package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func getStatus(current, prev int, hasEqual, hasIncrease, hasDecrease bool) (bool, bool, bool) {
	if current == prev {
		hasEqual = true
	} else if current > prev {
		hasIncrease = true
	} else if current < prev {
		hasDecrease = true
	}
	return hasEqual, hasIncrease, hasDecrease
}

func determineStatus(hasEqual, hasIncrease, hasDecrease bool) string {
	if hasIncrease && hasDecrease {
		return "RANDOM"
	}
	if hasIncrease && !hasDecrease && !hasEqual {
		return "ASCENDING"
	}
	if hasIncrease && !hasDecrease && hasEqual {
		return "WEAKLY ASCENDING"
	}
	if !hasIncrease && hasDecrease && !hasEqual {
		return "DESCENDING"
	}
	if !hasIncrease && hasDecrease && hasEqual {
		return "WEAKLY DESCENDING"
	}
	if !hasIncrease && !hasDecrease && hasEqual {
		return "CONSTANT"
	}
	return "RANDOM" 
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	
	var prev int
	count := 0
	hasEqual := false
	hasIncrease := false
	hasDecrease := false

	for scanner.Scan() {
		num, _ := strconv.Atoi(scanner.Text())
		
		if num == -2000000000 {
			break
		}
		
		if count == 0 {
			prev = num
			count++
			continue
		}

		hasEqual, hasIncrease, hasDecrease = getStatus(num, prev, hasEqual, hasIncrease, hasDecrease)
		
		if hasIncrease && hasDecrease {
			break
		}
		
		prev = num
		count++
	}

	fmt.Println(determineStatus(hasEqual, hasIncrease, hasDecrease))
}
