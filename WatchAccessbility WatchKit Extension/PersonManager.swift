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

// Implement a custom way to determine if two Person objects are the same
func ==(lhs: Person, rhs: Person) -> Bool {
    return (lhs.name == rhs.name && lhs.age == rhs.age && lhs.weight == rhs.weight)
}

class PersonManager: NSObject {
    
    private static var personManager: PersonManager = PersonManager()
    private var people: [Person]?
    
    // If we don't already have a list of Person objects we will create a new list,
    // otherwise we will return the existing list
    class func getPeople() -> [Person] {
        if let people = personManager.people {
            // return the list that was previously created
            return people
        } else {
            // create a static list of people to work with
            let steve = Person(name: "Steve", age: 35, weight: 184, favorite: true)
            let mike = Person(name: "Mike", age: 27, weight: 203)
            let john = Person(name: "John", age: 43, weight: 248, favorite: true)
            let chris = Person(name: "Chris", age: 18, weight: 161)
            
            return [steve, mike, john, chris]
        }
    }

}
