package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
)

func main() {
	var n, m int
	fmt.Scanf("%d %d", &n, &m)

	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanWords)

	nums := make([]int, n)
	for i := 0; i < n; i++ {
		scanner.Scan()
		nums[i], _ = strconv.Atoi(scanner.Text())
	}

	// Дек для хранения индексов
	deque := make([]int, 0, n)

	for i := 0; i < n; i++ {
		// 1. Удаляем из конца все элементы >= nums[i]
		for len(deque) > 0 && nums[deque[len(deque)-1]] >= nums[i] {
			deque = deque[:len(deque)-1]
		}

		// 2. Добавляем текущий индекс
		deque = append(deque, i)

		// 3. Удаляем из начала индексы, вышедшие из окна
		if deque[0] <= i-m {
			deque = deque[1:]
		}

		// 4. Печатаем минимум, когда окно сформировано
		if i >= m-1 {
			fmt.Println(nums[deque[0]])
		}
	}
}
