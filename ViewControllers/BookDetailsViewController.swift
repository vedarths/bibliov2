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
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    @IBOutlet weak var addToLibraryButton: UIButton!

    
    var book: BookItem?
    var created : Book?
    var person: Person?
    var dataController: DataController?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
    }
    
    private func updateView() -> Void {
        self.bookTitleLabel.text = book!.volumeInfo?.title
        self.bookDescriptionLabel.text = book!.volumeInfo?.description
        self.bookImageView.image = image!
    }
    
    private func createBook() -> Void {
        performUIUpdatesOnMain {
            do {
                let book = try self.dataController!.createBook(id: self.book!.id, title: (self.book!.volumeInfo?.title)!, bookDescription: (self.book?.volumeInfo?.description)!, imageUrl: (self.book?.volumeInfo?.imageLinks?.thumbnail)!, author: (self.book?.volumeInfo?.authors![0])!)
                 self.created = book
            } catch {
                fatalError("Could not create book: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func doCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateOwner() -> Void {
        performUIUpdatesOnMain {
            do {
                try self.dataController!.setOwner(book: self.created!, ownedBy: self.person!.id!, imageUrl: self.created!.imageUrl!)
            } catch {
                fatalError("Could not assign owner to the book: \(error.localizedDescription)")
            }
        }
       
    }
    @IBAction func addToLibraryTapped(_ sender: Any) {
        createBook()
        updateOwner()
        // from here I want to get back to the main controller!!! HOW TO DO THIS??
        // Refresh map and table
        let navigationController = self.presentingViewController?.presentingViewController?.presentingViewController as! UINavigationController
        let mainController = navigationController.viewControllers.first as! MainController
        //todo - sudi - what am I doing wrong here?!!!
        mainController.doRefresh(nil)
        mainController.person = person
        mainController.dataController = dataController
        present(mainController, animated: true, completion: nil)
        //self.dismiss(animated: true, completion: nil)
    }

}
