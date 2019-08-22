//
//  MyLibraryViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/11/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MyLibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func doRefresh() {
        getAllBooks()
        tableView.reloadData()
    }
    @IBOutlet var tableView: UITableView!
    
    var person : Person?
    var books : [Book]?
    var presentingAlert = false
    var fetchedResultsController: NSFetchedResultsController<Book>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Book> = Book.fetchRequest()
        //let predicate = NSPredicate(format: "owner == %@", person!.id!)
        //fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.getInstance().viewContext, sectionNameKeyPath: nil, cacheName: "books")
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        tableView.dataSource = self
        tableView.delegate = self
        doRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
    }
    
    private func getAllBooks() -> Void {
        var books : [Book]?
        do {
            books = try DataController.getInstance().fetchBooksForPerson(personId:person!.id!)
        } catch {
            showError(message: "could not fetch books for person")
        }
        self.books = books
    }
    
    private func getImage(imageUrl: String) -> UIImage {
        var downloadedImage: UIImage? = nil
        BookClient.sharedInstance().getImage(imageUrl: imageUrl) { (data, error) in
            if let _ = error {
                DispatchQueue.main.async {
                    self.errorForImageUrl(imageUrl)
                }
                return
            } else if let data = data {
                DispatchQueue.main.async {
                    downloadedImage = UIImage(data: data)
                    DispatchQueue.global(qos: .background).async {
                        DataController.getInstance().autoSaveViewContext()
                    }
                    
                }
            }
        }
        return downloadedImage!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (fetchedResultsController.sections!.count > 0) {
           return fetchedResultsController.sections?.count ?? 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[0].numberOfObjects ?? 0
    }
    
    func errorForImageUrl(_ imageUrl: String) {
        if !self.presentingAlert {
            self.showInfo(withTitle: "Error", withMessage: "Error while fetching image for URL: \(imageUrl)", action: {
                self.presentingAlert = false
            })
        }
        self.presentingAlert = true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aBook = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.defaultReuseIdentifier, for: indexPath) as! BookTableViewCell
        // Configure cell
        cell.titleLabel.text = aBook.title
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let app = UIApplication.shared
//        let book = books![(indexPath as NSIndexPath).row]
//        if let mediaUrlValue = book.imageUrl as String?,  mediaUrlValue.isEmpty == false {
//            if (self.verifyUrl(urlString: mediaUrlValue)) {
//                app.openURL(URL(string: book.imageUrl!)!)
//            }
//        }
//    }
    
    @IBAction func unwindToMyLibraryViewController(_ sender: UIStoryboardSegue) {
        
    }
}
