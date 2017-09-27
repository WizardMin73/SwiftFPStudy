//: Playground - noun: a place where people can play

import Cocoa

struct City {
    let name: String
    let population: Int
}

extension City {
    func scalingPopulation() -> City {
        return City(name: self.name, population: self.population * 1000)
    }
}

let paris = City(name: "Paris", population: 2241)
let madrid = City(name: "Madrid", population: 3165)
let amsterdam = City(name: "amsterdam", population: 827)
let berlin = City(name: "Berlin", population: 3562)

let cities = [paris, madrid, amsterdam, berlin]

let results01 = cities
    .filter{$0.population > 1000}
    .map{ $0.scalingPopulation() }
    .reduce("City: Population") { (result, city)  in
        return result + "\n" + "\(city.name): \(city.population)"
}
print(results01)
