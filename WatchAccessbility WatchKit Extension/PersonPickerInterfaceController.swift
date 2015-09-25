//
//  PersonPickerInterfaceController.swift
//  WatchAccessbility
//
//  Created by Steven Beyers on 9/15/15.
//  Copyright © 2015 CapTech. All rights reserved.
//

import WatchKit
import Foundation

protocol PersonPickerDelegate {
    func didSelectPerson(person: Person)
}

class PersonPickerInterfaceController: WKInterfaceController {
    // The delegate that needs to be informed when we select a new person
    var delegate: PersonPickerDelegate?
    
    @IBOutlet var table: WKInterfaceTable!
    // The list of people to choose from
    private var people: [Person]?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // If there was context passed in we need to handle it. We only know how to handle Dictionaries
        if let contextArray = context as? Dictionary<NSObject, AnyObject> {
            // If a list of favorites were passed in then we will use that list as the options
            if let favorites = contextArray["Favorites"] as? [Person] {
                people = favorites
            }
            
            // If a delegate was passed in then we will set that object as the delegate
            if let delegateFromContext = contextArray["Delegate"] as? PersonPickerDelegate {
                delegate = delegateFromContext
            }
        }
        
        // If the list is nil then that means we were not given a list of favorites and we can fetch the full list to display
        if (people == nil) {
            people = PersonManager.getPeople()
        }
        
        // Make sure we have a list before continuing
        guard var people = people else { return }
        
        // tell the table how many objects will be displayed
        table.setNumberOfRows(people.count, withRowType: "personTableItem")
        
        // For each row assign a reference to the person object
        for index in 0...people.count-1 {
            if let personItem = table.rowControllerAtIndex(index) as? PersonPickerRow {
                personItem.person = people[index]
            }
        }
    }

    // Handle item selection
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        // Make sure there is at least 1 person in our list
        if let people = self.people where people.count > 0 {
            // get the person that was selected
            let person = people[rowIndex]
            // tell the delegate that a new person was selected
            delegate?.didSelectPerson(person)
            
            // Dismiss the modal - This is needed if the user selected the "New Person" button on the first screen
            dismissController()
            // Go back to the previous page - This is needed if the user selected "Favorites" from the context menu on the previous page
            popController()
        }
    }

}

// The row to display each person
class PersonPickerRow: NSObject {
    var person: Person? {
        didSet {
            nameLabel.setText(person?.name)
        }
    }
    
    @IBOutlet var nameLabel: WKInterfaceLabel!
}