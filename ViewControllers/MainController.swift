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
        doRefresh(nil)
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
    
    @IBAction func doRefresh(_ sender: UIBarButtonItem?) {
        let viewManagers = [ViewManager(), ViewManager()]
        viewManagers[0].showView(view: viewControllers![0].view)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addBook" {
            let navigationController = segue.destination as! UINavigationController
            let searchBookViewController = navigationController.viewControllers[0] as! SearchBookViewController
            searchBookViewController.person = self.person
        }
    }
}
