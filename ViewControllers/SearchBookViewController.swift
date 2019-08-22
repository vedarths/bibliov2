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
    var bookItems: [BookItem] = []
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func doSearch(_ sender: Any) {
        let title = self.titleTextField.text!
        if (title == "") {
            showError(message: "Please enter a valid title", dismissButtonTitle: "OK")
            return
        }
        BookClient.sharedInstance().findBy(title: title) { (bookVolumeParsed, error) in
            performUIUpdatesOnMain {
                if let bookVolumeParsed = bookVolumeParsed {
                    self.totalTitles = bookVolumeParsed.totalItems
                    self.bookItems = bookVolumeParsed.items!
                    print("total items fetched \(String(describing: self.totalTitles))")
                    self.showSearchResultsViewController()
                } else {
                    self.showError(message: error as! String)
                }
            }
        }
    }
    @IBAction func doCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func showSearchResultsViewController() {
        let searchResultsVc = storyboard!.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        searchResultsVc.bookItems = self.bookItems
        searchResultsVc.searchTitle = self.titleTextField.text
        searchResultsVc.person = person
        present(searchResultsVc, animated: true, completion: nil)
    }
}

