//
//  SearchResultsViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/11/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit

class SearchResultsViewController: UIViewController {
    
    var items: [BookItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("items size is \(items?.count)")
    }
}
