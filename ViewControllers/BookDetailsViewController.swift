//
//  BookDetailsViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/13/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit

class BookDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    @IBOutlet weak var addToLibraryButton: UIButton!
    @IBOutlet weak var borrowButton: UIButton!
    
    var book: Book?
    var person: Person?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateView()
    }
    
    private func updateView() -> Void {
        self.bookTitleLabel.text = book!.title
        self.bookDescriptionLabel.text = book!.bookDescription
        self.bookImageView.image = UIImage(data: book!.image! as Data)
    }
    
    @IBAction func addToLibraryTapped(_ sender: Any) {
    }
    
    @IBAction func borrowFromLibraryTapped(_ sender: Any) {
    }
}
