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
        // When we set a new person object we want to set a flag to determine if
        // the UI needs to be updated. This is done because watchOS isn't happy when
        // we update a UI element to the value that it already has.
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
    // flag to indicate if the UI needs to be updated (which will only happen if the person is changed)
    var needsUpdate: Bool = true
    
    override init() {
        super.init()
        
        // get a list of people
        let people = PersonManager.getPeople()
        // Make sure the list has at least 1 element. If it does, the first element is the selected person
        if (people.count > 0) {
            currentPerson = people[0]
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("resizeGroupsIfNeeded"), name: WKAccessibilityVoiceOverStatusChanged, object: nil)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        resizeGroupsIfNeeded()
     
        // We should call update UI when this interface controller activates so that we know the suer is looking at the correct data
        updateUI()
        
        let imageRegion = WKAccessibilityImageRegion()
        imageRegion.frame = CGRectMake(0, 0, 30, 30)
        imageRegion.label = "Favorite Person"
        favoriteIcon.setAccessibilityImageRegions([imageRegion])
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
        
        // Get the full list
        let people = PersonManager.getPeople()
        var newPerson: Person
        var randomInt: Int
        
        repeat {
            // generate a random number between 0 and the number of people returned in the list
            randomInt = Int(arc4random_uniform(UInt32(people.count)))
            // get the person at that number
            newPerson = people[randomInt]
            
            // if the current person is the new person loop again, otherwise we have a random person and can continue
        } while (currentPerson != nil && newPerson == currentPerson!)
        
        // set the current person as the new person
        currentPerson = newPerson
        // update the UI with the details of the new person
        updateUI()
    }
    
    // Show the list of favorites to choose from
    @IBAction func viewFavorites() {
        // filter all people for just those who are marked as a favorite
        let favorites = PersonManager.getPeople().filter { (person: Person) -> Bool in
            return person.favorite
        }
        
        // set the context that the person list screen will use to show the proper data
        var context = Dictionary<NSObject, AnyObject>()
        context["Favorites"] = favorites
        context["Delegate"] = self
        
        // show the favorites screen
        pushControllerWithName("FavoritesController", context: context)
    }
    
    func updateUI() {
        // If there is currently a person to show and the needsUpdate flag has been set to true then we will set all of the labels to the new data
        if let person = currentPerson where needsUpdate {
            nameLabel.setText(person.name)
            ageLabel.setText("\(person.age) yrs")
            ageLabel.setAccessibilityLabel("\(person.age) years old")
            weightLabel.setText("\(person.weight) lbs")
            favoriteIcon.setHidden(!person.favorite)
        }
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        // The only time this gets called is when we press the "New Person" button. We will set this class as the delegate to handle item selection.
        return ["Delegate" : self]
    }
}

extension InterfaceController: PersonPickerDelegate {
    
    // Handles the user selecting a new person
    func didSelectPerson(person: Person) {
        // store the person that we should now be showing on screen
        currentPerson = person
    }
    
}
