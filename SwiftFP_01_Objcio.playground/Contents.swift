//: Playground - noun: a place where people can play

import Cocoa

typealias Distance = Double
typealias Region = (Position) -> Bool

struct Position {
    var x: Distance
    var y: Distance
}

extension Position {
    //是否在范围内
    func within(range: Distance) -> Bool {
        return sqrt(x * x + y * y) <= range
    }
    
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x , y: y - p.y)
    }
    
    // sqart计算对角线距离
    var length: Double {
        return sqrt(x * x + y * y)
    }
}

struct Ship {
    var position: Position // 位置
    var firingRange: Distance // 开火距离
    var unsafeRange: Distance // 安全距离
}

extension Ship {
    func canEngage(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
    }
    
    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
        let targetDistance = target.position.minus(position).length
        let friendlyDistance = friendly.position.minus(target.position).length
        return (targetDistance <= firingRange) && (targetDistance > unsafeRange) && (friendlyDistance > unsafeRange)
    }
}

func circle(radius: Distance) -> Region {
    return { point in point.length <= radius }
}

func circle2(radius: Distance, center: Position) -> Region {
    return { point in point.minus(center).length <= radius }
}

func shift(_ region: @escaping Region, by offset: Position) -> Region {
    return { point in region(point.minus(offset)) }
}

func invert(_ region: @escaping Region) -> Region {
    return { point in !region(point)}
}
