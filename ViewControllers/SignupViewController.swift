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
    
    
    
}
