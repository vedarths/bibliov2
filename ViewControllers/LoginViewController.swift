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
    
    var dataController: DataController?
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getUserName() -> String {
        return (self.userNameTextField?.text)!
    }
    
    func getPassword() -> String {
        return (self.passwordTextField?.text)!
    }
    
    private func completeLogin() {
         let navigationContoller = storyboard!.instantiateViewController(withIdentifier: "landingNavigationController") as! UINavigationController
         present(navigationContoller, animated: true, completion: nil)
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
    }
    @IBAction func doSignup(_ sender: Any) {
        let signupViewController = storyboard!.instantiateViewController(withIdentifier: "signupViewController") as! SignupViewController
        signupViewController.dataController = dataController!
        present(signupViewController, animated: true, completion: nil)
    }
}
