//
//  ViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/11/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import UIKit
import Foundation

class SearchBookViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var totalTitles: Int? = nil
    var items: [BookItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func doSearch(_ sender: Any) {
        let title = self.titleTextField.text!
        BookClient.sharedInstance().findBy(title: title) { (bookVolumeParsed, error) in
            performUIUpdatesOnMain {
                if let bookVolumeParsed = bookVolumeParsed {
                    self.totalTitles = bookVolumeParsed.totalItems
                    print("total items fetched \(String(describing: self.totalTitles))")
                    self.items = bookVolumeParsed.items
                    self.showSearchResultsViewController()
                } else {
                    self.showError(message: error as! String)
                }
            }
        }
    }
    
    private func showSearchResultsViewController() {
        let searchResultsVc = storyboard!.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        present(searchResultsVc, animated: true, completion: nil)
    }
 
}

