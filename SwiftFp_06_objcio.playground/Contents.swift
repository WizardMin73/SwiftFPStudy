//: Playground - noun: a place where people can play
// 纯函数式的数据结构

import UIKit

// 目标： 定义一个无需的类似Set的数据结构，包含isEmpty, contains, insert操作

/*
 使用数组定义
 容易实现但是大部分操作的性能是和数组大小线性相关的。无序集合过大会导致性能问题。
*/
struct MySet<Element: Equatable> {
    var storage: [Element] = []
    
    var isEmpty: Bool {
        return storage.isEmpty
    }
    
    func contains(_ element: Element) -> Bool {
        return storage.contains(element)
    }
    
    func inserting(_ x: Element) -> MySet {
        return contains(x) ? self : MySet(storage: storage + [x])
    }
}

/*
 使用二叉搜索树来定义
 */
indirect enum BinarySearchTree<Element: Comparable> {
    case leaf
    case node(BinarySearchTree<Element>, Element, BinarySearchTree<Element>)
}

extension BinarySearchTree {
    init() {
        self = .leaf
    }
    
    init(_ value: Element) {
        self = .node(.leaf, value, .leaf)
    }
    
    // 递归计算子节点数目
    var count: Int {
        switch self {
        case .leaf:
            return 0
        case let .node(left, _, right):
            return 1 + left.count + right.count
        }
    }
    
    // 递归计算所有值的集合
    var elements: [Element] {
        switch self {
        case .leaf:
            return []
        case let .node(left, x, right):
            return left.elements + [x] + right.elements
        }
    }
    
    // 展开
    func reduce<A>(leaf leafF: A, node nodeF: (A, Element, A) -> A) -> A {
        switch self {
        case .leaf:
            return leafF
        case let .node(left, x, right):
            return nodeF(left.reduce(leaf: leafF, node: nodeF),
                         x,
                         right.reduce(leaf: leafF, node: nodeF))
        }
    }
    
    // 通过reduce函数重写elements
    var elementsR: [Element] {
        return reduce(leaf: [], node: { $0 + [$1] + $2 })
    }
    
    // 通过reduce函数重写count
    var countR: Int {
        return reduce(leaf: 0, node: { 1 + $0 + $2 })
    }
    
    // 实现目标1: 判断该数据结构是否为空
    var isEmpty: Bool {
        if case .leaf = self {
            return true
        }
        return false
    }
    
    // 实现目标2: 判断是否是合格的二叉搜索树
    // 所有储存在左子树的值都小于其根节点的值
    // 所有储存在右子树的值都大于其根节点的值
    // 左右子树都是二叉搜索树
    var isBST: Bool {
        switch self {
        case .leaf:
            return true
        case let .node(left, x, right):
            return left.elements.all{ y in y < x }
                && right.elements.all{ y in y > x }
                && left.isBST
                && right.isBST
        }
    }
    
    //目标3:　判断一个元素是否在数据结构内
    func contains(_ x: Element) -> Bool {
        switch self {
        case .leaf:
            return false
        case let .node(_, y, _) where x == y://是二叉树，并且正好等于值
            return true
        case let .node(left, y, _) where x < y://小于该节点值，则去左子树
            return left.contains(x)
        case let .node(_, y, right) where x > y:// 大于该节点值，则去右子树
            return right.contains(x)
        default:
            fatalError()
        }
    }
    
    //目标4: 插入数据
    mutating func insert(_ x: Element) {
        switch self {
        case .leaf:
            self = BinarySearchTree(x)
        case .node(var left, let y, var right):
            if x < y { left.insert(x) }
            if x > y { right.insert(x) }
            self = BinarySearchTree.node(left, y, right)
        }
    }
}

extension Sequence {
    func all(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        for x in self where !predicate(x) {
            return false
        }
        return true
    }
}

// TEST DATA
let leaf: BinarySearchTree<Int> = .leaf
let five: BinarySearchTree<Int> = .node(leaf, 5, leaf)
print(five.isBST)
var fiveCopy = five
fiveCopy.insert(6)

