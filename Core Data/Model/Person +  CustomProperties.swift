//
//  Photo +  CustomProperties.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/12/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import CoreData

extension Person {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
    }
    
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var image: NSData?
    @NSManaged public var owns: [Book]?
    @NSManaged public var owes: [Book]?
}
