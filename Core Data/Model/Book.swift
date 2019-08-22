//
//  Book.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/12/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import CoreData
import UIKit

@objc(Book)
public class Book: NSManagedObject {
    static let name = "Book"
    
    convenience init(id: String, title: String, bookDescription: String, imageUrl: String, author: String, ownedBy: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: Book.name, in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = id
            self.title = title
            self.bookDescription = bookDescription
            self.author = author
            self.image = nil
            self.imageUrl = imageUrl
            self.ownedBy = ownedBy
        } else {
            fatalError("Could not initialise entity Book!")
        }
    }
    
}
