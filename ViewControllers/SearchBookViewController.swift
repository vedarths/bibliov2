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
import SystemConfiguration

class SearchBookViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var totalTitles: Int? = nil
    var bookItems: [BookItem] = []
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.checkReachable())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func doSearch(_ sender: Any) {
        if (!checkReachable()) {
            return
        }
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
  
    
    @IBAction func cancelClicked(_ sender: Any) {
        let navigationContoller = storyboard!.instantiateViewController(withIdentifier: "landingNavigationController") as! UINavigationController
        let myLibraryViewController = navigationContoller.viewControllers.first as! MyLibraryViewController
        myLibraryViewController.person = person
        present(navigationContoller, animated: false, completion: nil)
    }
    private func showSearchResultsViewController() {
        let searchResultsVc = storyboard!.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        searchResultsVc.bookItems = self.bookItems
        searchResultsVc.searchTitle = self.titleTextField.text
        searchResultsVc.person = person
         let viewManager = ViewManager()
        viewManager.showView(view: searchResultsVc.view)
        present(searchResultsVc, animated: true, completion: nil)
    }
}

