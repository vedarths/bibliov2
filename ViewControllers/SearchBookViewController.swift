//
//  ViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/11/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SearchBookViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var totalTitles: Int? = nil
    var books: [Book] = []
    var dataController:DataController!
    var fetchResultsController:NSFetchedResultsController<Book>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Book> = Book.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "books")
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        if let books = getAllBooks() {
            self.books = books
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setupFetchedResultsController()
    }
    
    private func getAllBooks() -> [Book]? {
        var books: [Book]?
        do {
            try books = DataController.getInstance().fetchAllBooks(entityName: "Book")
        } catch {
            print("\(#function) error:\(error)")
            showInfo(withTitle: "Error", withMessage: "Error while fetching books: \(error)")
        }
        return books
    }
    
    private func clearSearchResults() -> Void {
        let books = getAllBooks()!
        do {
            try DataController.getInstance().deleteAllBooks(books: books)
        } catch {
            print("\(#function) error:\(error)")
            showInfo(withTitle: "Error", withMessage: "Error while deleting books: \(error)")
        }

    }
    
    @IBAction func doSearch(_ sender: Any) {
        let title = self.titleTextField.text!
        //clear previous search results
        //clearSearchResults()
        BookClient.sharedInstance().findBy(title: title) { (bookVolumeParsed, error) in
            performUIUpdatesOnMain {
                if let bookVolumeParsed = bookVolumeParsed {
                    self.totalTitles = bookVolumeParsed.totalItems
                    print("total items fetched \(String(describing: self.totalTitles))")
                    self.storeBooks(bookVolumeParsed.items!)
                    self.showSearchResultsViewController()
                } else {
                    self.showError(message: error as! String)
                }
            }
        }
    }
    
    private func showSearchResultsViewController() {
        let searchResultsVc = storyboard!.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        searchResultsVc.dataController = dataController
        searchResultsVc.books = getAllBooks()
        searchResultsVc.searchTitle = self.titleTextField.text
        present(searchResultsVc, animated: true, completion: nil)
    }
    
    private func storeBooks(_ books: [BookItem]) {
        func showErrorMessage(msg: String) {
            showInfo(withTitle: "Error", withMessage: msg)
        }
        for book in books {
            DispatchQueue.main.async {
                if let url = book.volumeInfo!.imageLinks?.thumbnail {
                   
                    let description = book.volumeInfo?.description
                    
                    if description != nil {
                        _ = Book(id: book.id, title: (book.volumeInfo?.title!)!,
                                 bookDescription: (book.volumeInfo?.description!)!,
                                 imageUrl: url, author: book.volumeInfo!.authors![0], context: DataController.getInstance().viewContext)
                    } else {
                        _ = Book(id: book.id, title: (book.volumeInfo?.title!)!,
                             bookDescription: "",
                             imageUrl: url, author: book.volumeInfo!.authors![0], context: DataController.getInstance().viewContext)
                    }
                    DataController.getInstance().autoSaveViewContext()
                }
            }
        }
    }
 
}

