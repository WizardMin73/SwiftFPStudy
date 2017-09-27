//: Playground - noun: a place where people can play

import UIKit
import Foundation

enum RideCategory: String {
    case family
    case kids
    case thrill
    case scary
    case relaxing
    case water
}

typealias Minutes = Double

struct Ride {
    let name: String
    let categories: Set<RideCategory>
    let waitTime: Minutes
}

let parkRides = [
    Ride(name: "Raging Rapids", categories: [.family, .thrill, .water], waitTime: 45.0),
    Ride(name: "Crazy Funhouse", categories: [.family], waitTime: 10.0),
    Ride(name: "Spinning Tea Cups", categories: [.kids], waitTime: 15.0),
    Ride(name: "Spooky Hollow", categories: [.scary], waitTime: 30.0),
    Ride(name: "Thunder Coaster", categories: [.family, .thrill], waitTime: 60.0),
    Ride(name: "Grand Carousel", categories: [.family, .kids], waitTime: 15.0),
    Ride(name: "Bumper Boats", categories: [.family, .water], waitTime: 25.0),
    Ride(name: "Mountain Railroad", categories: [.family, .relaxing], waitTime: 0.0)
]

//MARK: - sorted method
func sortedNames(of rides: [Ride]) -> [String] {
    var sortedRides = rides
    var key: Ride
    
    for i in (0..<sortedRides.count) {
        key = sortedRides[i]
        
        for j in stride(from: i, to: -1, by: -1) {
            if key.name.localizedCompare(sortedRides[j].name) == .orderedAscending {
                sortedRides.remove(at: j + 1)
                sortedRides.insert(key, at: j)
            }
        }
    }
    
    var sortedNames = [String]()
    for ride in sortedRides {
        sortedNames.append(ride.name)
    }
    return sortedNames
}

func wizardSortedNames(of rides: [Ride]) -> [String] {
    let names = rides.map({return $0.name})
    let sorted = names.sorted(by: >)
    return sorted
}

print(wizardSortedNames(of: parkRides))

//MARK: - time
func waitTimeIsShort(ride: Ride) -> Bool {
    return ride.waitTime < 15.0
}

var shortWaitTimeRides = parkRides.filter(waitTimeIsShort)
print(shortWaitTimeRides.count)

let totalWaitTime = parkRides.reduce(0.0) { (total, ride) in
    return total + ride.waitTime
}
print("totalWaitTime == \(totalWaitTime)")


//MARK: - Partial Functions
func filter(for category: RideCategory) -> ([Ride]) -> ([Ride]) {
    return { (rides: [Ride]) in
        rides.filter({ $0.categories.contains(category)})
    }
}

let kidRideFilter = filter(for: .kids)
print(kidRideFilter(parkRides))

//MARK: - Pure Functions
func ridesWithWaitTimeUnder(_ waitTime: Minutes, from rides: [Ride]) -> [Ride] {
    return rides.filter({ $0.waitTime < waitTime})
}

//var shortWaitRides = ridesWithWaitTimeUnder(15, from: parkRides)
let sortedArray = parkRides.quickSorted()
print(sortedArray.count)


//MARK: - Imperative vs Declarative

//Imperative
//var rideOfInterest = [Ride]()
//for ride in parkRides where ride.waitTime < 20 {
//    for category in ride.categories where category == .family {
//        rideOfInterest.append(ride)
//        break
//    }
//}

//Declarative
var sortedRideOfInterest = parkRides.filter({$0.categories.contains(.family) && $0.waitTime < 20}).sorted(by: <)

//var sortedRideOfInterest = rideOfInterest.quickSorted()
print(sortedRideOfInterest)

//MARK: - Extension
extension RideCategory: CustomStringConvertible {
    var description: String {
        return rawValue
    }
}

extension Ride: CustomStringConvertible {
    var description: String {
        return "⚡️Ride(name: \"\(name)\", waitTime: \(waitTime), categories: \(categories)) \n"
    }
}

extension Ride: Comparable {
    static func <(lhs: Ride, rhs: Ride) -> Bool {
        return lhs.waitTime < rhs.waitTime
    }
    
    static func ==(lhs: Ride, rhs: Ride) -> Bool {
        return lhs.name == rhs.name
    }
}
//extension Array where Element: Comparable {
//    func quickSorted() -> [Element] {
//        if self.count > 1 {
//            let (pivot, remaining) = (self[0], dropFirst())
//            let lhs = remaining.filter { $0 <= pivot }
//            let rhs = remaining.filter { $0 > pivot }
//            return lhs.quickSorted() as [Element] + [pivot] + rhs.quickSorted()
//        }
//        return self
//    }
//}

extension Array where Element: Comparable {
    func quickSorted() -> [Element] {
        if self.count > 1 {
            let (pivot, remaining) = (self[0], dropFirst())
            let lhs = remaining.filter({$0 <= pivot})
            let rhs = remaining.filter({$0 > pivot})
            return lhs.quickSorted() as [Element] + [pivot] + rhs.quickSorted()
        }
        return self
    }
}

