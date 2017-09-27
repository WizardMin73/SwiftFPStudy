//: Playground - noun: a place where people can play
//: 值类型和引用类型
import Cocoa

struct PointStruct {
    var x: Int
    var y: Int
}

struct PointStaticStruct {
    let x: Int
    let y: Int
}

class PointClass {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}
//MARK: - 测试修改初始化后的两种类型的区别
var structPoint = PointStruct(x: 1, y: 2)
var sameCopyPoint = structPoint
sameCopyPoint.x = 3

let sameCopyPointLet = structPoint
sameCopyPoint.x = 4

var structStaticPoint = PointStaticStruct(x: 1, y: 2)
var sameStaticPoint = structStaticPoint
//sameStaticPoint.x = 5 //无法运行

//MARK: - 测试传入函数后值类型和引用类型的变化。
func setPointOrigin(pointStruct: PointStruct) -> PointStruct {
    var point = pointStruct
//    pointStruct.x = 0 //在函数内部无法直接修改外部结构体？
//    pointStruct.y = 0
//    return pointStruct
    point.x = 0
    point.y = 0
    return point
}

let originPointStruct = setPointOrigin(pointStruct: structPoint)
print("源结构体：", structPoint)

func setPointClassOrigin(pointClass: PointClass) -> PointClass {
    var point = pointClass //无论函数内部有没有变量承接，引用类型数据的变化都会体现在源数据上。
    point.x = 0
    point.y = 0
    return point
}

let pointClass = PointClass(x: 1, y: 2)
let originPointClass = setPointClassOrigin(pointClass: pointClass)
print("当前class坐标：", originPointClass.x, originPointClass.y)
print("源class坐标:", pointClass.x, pointClass.y)

// 为结构体添加可变方法
extension PointStruct {
    mutating func setOriginPoint() {
        x = 0
        y = 0
    }
}

let originPointStruct2 = structPoint.setOriginPoint() //无返回值的函数。。。
print("内部方法修改strcut:", originPointStruct2, structPoint)//源数据被修改
