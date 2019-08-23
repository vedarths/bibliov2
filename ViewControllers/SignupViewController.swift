//
//  SignupViewController.swift
//  BiblioV2
//
//  Created by Vedarth Solutions on 8/14/19.
//  Copyright © 2019 Vedarth Solutions. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class SignupViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var person: Person?
    var fetchedResultsController:NSFetchedResultsController<Person>!
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Person> = Person.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.getInstance().viewContext, sectionNameKeyPath: nil, cacheName: "person")
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
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
    
    private func completeSignup() {
        do {
        try DataController.getInstance().createPerson(email: self.getUserName(), title: "", firstname: getFirstName(), lastname: getLastName())
        } catch {
            print("\(#function) error:\(error)")
            showInfo(withTitle: "Error", withMessage: "Error while saving Person into disk: \(error)")
        }
        let navigationContoller = storyboard!.instantiateViewController(withIdentifier: "landingNavigationController") as! UINavigationController
        let mainController = navigationContoller.viewControllers.first as! MainController
        let person = fetchPerson(username: getUserName())
        mainController.person = person
        let myLibraryViewController = mainController.viewControllers![0] as! MyLibraryViewController
        myLibraryViewController.person = person
        present(navigationContoller, animated: false, completion: nil)
    }
    
    @IBAction func doSignup(_ sender: Any) {
        
        if (self.passwordTextField.text?.trimmingCharacters(in: .whitespaces) != self.repeatPasswordTextField.text!.trimmingCharacters(in: .whitespaces)) {
            showError(message: "Passwords do not match")
            return
        } else {
            UserManagementClient.sharedInstance().signUp(self) { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.completeSignup()
                } else {
                    self.showError(message:errorString!)
                }
            }
         }
      }
    }
    
    @IBAction func doCancel(_ sender: Any) {
        let loginViewController = storyboard!.instantiateViewController(withIdentifier: "loginViewController") as! LoginViewController
        present(loginViewController, animated: true, completion: nil)
        
    }
}
