package main

import (
	"fmt"
	"strings"
)

type Node struct {
  Parent  *Node
  Left    *Node
  Right   *Node
  Key     int
}

func main() {
	var root *Node

	for ind, key := range []int{8, 3, 10, 1, 6, 14, 4, 7, 9} {
		root = TreeInsert(root, &Node{Key: key})
	}

	PrintTree(root)

	fmt.Printf("Где лежит узел с key: 7 -- %p\n", TreeSearch(root, 7))
	fmt.Printf("Проверка: %p == %p?\n", IterativeTreeSearch(root, 7), TreeSearch(root, 7))
	
	fmt.Printf("Минимальный ключ: %d\n", TreeMin(root).Key)
	fmt.Printf("Максимальный ключ: %d\n", TreeMax(root).Key)

	fmt.Printf("Ближайший больший к 7: %p: %d\n", TreeSuccessor(TreeSearch(root, 7)), TreeSuccessor(TreeSearch(root, 7)).Key)
	fmt.Printf("Ближайший  меньший к 7: %p: %d\n", TreePredecessor(TreeSearch(root, 7)), TreePredecessor(TreeSearch(root, 7)).Key)

	fmt.Printf("RecTreeMin == TreeMin? %v\n", RecTreeMin(root) == TreeMin(root))
	fmt.Printf("RecTreeMax == TreeMax? %v\n", RecTreeMax(root) == TreeMax(root))
}

func PrintTree(root *Node) {
    if root == nil {
        fmt.Println("Дерево пустое")
        return
    }

    height := getHeight(root)
    maxWidth := (1 << height) - 1

    // Создаём матрицу
    matrix := make([][]string, height*2-1)
    for i := range matrix {
        matrix[i] = make([]string, maxWidth*2)
        for j := range matrix[i] {
            matrix[i][j] = " "
        }
    }

    fillMatrix(root, matrix, 0, 0, maxWidth*2-1)

    // Печатаем
    for _, row := range matrix {
        line := ""
        for _, ch := range row {
            line += ch
        }
        // Убираем лишние пробелы в конце
        line = strings.TrimRight(line, " ")
        if line != "" {
            fmt.Println(line)
        }
    }
}

func getHeight(node *Node) int {
    if node == nil {
        return 0
    }
    left := getHeight(node.Left)
    right := getHeight(node.Right)
    if left > right {
        return left + 1
    }
    return right + 1
}

func fillMatrix(node *Node, matrix [][]string, level int, left, right int) {
    if node == nil || level >= len(matrix) {
        return
    }

    mid := (left + right) / 2
    matrix[level][mid] = fmt.Sprintf("%d", node.Key)

    if node.Left != nil {
        // Рисуем "/"
        matrix[level+1][mid-1] = "/"
        fillMatrix(node.Left, matrix, level+2, left, mid-1)
    }

    if node.Right != nil {
        // Рисуем "\"
        matrix[level+1][mid+1] = "\\"
        fillMatrix(node.Right, matrix, level+2, mid+1, right)
    }
}


func InorderTreeWalk(x *Node) {
  if x != nil {
    InorderTreeWalk(x.Left)
    fmt.Println(x.Key)
    InorderTreeWalk(x.Right)
  }
}

func TreeSearch(x *Node, k int) *Node {
  if x == nil || k == x.Key {
    return x
  }

  if k < x.Key {
    return TreeSearch(x.Left, k)
  } else {
    return TreeSearch(x.Right, k)
  }
}

func IterativeTreeSearch(x *Node, k int) *Node {
  for x != nil && k != x.Key {
    if k < x.Key {
      x = x.Left
    } else {
      x = x.Right
    }
  }
  return x
}

func TreeMin(x *Node) *Node {
	for x.Left != nil {
		x = x.Left
	}
	return x
}

func TreeMax(x *Node) *Node {
	for x.Right != nil {
		x = x.Right
	}
	return x
}

func RecTreeMin(x *Node) *Node {
	if x.Left != nil {
    	return TreeMin(x.Left)
    }
	return x
}

func RecTreeMax(x *Node) *Node {
	if x.Right != nil {
	  return TreeMax(x.Right)
	}
	return x
}

func TreeSuccessor(x *Node) *Node {
  if x.Right != nil {
    return TreeMin(x.Right)
  }

  temp := x.Parent
  
  for temp != nil && temp.Right == x {
    x = temp
    temp = temp.Parent
  }
  
  return temp
}

func TreePredecessor(x *Node) *Node {
  if x.Left != nil {
    return TreeMin(x.Left)
  }

  temp := x.Parent

  for temp != nil && temp.Left == x {
    x = temp
    temp = temp.Parent
  }

  return temp
}

func TreeInsert(root *Node, n *Node) *Node {
	if root == nil {
		return n
	}
	
	temp := root

	for temp != nil {
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

func TreeDelete(root *Node, z *Node) *Node {
    var nodeToDelete *Node
    var childOfDeleted *Node

    // если детей <= 1 то удалять будем наш узел
    if z.Left == nil || z.Right == nil {
        nodeToDelete = z
    } else {
        // находим кого удалить и на кого сделать подмену
        nodeToDelete = TreeSuccessor(z)
    }

    // Почему ребенок точно один или 0?
    // потому что либо у нас такой узел, либо узел с подменой
    // а TreeSuccessor дает самого левого из правой ветки(первый превосх)
    if nodeToDelete.Left != nil {
        childOfDeleted = nodeToDelete.Left
    } else {
        childOfDeleted = nodeToDelete.Right
    }

    if childOfDeleted != nil {
        childOfDeleted.Parent = nodeToDelete.Parent
    }

    if nodeToDelete.Parent == nil {
        root = childOfDeleted
    } else if nodeToDelete == nodeToDelete.Parent.Left {
        nodeToDelete.Parent.Left = childOfDeleted
    } else {
        nodeToDelete.Parent.Right = childOfDeleted
    }

    if nodeToDelete != z {
        z.Key = nodeToDelete.Key
    }

    return root
}



