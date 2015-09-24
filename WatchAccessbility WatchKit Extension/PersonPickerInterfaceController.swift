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
    
    var delegate: PersonPickerDelegate?
    
    @IBOutlet var table: WKInterfaceTable!
    private var people: [Person]?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let contextArray = context as? Dictionary<NSObject, AnyObject> {
            if let favorites = contextArray["Favorites"] as? [Person] {
                people = favorites
            }
            
            if let delegateFromContext = contextArray["Delegate"] as? PersonPickerDelegate {
                delegate = delegateFromContext
            }
        }
        
        if (people == nil) {
            people = PersonManager.getPeople()
        }
        
        guard var people = people else { return }
        
        table.setNumberOfRows(people.count, withRowType: "personTableItem")
        
        for index in 0...people.count-1 {
            if let personItem = table.rowControllerAtIndex(index) as? PersonPickerRow {
                personItem.person = people[index]
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        if let people = self.people where people.count > 0 {
            let person = people[rowIndex]
            delegate?.didSelectPerson(person)
            
            dismissController()
            popController()
        }
    }

}

class PersonPickerRow: NSObject {
    var person: Person? {
        didSet {
            nameLabel.setText(person?.name)
        }
    }
    
    @IBOutlet var nameLabel: WKInterfaceLabel!
}