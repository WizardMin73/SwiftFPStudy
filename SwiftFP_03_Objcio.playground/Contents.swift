//: Playground - noun: a place where people can play

import Cocoa

// 测试数据
let testNum1 = [1, 2, 3, 4, 5, 6]
let testString1 = ["1", "2", "3", "4", "5", "6"]

// 将普通数字运算函数，封装成一个通用的函数
func compute(array: [Int],  transform: (Int) -> Int) -> [Int] {
    var results: [Int] = []
    for num in array {
        results.append(transform(num))
    }
    return results
}

let testNum2 = compute(array: testNum1, transform: { $0 + 1 })
print(testNum2)

// 使用范型创造一个更加通用的变换函数
func genericCompute<T>(array: [Int], transform: (Int) -> T) -> [T] {
    var results: [T] = []
    for num in array {
        results.append(transform(num))
    }
    return results
}

let testNum3: [Bool] = genericCompute(array: testNum1, transform: { $0 > 3 })
print(testNum3)

// 进一步使用范型封装该变换函数
func map<Element, T>(array: [Element], transform: (Element) -> T) -> [T] {
    var results: [T] = []
    for element in array {
        results.append(transform(element))
    }
    return results
}

let testNum4 = map(array: testString1, transform: { Int($0) })
print(testNum4)

// filter函数
func filter<Element>(_ array: [Element], condition: (Element) -> Bool) -> [Element] {
    var results: [Element] = []
    for x in array where condition(x) {
        results.append(x)
    }
    return results
}

let testNum5 = filter(testNum1, condition: {$0 > 3})
print(testNum5)

// reduce函数
extension Array {
    func myReduce<T>(_ initial: T, combine: (T, Element) -> T) -> T {
        var result = initial
        for x in self {
            result = combine(result, x)
        }
        return result
    }
}

let reduceArray01 = testNum1.myReduce(0, combine: +)
print(reduceArray01)
let reduceArray02 = testNum1.myReduce("reduce results: ") { (result, num) -> String in
    return result + String(num) + "\n"
}
print(reduceArray02)

func sumUseReduce(intergers: [Int]) -> Int {
    return intergers.myReduce(0, combine: +)
}
print(sumUseReduce(intergers: testNum2))

func flatten<T>(_ xss: [[T]]) -> [T] {
    var result: [T] = []
    for x in xss {
        result += x
    }
    return result
}
