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
    var dataController: DataController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doRefresh(nil)
    }
    
    
    
    @IBAction func doSignout(_ sender: Any) {
        let confirmationAlert = UIAlertController(title: "Logout", message: "Do you really want to logout?", preferredStyle: .alert)
        
        self.present(confirmationAlert, animated: true, completion: nil)
        
        let logoutAction = UIAlertAction(title: "Logout", style: .default, handler: { (action: UIAlertAction!) in
            // Try to delete API session for more security
            do {
                try Auth.auth().signOut()
                // Return to login screen
                self.dismiss(animated: true, completion: nil)
            } catch {
                self.showError(message: "Could not logout user")
            }
            
        })
        confirmationAlert.addAction(logoutAction)
    }
    
    
    
    @IBAction func doRefresh(_ sender: UIBarButtonItem?) {
        let viewManagers = [ViewManager(), ViewManager()]
        
        //for i in 0 ... 1 {
            //viewManagers[i].showView(view: viewControllers![i].view)
            viewManagers[0].showView(view: viewControllers![0].view)
        //}
        let predicate = NSPredicate(format: "owner == %@", person!.id!)
        do {
            let books = try dataController!.fetchBooksForPerson(person:person!, predicate)
            (self.viewControllers![0] as! MyLibraryViewController).books = books
            (self.viewControllers![0] as! MyLibraryViewController).doRefresh()
        } catch {
            showError(message: "could not fetch books for person")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBook" {
            let navigationController = segue.destination as! UINavigationController
            let searchBookViewController = navigationController.viewControllers[0] as! SearchBookViewController
            searchBookViewController.dataController = self.dataController
            searchBookViewController.person = self.person
        }
    }
}
