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

class MyLibraryViewController: UITableViewController {
    
    func doRefresh() {
        getAllBooks()
        tableView.reloadData()
    }
    
    var dataController: DataController?
    var person : Person?
    var books : [Book]?
    var presentingAlert = false
    var fetchedResultsViewController: NSFetchedResultsController<Book>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Book> = Book.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsViewController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController!.viewContext, sectionNameKeyPath: nil, cacheName: "books")
        do {
            try fetchedResultsViewController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        doRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        doRefresh()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsViewController = nil
    }
    
    private func getAllBooks() -> Void {
        var books : [Book]?
        let predicate = NSPredicate(format: "owner == %@", person!.id!)
        do {
            books = try dataController!.fetchBooksForPerson(person:person!, predicate)
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
    
    func errorForImageUrl(_ imageUrl: String) {
        if !self.presentingAlert {
            self.showInfo(withTitle: "Error", withMessage: "Error while fetching image for URL: \(imageUrl)", action: {
                self.presentingAlert = false
            })
        }
        self.presentingAlert = true
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (books != nil) {
         return books!.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTabCell")!
        let book = self.books![(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = "\(String(describing: book.title))"
        cell.imageView?.image = getImage(imageUrl: book.imageUrl!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let app = UIApplication.shared
        let book = books![(indexPath as NSIndexPath).row]
        if let mediaUrlValue = book.imageUrl as String?,  mediaUrlValue.isEmpty == false {
            if (self.verifyUrl(urlString: mediaUrlValue)) {
                app.openURL(URL(string: book.imageUrl!)!)
            }
        }
    }
    
    @IBAction func unwindToMyLibraryViewController(_ sender: UIStoryboardSegue) {
        
    }
}
