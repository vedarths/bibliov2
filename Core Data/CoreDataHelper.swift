//
//  CoreDataHelper.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/12/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension DataController {
    
    func fetchAllBooks(_ predicate: NSPredicate? = nil, entityName: String, sorting: NSSortDescriptor? = nil) throws -> [Book]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let books = try viewContext.fetch(fr) as? [Book] else {
            return nil
        }
        return books
    }
    
    func deleteAllBooks(books: [Book]) throws -> Void {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: Book.name)
        fr.includesPropertyValues = false
        
        for book in books {
            viewContext.delete(book)
        }
        try viewContext.save()
    }
    
    func fetchBooksForPerson(personId: String, sorting: NSSortDescriptor? = nil) throws -> [Book]? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: Book.name)
       // fr.predicate = NSPredicate(format: "owner == %@", personId)
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let books = try viewContext.fetch(fr) as? [Book] else {
            return nil
        }
        var booksForPerson = [Book]()
        for book in books {
            if (book.ownedBy == personId) {
                print("found book with title \(String(describing: book.title)) owned by person id \(personId)")
                booksForPerson.append(book)
            }
        }
        return booksForPerson
    }
    
    func fetchPerson(_ predicate: NSPredicate? = nil, id: String, entityName: String, sorting: NSSortDescriptor? = nil) throws -> Person? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fr.predicate = predicate
        if let sorting = sorting {
            fr.sortDescriptors = [sorting]
        }
        guard let person = (try viewContext.fetch(fr) as! [Person]).first else {
            return nil
        }
        return person
    }
    
    func fetchBook(_ predicate: NSPredicate? = nil, id: String) throws -> Book? {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: Book.name)
        fr.predicate = predicate
       
        guard let book = (try viewContext.fetch(fr) as! [Book]).first else {
            return nil
        }
        return book
    }
    
    func createPerson(email: String, title: String, firstname: String, lastname: String) throws -> Void {
        _ = Person(id: email, title: title, firstName: firstname, lastName: lastname, context: viewContext)
        do {
            try viewContext.save()
        } catch {
            print("Error while saving person: \(error)")
        }
    }
    
    func createBook(id: String, title: String, bookDescription: String, imageUrl: String, ownedBy:String, author: String) throws -> Book {
        let created = Book(id: id, title: title, bookDescription: bookDescription, imageUrl: imageUrl, author: author, ownedBy: ownedBy, context: viewContext)
        do {
            try viewContext.save()
        } catch {
            print("Error while saving Book: \(error)")
        }
        return created
    }
    
}

    
    

