//: Playground - noun: a place where people can play
// 枚举

import UIKit

enum Encoding {
    case ascii //枚举值
    case nextstep
    case japaneseEUC
    case utf8
}

extension Encoding {
    var nsStringEncoding: String.Encoding {
        switch self {
        case .ascii:
            return String.Encoding.ascii
        case .nextstep:
            return String.Encoding.nextstep
        case .japaneseEUC:
            return String.Encoding.japaneseEUC
        case .utf8:
            return String.Encoding.utf8
        }
    }
    
    init?(encoding: String.Encoding) {
        switch encoding {
        case String.Encoding.ascii:
            self = .ascii
        default:
            return nil
        }
    }
    
    var localizedName: String {
        return String.localizedName(of: nsStringEncoding)
    }
}

enum Result<T> {
    case success(T)
    case error(Error)
}

func ??<T>(result: Result<T>, handleError: (Error) -> T) -> T {
    switch result {
    case let .success(value):
        return value
    case let .error(error):
        return handleError(error)
    }
}

