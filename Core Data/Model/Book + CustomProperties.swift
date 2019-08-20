//
//  Book + CustomProperties.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/12/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Book {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
    }
    
    @NSManaged public var id: String?
    @NSManaged public var bookDescription: String?
    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var image: UIImage?
    @NSManaged public var ownedBy: String?
    
}
