//
//  MainController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/20/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import CoreData

class MainController: UITabBarController {
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doSignout(_ sender: Any) {
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
    @IBAction func doDeleteLibrary(_ sender: Any) {
        let confirmationAlert = UIAlertController(title: "Purge Library", message: "Do you really want to purge library?", preferredStyle: .actionSheet)
        
        self.present(confirmationAlert, animated: true, completion: nil)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            // Return to login screen
            do {
                try DataController.getInstance().deleteAllBooksForPerson(personId: self.person!.id!)
                
            } catch {
                self.showError(message: "Fatal error occurred trying to remove books from library!")
            }
            self.showInfo(withMessage: "You library has been cleared. Click on the tabbar to refresh!")
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction!) in })
        confirmationAlert.addAction(yesAction)
        confirmationAlert.addAction(cancelAction)
        
        do {
            try DataController.getInstance().deleteAllBooksForPerson(personId: person!.id!)
        } catch {
            showError(message: "Fatal error occurred trying to remove books from library!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBook" {
            let navigationController = segue.destination as! UINavigationController
            let searchBookViewController = navigationController.viewControllers[0] as! SearchBookViewController
            searchBookViewController.person = self.person
        }
    }
}
