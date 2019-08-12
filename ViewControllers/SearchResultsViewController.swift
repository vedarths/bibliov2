//
//  SearchResultsViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/11/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SearchResultsViewController: UIViewController {
    
    var books: [Book]?
    var dataController : DataController?
    var fetchResultsController: NSFetchedResultsController<Book>!
    var selected = [IndexPath]()
    var inserted: [IndexPath]!
    var deleted: [IndexPath]!
    var updated: [IndexPath]!
    var presentingAlert = false
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        updateFlowLayout(view.frame.size)
        setStatusLabel("\(String(describing: books?.count)) item(s) found")
        setupFetchedResultsController()
    }
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newResultsButton: UIBarButtonItem!
    
    @IBOutlet weak var statusLabel: UILabel!
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Book> = Book.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController!.viewContext, sectionNameKeyPath: nil, cacheName: "books")
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    private func updateFlowLayout(_ withSize: CGSize) {
        let landscape = withSize.width > withSize.height
        let space: CGFloat = landscape ? 5 : 3
        let items: CGFloat = landscape ? 2 : 3
        let dimension = (withSize.width - ((items + 1) * space)) / items
        
        flowLayout?.minimumInteritemSpacing = space
        flowLayout?.minimumLineSpacing = space
        flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
        flowLayout?.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    private func setStatusLabel(_ text: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = text
        }
    }
}

extension SearchResultsViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as! BookCell
        cell.imageView.image = nil
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sectionInfo = self.fetchResultsController.sections?[section] {
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let book = self.fetchResultsController.object(at: indexPath)
        let bookCell = cell as! BookCell
        bookCell.imageUrl = book.imageUrl!
        configImage(using: bookCell, book: book, collectionView: collectionView, index: indexPath)
    }
    
    private func configImage(using cell: BookCell, book: Book, collectionView: UICollectionView, index: IndexPath) {
        if let imageData = book.image {
            cell.imageView.image = UIImage(data: Data(referencing: imageData))
        } else {
            if let imageUrl = book.imageUrl {
       
                BookClient.sharedInstance().getImage(imageUrl: imageUrl) { (data, error) in
                    if let _ = error {
                        DispatchQueue.main.async {
                            self.errorForImageUrl(imageUrl)
                        }
                        return
                    } else if let data = data {
                        DispatchQueue.main.async {
                            if let currentCell = collectionView.cellForItem(at: index) as? BookCell {
                                if currentCell.imageUrl == imageUrl {
                                    currentCell.imageView.image = UIImage(data: data)
                                }
                            }
                            book.image = NSData(data: data)
                            DispatchQueue.global(qos: .background).async {
                                DataController.getInstance().autoSaveViewContext()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func errorForImageUrl(_ imageUrl: String) {
        if !self.presentingAlert {
            self.showInfo(withTitle: "Error", withMessage: "Error while fetching image for URL: \(imageUrl)", action: {
                self.presentingAlert = false
            })
        }
        self.presentingAlert = true
    }
}

extension SearchResultsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        inserted = [IndexPath]()
        deleted = [IndexPath]()
        updated = [IndexPath]()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            inserted.append(newIndexPath!)
            break
        case .delete:
            deleted.append(indexPath!)
            break
        case .update:
            updated.append(indexPath!)
            break
        case .move:
            print("Move item.")
            break
        @unknown default:
            print("Default behaviour.")
            break
        }
    }
    // Handle controller behaviours for insertion, deletion and updates
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates({() -> Void in
            for indexPath in self.inserted {
                self.collectionView.insertItems(at: [indexPath])
            }
            for indexPath in self.deleted {
                self.collectionView.deleteItems(at: [indexPath])
            }
            for indexPath in self.updated {
                self.collectionView.reloadItems(at: [indexPath])
            }
        }, completion: nil)
    }
}
