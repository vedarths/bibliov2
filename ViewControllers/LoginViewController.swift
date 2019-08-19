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
    var person: Person?
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
         fetchPerson()
         let navigationContoller = storyboard!.instantiateViewController(withIdentifier: "landingNavigationController") as! UINavigationController
         let tabBarController = navigationContoller.viewControllers.first as! UITabBarController
        let myLibraryViewController = tabBarController.viewControllers![0] as! MyLibraryViewController
         myLibraryViewController.dataController = dataController
         let searchBookViewController = tabBarController.viewControllers![1] as! SearchBookViewController
         searchBookViewController.dataController = dataController
         present(navigationContoller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forgotPaswordFlow" {
            let forgotPassworVc = segue.destination as! ForgotPasswordViewController
            forgotPassworVc.dataController = self.dataController
        }
    }
    
    func fetchPerson() -> Void {
        let username = getUserName()
        if (username != "") {
            do {
                let person = try dataController!.fetchPerson(id: username, entityName: "Person")
                self.person = person!
            } catch {
                 fatalError("The fetch could not be performed: \(error.localizedDescription)")
            }
        }
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
