//
//  SignUpViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 29.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUp(sender: AnyObject) {
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if username != "" && email != "" && password != "" {
            
            //Set Email and Password for the new user
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (result, error) in
                
                if error == nil {
                    
                    //Get the currently signed-in user
                    if Auth.auth().currentUser != nil {
                        // User is signed in.
                        print("User is signed in.")
                        let user = Auth.auth().currentUser
                        let userData = ["email": email,
                                        "username": username]
                        
                        DataService.dataService.usersRef.child((user?.uid)!).setValue(userData)
                        DataService.dataService.usersRef.child((user?.uid)!).child("balance").setValue(0)
                        

                        
                        //Store the uid for access
                        UserDefaults.standard.set(result?.uid, forKey: "uid")
                        
                        //Enter the app
                        self.performSegue(withIdentifier: "SignUp", sender: nil)
                        
                    } else {
                        // No user is signed in.
                        print("No user is signed in.")
                    }
                    
                } else {
                    print(error?.localizedDescription)
                    displayAlert(title: "Oops!",
                                 message: "Having some trouble creating your account. Try again!",
                                 viewController: self)

                }
            })
            
        } else {
            displayAlert(title: "Oops!",
                         message: "Don't forget to enter your email, password and username",
                         viewController: self)
        }
        //можно добавить дополнительную проверку на поля
        
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
