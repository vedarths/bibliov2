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
        fetchBooksFromApi()
        let controller = storyboard!.instantiateViewController(withIdentifier: "SearchResultsViewController") as! SearchResultsViewController
        controller.items = self.items
        present(controller, animated: true, completion: nil)
    }
   
    private func fetchBooksFromApi() {
        let title = self.titleTextField.text!
        BookClient.sharedInstance().findBy(title: title) { (bookVolumeParsed, error) in
            DispatchQueue.main.async {
                print("fetching books catalogue...")
            }
            if let bookVolumeParsed = bookVolumeParsed {
                self.totalTitles = bookVolumeParsed.totalItems
                print("total items fetched \(String(describing: self.totalTitles))")
                self.items = bookVolumeParsed.items
            }
        }
    }
    
   
    

}

