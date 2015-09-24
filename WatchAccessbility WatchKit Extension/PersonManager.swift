//
//  PersonManager.swift
//  WatchAccessbility
//
//  Created by Steven Beyers on 9/10/15.
//  Copyright © 2015 CapTech. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var age: Int
    var weight: Int
    var favorite = false
    
    init(name: String, age: Int, weight: Int, favorite: Bool = false) {
        self.name = name
        self.age = age
        self.weight = weight
        self.favorite = favorite
    }
}

func ==(lhs: Person, rhs: Person) -> Bool {
    return (lhs.name == rhs.name && lhs.age == rhs.age && lhs.weight == rhs.weight)
}

class PersonManager: NSObject {
    
    private static var personManager: PersonManager = PersonManager()
    private var people: [Person]?
    
    class func getPeople() -> [Person] {
        if let people = personManager.people {
            return people
        } else {
            
            let steve = Person(name: "Steve", age: 35, weight: 184)
            let mike = Person(name: "Mike", age: 27, weight: 203)
            let john = Person(name: "John", age: 43, weight: 248, favorite: true)
            let chris = Person(name: "Chris", age: 18, weight: 161)
            
            return [steve, mike, john, chris]
        }
    }

}
