= Бинарные деревья поиска

Во-первых, это *бинарное* дерево:

Такое дерево может быть представлено при помощи связанной структуры
данных, в которой каждой узел является объектом.

```go
type Node struct {
  Parent  *Node
  Left    *Node
  Right   *Node
  Key     int
}
```

#image("assets/bt.png")

Ключи в бинарном дереве поиска хранятся таким образом,
чтобы в любой момент удовлетворять *СВОЙСТВУ БИНАРНОГО ДЕРЕВА ПОИСКА*:

_Если x -- узел бинарного дерева поиска, а узел y находится в левом
поддереве x, то_
$ "key" [y] <= "key" [x] $

_Если узел y находится в правом поддереве x, то_
$ "key" [x] <= "key" [y] $

#pagebreak()

== Обход дерева (Inorder Tree Walk)

Свойство бинарного дерева позволяет вывести все ключи в отсортированном
порядке с помощью простого рекурсивного алгоритма --
*ЦЕНТРИРОВАННОГО (СИММЕТРИЧНОГО) ОБХОДА ДЕРЕВА* (Inorder tree walk):

```go
func InorderTreeWalk(x *Node) {
  if x != nil {
    InorderTreeWalk(x.Left)
    fmt.Println(x.Key)
    InorderTreeWalk(x.Right)
  }
}
```

*Ассимптотическая сложность алгоритма*: $Theta.alt (n)$

Потому что после начального вызова процедура вызываетя ровно два раза
для каждого узла дерева -- по разу для левого и правого узлов.

*ТЕОРЕМА*:

_Если x -- корень поддерева, в котором имеется n узлов, то 
процедура InorderTreeWalk(x) выполняется за время_ $Theta.alt (n)$.

*ДОКАЗАТЕЛЬСТВО* Если че потом добавлю из Кормена, 
мне контест проходить надо баля...

#pagebreak()
== Поиск

```go
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
```

А теперь запилим итеративный поиск:

```go
func IterativeTreeSearch(x *Node, k int) *Node {
  var temp *Node
  temp = x
  for temp != nil && k != temp.Key {
    if k < temp.Key {
      temp = temp.Left
    } else {
      temp = temp.Right
    }
  }
  return temp
}
```

== Поиск минимума и максимума

Ну, будем честны, зная свойство найти минимум и максимум предельно легко)

```go
func TreeMin(x *Node) *Node {
	temp := x
	for temp.Left != nil {
		temp = temp.Left
	}
	return temp
}
```
Аналогично для поиска максимального:

```go
func TreeMax(x *Node) *Node {
	temp := x
	for temp.Right != nil {
		temp = temp.Right
	}
	return temp
}
```

== Предшествующий и последующий элементы

Иногда, имея узел в бинарном дереве поиска, требуется определить,
какой узел следует за ним в отсортированной последовательности. 

_Скажем у нас дерево это станции метро, причем их ключи --
это ничто иное как важность географического расположения или 
личностной оценки (условно говоря там куча тцшек, парков и тп)_

_И вот сначала надо найти ближайший по пользе к текущему,
а затем построить кратчайший маршрут... (лан, пример хуйня)_

```go
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
```
*ОБЪЯСНЕНИЕ*:

Искомый элемент это подходящая нам ветка, но если там пусто, то
искомый элемент должен быть где-то выше. 

Почему?

если правая ветка нашего узла пуста, то если мы часть правой ветки
родителя, то мы больше родителя, элемент меньше родителя не подходит,
мы ищем случай, когда подветка окажется левой, тогда родитель будет больше
ее и всех разобранных подветок и он будет искомый элемент, либо же
искомого нет и мы являемся максимальным элементом

*ТЕОРЕМА*:

_Операции поиска, определения минимального и максимального
элемента, а также предшествующего и последующего, в бинарном дереве поиска
высоты h могут быть выполнены за время $O (h)$._

#pagebreak()
== Упражнения

1: Пусть у нас имеется ряд чисел от 1 до 1000, организованных в виде
бинарного дерева поиска, и мы выполняем поиск числа 363. 
Какая из следующих последовательностей *НЕ МОЖЕТ* быть 
последовательностью проверяемых узлов?

+ 2, 252, 401, 398, 330, 344, 397, 363.
+ 924, 220, 911, 244, 898, 258, 362, 363.
+ 925, 202, 911, 240, 912, 245, 363.
+ 2, 399, 387, 219, 266, 382, 381, 278, 363.
+ 935, 278, 347, 621, 299, 392, 358, 363.

Ответ: 3 и 5
Почему 3: потому что $911 -> 240$ значит все остальные меньше 911:
$911<912$

Почему 5: потому что $347 -> 621$ значит все остальные больше 347:
$299<347$

2: Разработайте рекурсивные версии процедур TreeMin, TreeMax

```go
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
```

3: Разработайте процедуру TreePredecessor
```go
func TreePredecessor(x *Node) *Node {
  if x.Left != nil {
    return TreeMin(x.Left)
  }

  temp := x.Parent

  for temp2 != nil && temp.Left == x {
    x = temp
    temp = temp.Parent
  }

  return temp
}
```

4: Разбираясь с бинарными деревьями поиска, студент решил,
что обнаружил их новое замечательное свойство.
Предположим, что поиск ключа k
в бинарном дереве поиска завершается в листе.

Рассмотрим три множества:
- множество ключей слева от пути поиска $A$
- множество ключей на пути поиска $B$
- множество ключей справа от пути поиска $C$

Студент считает, что любые три ключа 

$ a in A, b in B, c in C $

должны удовлетворять неравенству

$a <= b <= c$

Приведите наименьший возможный контрпример,
опровергающий предположение студента.

#align(center)[
```text
        10
       /  \
      5    20
     / \
    3   7
         \
          9
```
]

Ищем $k=7$:
- $B = {10, 5, 7}$
- $A = {3}$
- $C = {9, 20}$

$ 3 <= 10 <= 9 "????" $

Лан, лучше добить теорию и на задачках практиковаться

Задача: Реализовать дерево и посчитать его длину.

#align(center)[
  #image("assets/fig2.jpg", width: 50%)
]

Пример: 1

Ввод: 7 3 2 1 9 5 4 6 8 0

Вывод: 4

#pagebreak()
*РЕШЕНИЕ:*

Здесь нужно уметь 2 тривиальные вещи:
+ Вставлять узел в дерево
+ Считать длину дерева

Во вставке ничего сложного, идем по дереву,
если корень nil, то наш узел и есть корень.

Затем просто ищем подходящее место для узла. Но если у нас
дубликат, то мы завершаем цикл вставки этого узла.

В подсчете длины используем рекурсивный подход сравнивая левую и правую
ветви. Но не забываем к полученному результату прибавлять 1, тк
надо еще и родителя учитывать.

#line(length: 100%)

```go
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
```

#pagebreak()

== Вставка и удаление

=== Вставка

```go
func TreeInsert(root *Node, z *Node) *Node {
  var y *Node
  x := root

  for x != nil {
    y = x
    if z.Key < x.Key {
      x = x.Left
    } else {
      x = x.Right
    }
  }

  z.Parent = y
  if y == nil {
    root = z
  } else {
    if z.Key < y.Key {
      y.Left = z
    } else {
      y.Right = z
    }
  }
  return root
}
```

Но мне такая версия алгоритма не по нраву, поэтому
я оставляю свою как основную:

```go
func Insert(root *Node, n *Node) *Node {
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
```

=== Удаление

Процедура рассматривает 3 возможные ситуации:
+ Если у узла нет дочерних узлов, то мы просто изменяем его родительский
  узел, указав вместо него nil

+ Если у узла только один дочерний узел, то мы делаем также
  как в первом случае, но вместо nil указываем указатель на
  дочерний узел удаляемого узла

+ Если у узла 2 дочерних узла, требуется найти ближайший подходящий
  элемент для подмены(ближ превосх или предшеств) и при этом сохранить
  структуру после подмены
```go
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

    // Совершили удаление
    if childOfDeleted != nil {
        childOfDeleted.Parent = nodeToDelete.Parent
    }

    // Теперь надо пролинковать с веткой
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
```
