//: Playground - noun: a place where people can play
//: 迭代器和序列

import UIKit
import Foundation

struct ReversedIndexInterator: IteratorProtocol {
    var index: Int
    
    init<T>(array: [T]) {
        index = array.endIndex - 1
    }
    
    mutating func next() -> Int? {
        guard index >= 0 else {
            return nil
        }
        defer {
            index -= 1
        }
        return index
    }
}

struct PowerInterator: IteratorProtocol {
    var power: NSDecimalNumber = 1
    
    mutating func next() -> NSDecimalNumber? {
        power = power.multiplying(by: 2)
        return power
    }
}

extension PowerInterator {
    mutating func find(where predicate: (NSDecimalNumber) -> Bool) -> NSDecimalNumber? {
        while let x = next() {
            if predicate(x) {
                return x
            }
        }
        return nil
    }
}

// 测试乘二迭代器的使用
//let testNumbers: [NSDecimalNumber] = [1, 2, 3, 4, 5]
//for x in testNumbers {
//    var iterator = PowerInterator(power: x)
//    if let i = iterator.next() {
//        print(i)
//    }
//}

// 测试find函数
//var powerInterator = PowerInterator()
//if let last = powerInterator.find(where: {$0.intValue > 1000}) {
//    print(last)
//}

struct FileLineInterator: IteratorProtocol {
    let lines: [String]
    var currentLine: Int = 0
    
    init(fileName: String) throws {
        let contents: String = try String(contentsOfFile: fileName)
        lines = contents.components(separatedBy: .newlines)
    }
    
    mutating func next() -> String? {
        guard currentLine < lines.endIndex else { return nil }
        defer {
            currentLine += 1
        }
        return lines[currentLine]
    }
}
