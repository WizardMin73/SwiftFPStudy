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
        case let .node(left, value, right):
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
            return nodeF(left.reduce(leaf: leafF, node: nodeF), x, right.reduce(leaf: leafF, node: nodeF))
        }
    }
    
    var elementsR: [Element] {
        return reduce(leaf: [], node: { $0 + [$1] + $2 })
    }
    
    var countR: Int {
        return reduce(leaf: 0, node: { 1 + $0 + $2 })
    }
    
    var isEmpty: Bool {
        if case .leaf = self {
            return true
        }
        return false
    }
}
