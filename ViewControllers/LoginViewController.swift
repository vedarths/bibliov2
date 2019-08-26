//
//  LoginViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/14/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.userNameTextField.text = ""
        self.passwordTextField.text = ""
    }
    func getUserName() -> String {
        return (self.userNameTextField?.text)!
    }
    
    func getPassword() -> String {
        return (self.passwordTextField?.text)!
    }
    
    private func completeLogin() {
        let person = fetchPerson(username: getUserName())
        if (person == nil) {
            do {
                //todo - find a way to delete fire base user after deleting core data?!! - until then use the below hack
                try DataController.getInstance().createPerson(email: self.userNameTextField.text!, title: "Mr.", firstname: "John", lastname: "Doe")
            } catch {
                print("\(#function) error:\(error)")
                showInfo(withTitle: "Error", withMessage: "Error while saving Person into disk: \(error)")
            }
        }
         let navigationContoller = storyboard!.instantiateViewController(withIdentifier: "landingNavigationController") as! UINavigationController
         let myLibraryViewController = navigationContoller.viewControllers.first as! MyLibraryViewController
         myLibraryViewController.person = person
         present(navigationContoller, animated: false, completion: nil)
    }
    
    
    @IBAction func doLogin(_ sender: Any) {
        UserManagementClient.sharedInstance().signIn(self) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeLogin()
                } else {
                    self.showError(message: errorString!)
                }
            }
        }
    }
    
    @IBAction func doForgotPassword(_ sender: Any) {
        let forgotPasswordViewController = storyboard!.instantiateViewController(withIdentifier: "forgotPasswordViewController") as! ForgotPasswordViewController
        present(forgotPasswordViewController, animated: true, completion: nil)
    }
    @IBAction func doSignup(_ sender: Any) {
        let signupViewController = storyboard!.instantiateViewController(withIdentifier: "signupViewController") as! SignupViewController
        present(signupViewController, animated: true, completion: nil)
    }
}
