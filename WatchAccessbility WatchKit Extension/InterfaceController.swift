//
//  InterfaceController.swift
//  WatchAccessbility WatchKit Extension
//
//  Created by Steven Beyers on 9/9/15.
//  Copyright © 2015 CapTech. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var nameGroup: WKInterfaceGroup!
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet var ageGroup: WKInterfaceGroup!
    @IBOutlet weak var ageLabel: WKInterfaceLabel!
    @IBOutlet var weightGroup: WKInterfaceGroup!
    @IBOutlet weak var weightLabel: WKInterfaceLabel!
    @IBOutlet var favoriteIcon: WKInterfaceImage!
    
    var currentPerson: Person? {
        
        didSet {
            if let newValue = currentPerson {
                if let old = oldValue where newValue == old {
                    needsUpdate = false
                } else {
                    needsUpdate = true
                }
            } else {
                needsUpdate = false
            }
        }
        
    }
    var needsUpdate: Bool = true
    
    override init() {
        super.init()
        
        let people = PersonManager.getPeople()
        if (people.count > 0) {
            currentPerson = people[0]
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("resizeGroupsIfNeeded"), name: WKAccessibilityVoiceOverStatusChanged, object: nil)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        resizeGroupsIfNeeded()
        updateUI()
        
        let imageRegion = WKAccessibilityImageRegion()
        imageRegion.frame = CGRectMake(0, 0, 30, 30)
        imageRegion.label = "Favorite Person"
        favoriteIcon.setAccessibilityImageRegions([imageRegion])
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func resizeGroupsIfNeeded() {
        let size: CGFloat
        if (WKAccessibilityIsVoiceOverRunning()) {
            size = 30
        } else {
            size = 20
        }
        
        nameGroup.setHeight(size)
        ageGroup.setHeight(size)
        weightGroup.setHeight(size)
    }
    
    @IBAction func showRandomPerson() {
        updateUI()
        let people = PersonManager.getPeople()
        var newPerson: Person
        var randomInt: Int
        
        repeat {
            randomInt = Int(arc4random_uniform(UInt32(people.count)))
            newPerson = people[randomInt]
            
        } while (currentPerson != nil && newPerson == currentPerson!)
        
        currentPerson = newPerson
        updateUI()
    }
    
    @IBAction func viewFavorites() {
        let favorites = PersonManager.getPeople().filter { (person: Person) -> Bool in
            return person.favorite
        }
        
        var context = Dictionary<NSObject, AnyObject>()
        context["Favorites"] = favorites
        context["Delegate"] = self
        
        pushControllerWithName("FavoritesController", context: context)
    }
    
    func updateUI() {
        if let person = currentPerson where needsUpdate {
            nameLabel.setText(person.name)
            ageLabel.setText("\(person.age) yrs")
            ageLabel.setAccessibilityLabel("\(person.age) years old")
            weightLabel.setText("\(person.weight) lbs")
            favoriteIcon.setHidden(!person.favorite)
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        return ["Delegate" : self]
    }
}

extension InterfaceController: PersonPickerDelegate {
    
    func didSelectPerson(person: Person) {
        currentPerson = person
    }
    
}
