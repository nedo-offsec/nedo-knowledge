package main

import (
	"fmt"
	"bufio"
	"os"
	"strconv"
)

type Node struct {
	Key		int
	Parent	*Node
	Left	*Node
	Right	*Node
}

func main() {
	scanner := bufio.NewScanner(os.Stdin)
	// режем по пробелам, табам, переносам
	scanner.Split(bufio.ScanWords) 

	var nums []int
	for scanner.Scan() {
		num, _ := strconv.Atoi(scanner.Text())
		if num == 0 {
			break
		}
		nums = append(nums, num)
	}
	
	var root *Node
	
	for i := 0; i < len(nums); i++ {
		temp := &Node{Key: nums[i]}
		root = Insert(root, temp)

	}

	fmt.Println(height(root))
}

func Insert(root *Node, n *Node) *Node {
	if root == nil {
		return n
	}
	
	temp := root

	for temp != nil {
		if n.Key == temp.Key {
			return root
		}

		if n.Key > temp.Key {
			if temp.Right == nil {
				temp.Right = n
				n.Parent = temp
				break
			}
			temp = temp.Right
			
		} else if n.Key < temp.Key {
			if temp.Left == nil {
				temp.Left = n
				n.Parent = temp
				break
			}
			temp = temp.Left
		} 
	}
	return root
}

func height(root *Node) int {
    if root == nil {
        return 0
    }
    leftHeight := height(root.Left)
    rightHeight := height(root.Right)

    if leftHeight > rightHeight {
        return leftHeight + 1
    }
    return rightHeight + 1
}
