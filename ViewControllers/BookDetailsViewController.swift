//
//  BookDetailsViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/13/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit

class BookDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookDescriptionLabel: UITextView!
    var book: BookItem?
    var created : Book?
    var person: Person?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func updateView() -> Void {
        self.bookTitleLabel.text = book!.volumeInfo?.title
        self.bookDescriptionLabel.text = book!.volumeInfo?.description
        self.bookImageView.image = image!
    }
    
    private func createBook() -> Void {
      
            do {
                var authors = "Not available"
                if (self.book?.volumeInfo?.authors != nil) {
                    authors = (self.book?.volumeInfo?.authors![0])!
                }
                var imageUrl = ""
                if (self.book?.volumeInfo?.imageLinks != nil && self.book?.volumeInfo?.imageLinks?.thumbnail != nil) {
                    imageUrl = ((self.book?.volumeInfo?.imageLinks?.thumbnail)!)
                }
                var description = "Not available"
                if (self.book?.volumeInfo?.description != nil) {
                    description = (self.book?.volumeInfo?.description)!
                }
                var title = "Unknown"
                if (self.book!.volumeInfo?.title != nil) {
                    title = (self.book!.volumeInfo?.title)!
                }
                let createdBook = try DataController.getInstance().createBook(id: self.book!.id, title: title, bookDescription: description, imageUrl: imageUrl, ownedBy: person!.id!, author:authors)
                 self.created = createdBook
                print("added book to library")
            } catch {
                fatalError("Could not create book: \(error.localizedDescription)")
            }
        
    }
    @IBAction func cancelClicled(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let myLibraryViewController = segue.destination as! MyLibraryViewController
        myLibraryViewController.myLibraryTableView.reloadData()
    }
    
    @IBAction func addToLibrary(_ sender: Any) {
        if (!self.bookNotInLibrary()) {
           createBook()
        } else {
            print("This book is already in your library.")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func bookNotInLibrary() -> Bool {
        do {
            return try DataController.getInstance().hasBookInLibrary(personId: person!.id!, bookId: book!.id)
        } catch {
            fatalError("Could not verify book in library: \(error.localizedDescription)")
        }
    }
}
