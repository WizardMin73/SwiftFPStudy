//: Playground - noun: a place where people can play

import Cocoa

struct Film {
    let name: String
    let date: String
    let actors: [String]
}

let haloFilm = Film(name: "Halo", date: "1999-10-23", actors: ["John", "343", "Catana"])
let haloCopy = haloFilm
