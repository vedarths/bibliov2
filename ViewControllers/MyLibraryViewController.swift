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

class MyLibraryViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var myLibraryTableView: UITableView!
    var person : Person?
    //var books : [Book]?
    var presentingAlert = false
    var fetchedResultsController: NSFetchedResultsController<Book>!
    
    func refresh() -> Void {
        //getAllBooks()
        myLibraryTableView.reloadData()
    }
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Book> = Book.fetchRequest()
        let predicate = NSPredicate(format: "ownedBy == %@", person!.id!)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext:DataController.getInstance().viewContext, sectionNameKeyPath: nil, cacheName: "books")
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "book"))
        navigationItem.rightBarButtonItem = editButtonItem
        setupFetchedResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        refresh()
    }
    
    @IBAction func doLogout(_ sender: Any) {
        let confirmationAlert = UIAlertController(title: "Logout", message: "Do you really want to logout?", preferredStyle: .actionSheet)
        
        self.present(confirmationAlert, animated: true, completion: nil)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .default, handler: { (action: UIAlertAction!) in
            // Return to login screen
            self.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) in })
        confirmationAlert.addAction(logoutAction)
        confirmationAlert.addAction(cancelAction)
    }
    
    @IBAction func doSearch(_ sender: UIButton) {
        performSegue(withIdentifier: "showSearchBook", sender: sender)
    }
    
    @IBAction func unwindToMyLibraryViewController(_ sender: UIStoryboardSegue) {
        //placeholder method to go to the my library view controller upon exit
    }
    
    /// Deletes the book at the specified index path
    func deleteBook(at indexPath: IndexPath) {
        let bookToDelete = fetchedResultsController.object(at: indexPath)
        DataController.getInstance().viewContext.delete(bookToDelete)
        try? DataController.getInstance().viewContext.save()
    }
    
    private func getAllBooks() -> Void {
        var books : [Book]?
        do {
            books = try DataController.getInstance().fetchBooksForPerson(personId:person!.id!)
        } catch {
            showError(message: "could not fetch books for person")
        }
        //self.books = books
    }
    
    func updateEditButtonState() {
        if let sections = fetchedResultsController.sections {
            navigationItem.rightBarButtonItem?.isEnabled = sections[0].numberOfObjects > 0
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        myLibraryTableView.setEditing(editing, animated: animated)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aBook = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.defaultReuseIdentifier, for: indexPath) as! BookTableViewCell
        // Configure cell
        cell.titleLabel.text = aBook.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
               self.deleteBook(at: indexPath)
               self.myLibraryTableView.reloadData()
        default: () // Unsupported
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a SearchBookViewController, we'll pass `Person`
        if let vc = segue.destination as? SearchBookViewController {
            vc.person = person
        }
    }
    
    
}

extension MyLibraryViewController:NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            myLibraryTableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            myLibraryTableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            myLibraryTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            myLibraryTableView.moveRow(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError("unknown action for the cell!")
        }
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: myLibraryTableView.insertSections(indexSet, with: .fade)
        case .delete: myLibraryTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            fatalError("unknown action for the cell!")
        }
    }
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myLibraryTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myLibraryTableView.endUpdates()
    }
}
