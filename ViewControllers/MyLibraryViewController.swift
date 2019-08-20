//
//  MyLibraryViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/11/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit

class MyLibraryViewController: UITableViewController {
    
    func doRefresh() {
        tableView.reloadData()
    }
    
    var dataController: DataController?
    var person : Person?
    var books : [Book]?
    var presentingAlert = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (books == nil) {
            books = [Book]()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        books = appDelegate.books
        doRefresh()
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
}
