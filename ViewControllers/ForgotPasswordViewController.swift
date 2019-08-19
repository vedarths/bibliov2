//
//  ForgtoPasswordViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/18/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var emailAddressTextField: UITextField!
    
    var person : Person?
    var dataController: DataController?
    func getEmailAddress() -> String {
        return (self.emailAddressTextField?.text)!
    }
    
    func fetchPerson() -> Void {
        let username = getEmailAddress()
        if (username != "") {
            do {
                let person = try dataController!.fetchPerson(id: username, entityName: "Person")
                self.person = person!
            } catch {
                fatalError("The fetch could not be performed: \(error.localizedDescription)")
            }
        } else {
            showInfo(withMessage: "Please enter a valid email adddress")
        }
    }
    
    @IBAction func doResetPassword(_ sender: Any) {
        UserManagementClient.sharedInstance().resetPassword(self) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    let loginViewController = self.storyboard!.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
                    self.present(loginViewController, animated: true, completion: nil)
                } else {
                    self.showError(message:errorString!)
                }
            }
        }
        
    }
}
