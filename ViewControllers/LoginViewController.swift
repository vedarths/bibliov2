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
    }
    
    @IBAction func doLogin(_ sender: Any) {
    }
    
    @IBAction func doForgotPassword(_ sender: Any) {
    }
    @IBAction func doSignup(_ sender: Any) {
    }
}
