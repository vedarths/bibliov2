//
//  SignupViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/14/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit


class SignupViewController: UIViewController {
    
    var dataController: DataController?
 
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getUserName() -> String {
        return (self.emailAddressTextField?.text)!
    }
    
    func getPassword() -> String {
        return (self.passwordTextField?.text)!
    }
    
    func getFirstName() -> String {
        return (self.firstNameTextField?.text)!
    }
    
    func getLastName() -> String {
        return (self.lastNameTextField?.text)!
    }
    
    private func completeLogin() {
        let navigationContoller = storyboard!.instantiateViewController(withIdentifier: "landingNavigationController") as! UINavigationController
        present(navigationContoller, animated: true, completion: nil)
    }
    
    @IBAction func doSignup(_ sender: Any) {
        UserManagementClient.sharedInstance().signUp(self) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                    self.showError(message:errorString!)
                }
            }
        }
    }
    
    @IBAction func doCancel(_ sender: Any) {
        let loginViewController = storyboard!.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        present(loginViewController, animated: true, completion: nil)
        
    }
}
