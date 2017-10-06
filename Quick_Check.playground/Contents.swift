//: Playground - noun: a place where people can play

import UIKit
import Foundation

// 目标：
// 1. 需要一个生成随机数的方法
// 2. 需要一个check函数，将随机数作为特性函数
// 3. 如果有一个测试失败了，希望测试的输入值尽可能小
// 4. 需要确保检验函数适用于带有泛型的类型

/**
 * 目标1
 */
protocol Arbitary {
    static func arbitary() -> Self
}

extension Int: Arbitary {
    static func arbitary() -> Int {
        return Int(arc4random())
    }
}

extension Int {
    static func arbitary(in range: CountableRange<Int>) -> Int {
        let diff = range.upperBound - range.lowerBound
        return range.lowerBound + (Int.arbitary() % diff)
    }
}

extension UnicodeScalar: Arbitary {
    static func arbitary() -> UnicodeScalar {
        return UnicodeScalar(Int.arbitary(in: 65..<90))!
    }
}

extension String: Arbitary {
    static func arbitary() -> String {
        let randomLength = Int.arbitary(in: 0..<40)
        let randomScalar = (0..<randomLength).map { _ in
            UnicodeScalar.arbitary()
        }
        return String(UnicodeScalarView(randomScalar))
    }
}

/**
 * 目标2
 */
func check1<A: Arbitary>(_ message: String, _ property: (A) -> Bool) -> () {
    let numberOfInterations = 10
    for _ in 0..<numberOfInterations {
        let value = A.arbitary()
        guard property(value) else {
            print("\"\(message)\"doesn't hold: \(value)")
            return
        }
    }
    print("\"\(message)\"passed\(numberOfInterations)tests")
}

extension CGSize {
    var area:CGFloat {
        return width * height
    }
}

extension CGSize: Arbitary {
    static func arbitary() -> CGSize {
        return CGSize(width: .arbitary(), height: .arbitary())
    }
}
check1("area should be least 0", {(size: CGSize) in size.area >= 0 })
