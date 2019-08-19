//
//  Person.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/12/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import CoreData

@objc(Person)
public class Person: NSManagedObject {
    static let name =  "Person"
    
    convenience init(id: String, title: String, firstName: String, lastName: String, owns: [Book], owes: [Book], context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: Person.name, in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = id
            self.title = title
            self.firstName = firstName
            self.lastName = lastName
            self.owes = owes
            self.owns = owns
        } else {
            fatalError("Could not initialise entity Person!")
        }
    }
    
    convenience init(id: String, title: String, firstName: String, lastName: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: Person.name, in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = id
            self.title = title
            self.firstName = firstName
            self.lastName = lastName
        } else {
            fatalError("Could not initialise entity Person!")
        }
    }
    
}
