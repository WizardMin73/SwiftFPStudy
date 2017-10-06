//: Playground - noun: a place where people can play
// 基于字典树(Tries)的自动补全
import Foundation

struct Tries<Element: Hashable> {
    let isElement: Bool
    let children: [Element: Tries<Element>]
}

func sum(_ integers: ArraySlice<Int>) -> Int {
    guard let (head, tail) = integers.decomposed else { return 0}
    return head + tail
}

extension Tries {
    init() {
        isElement = false
        children = [:]
    }
    
    var elements: [[Element]]{
        var result: [[Element]] = isElement ? [[]] : []
        for (key, value) in children {
            result += value.elements.map({[key] + $0})
        }
        return result
    }
    
    func inserting(_ key: ArraySlice<Element>) -> Tries<Element> {
        guard let (head, tail) = key.decomposed else { return Tries(isElement: true, children: children) }
        var newChildren = children
        if let nextTrie = children[head] {
            newChildren[head] = nextTrie.inserting(tail)
        } else {
            newChildren[head] = Tries(tail)
        }
        return Tries(isElement: isElement, children: newChildren)
    }
}

extension Array {
    var slice: ArraySlice<Element> {
        return ArraySlice(self)
    }
}

extension ArraySlice {
    var decomposed: (Element, ArraySlice<Element>)? {
        return  isEmpty ? nil : (self[startIndex], self.dropFirst())
    }
}
