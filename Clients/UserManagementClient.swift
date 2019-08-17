//
//  UserManagementClient.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/17/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

class UserManagementClient: NSObject {
    
    var userName: String? = nil
    var password: String? = nil
    
    func signIn(_ hostViewController: UIViewController, completionHandlerForLogin: @escaping(_ success: Bool, _ errorStringL: String?) -> Void) {
        
        let loginViewController = hostViewController as! LoginViewController
        userName = loginViewController.getUserName()
        password = loginViewController.getPassword()
        
        if (userName == "" || password == "") {
            loginViewController.showError(message: "Please provide a username and password")
        } else {
            Auth.auth().signIn(withEmail: userName!, password: password!) { (user, error) in
                
                if (error != nil) {
                    loginViewController.showError(message: "Unable to login, please check your credentials")
                } else {
                    print("managed to login successfully")
                    completionHandlerForLogin(true, nil)
                }
            }
        }
    }
    
    func signUp(_ hostViewController: UIViewController, completionHandlerForLogin: @escaping(_ success: Bool, _ errorStringL: String?) -> Void) {
        
        let loginViewController = hostViewController as! LoginViewController
        userName = loginViewController.getUserName()
        password = loginViewController.getPassword()
        
        if (userName == "") {
            loginViewController.showError(message: "Please enter a valid email address")
        } else {
            Auth.auth().createUser(withEmail: userName!, password: password!) { (user, error) in
                if (error != nil) {
                    loginViewController.showError(message: "Could not signup user \(String(describing: self.userName!))")
                } else {
                    print("managed to sign up user \(String(describing: self.userName!))")
                    completionHandlerForLogin(true, nil)
                }
            }
        }
    }
    
    class func sharedInstance() -> UserManagementClient {
        struct Singleton {
            static var sharedInstance = UserManagementClient()
        }
        return Singleton.sharedInstance
    }
}

