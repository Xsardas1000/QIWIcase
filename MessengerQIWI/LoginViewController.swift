//
//  LoginViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 29.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let isVerified = Auth.auth().currentUser?.isEmailVerified
        print("verified = \(isVerified)")
        
        if UserDefaults.standard.value(forKey: "uid") != nil && isVerified != nil  && isVerified != false {
            self.performSegue(withIdentifier: "Login", sender: nil)
            print("loginSegue")
        }
    }
    
    @IBAction func login(sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email != "" && password != "" {
            
            //Trying to Login with authUser
            Auth.auth().signIn(withEmail: email!, password: password!) { (user, error) in
                if error != nil {
                    displayAlert(title: "Oops!",
                                 message: "Check your username and password",
                                 viewController: self)
                } else {
                    //Be sure the correct uid is stored
                    UserDefaults.standard.set(user?.uid, forKey: "uid")
                    
                    self.performSegue(withIdentifier: "Login", sender: nil)
                
                }
            }
            
            
        } else {
            displayAlert(title: "Oops!",
                         message: "Don't forget to enter your email, password",
                         viewController: self)
        }
            
    }

}
