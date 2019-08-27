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
    
    var searchTitle: String?
    var bookItems: [BookItem]?
    var books: [Book]?
    var person : Person?
    var fetchResultsController: NSFetchedResultsController<Book>!
    var presentingAlert = false
    override func viewDidLoad() {
        super.viewDidLoad()
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        updateFlowLayout(view.frame.size)
        setStatusLabel("\(String(describing: self.bookItems!.count)) item(s) found")
        setupFetchedResultsController()
    }
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var statusLabelText: UILabel!

    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Book> = Book.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.getInstance().viewContext, sectionNameKeyPath: nil, cacheName: "books")
        do {
            try fetchResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
   
    @IBAction func cancelTapped(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    private func updateFlowLayout(_ withSize: CGSize) {
        let landscape = withSize.width > withSize.height
        let space: CGFloat = landscape ? 5 : 3
        let items: CGFloat = landscape ? 2 : 3
        let dimension = (withSize.width - ((items + 1) * space)) / items
        
        collectionViewFlowLayout?.minimumInteritemSpacing = space
        collectionViewFlowLayout?.minimumLineSpacing = space
        collectionViewFlowLayout?.itemSize = CGSize(width: dimension, height: dimension)
        collectionViewFlowLayout?.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
    }
    
    private func setStatusLabel(_ text: String) {
        DispatchQueue.main.async {
            self.statusLabelText.text = text
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
        return self.bookItems!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let bookItem = bookItems![indexPath.row]
        let bookCell = cell as! BookCell
        if (bookItem.volumeInfo != nil && bookItem.volumeInfo?.imageLinks != nil && bookItem.volumeInfo?.imageLinks?.thumbnail != nil) {
            bookCell.imageUrl = (bookItem.volumeInfo!.imageLinks?.thumbnail!)!
            configImage(using: bookCell, book: bookItem, imageUrl: bookCell.imageUrl, collectionView: collectionView, index: indexPath)
        } else {
            bookCell.imageView.image = UIImage(named: "unavailable")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookItem = bookItems![indexPath.row]
        let bookDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "BookDetailsViewController") as? BookDetailsViewController
        bookDetailsViewController?.book = bookItem
        bookDetailsViewController?.person = person
        if let currentCell = collectionView.cellForItem(at: indexPath) as? BookCell {
           bookDetailsViewController?.image = currentCell.imageView.image
        }
        present(bookDetailsViewController!, animated: true, completion: nil)
      }
    
    private func configImage(using cell: BookCell, book: BookItem, imageUrl: String, collectionView: UICollectionView, index: IndexPath) {
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
                            cell.imageView.image = UIImage(data: data)
                            DispatchQueue.global(qos: .background).async {
                                DataController.getInstance().autoSaveViewContext()
                            }
                        }
                    }
                }
    }
    
    func errorForImageUrl(_ imageUrl: String) {
        if !self.presentingAlert {
            self.showInfo(withTitle: "Error", withMessage: "Error while fetching image for URL: \(imageUrl)", action: {
                self.presentingAlert = false
            })
        }
        self.presentingAlert = true
    }
}

