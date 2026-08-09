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

    // dp[0] - 0 единиц подряд в конце, dp[1] - 1 единица, dp[2] - 2 единицы
    dp0, dp1, dp2 := 1, 1, 0

    for i := 2; i <= n; i++ {
        newDp0 := dp0 + dp1 + dp2 	// добавляем 0
        newDp1 := dp0            	// добавляем 1 к концу на 0
        newDp2 := dp1            	// добавляем 1 к концу на 1

        dp0, dp1, dp2 = newDp0, newDp1, newDp2
    }

    fmt.Println(dp0 + dp1 + dp2)
}
