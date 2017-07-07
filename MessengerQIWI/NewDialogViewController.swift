//
//  NewDialogViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 05.07.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Firebase

class NewDialogViewController: UIViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var createDialog: UIButton!
    
    let progressHUD = ProgressHUD(text: "Loading data")

    
    var verifiedUsers: [(String, [String: AnyObject])] = []
    
    //потом добавление пользователя должно проходить с согласия пользователя
    @IBAction func makeDialog(_ sender: UIButton, forEvent event: UIEvent) {
        
        print(verifiedUsers.count)
        let currentUserFriendsRef = DataService.dataService.currentUserRef.child("friends")
        
        
        for user in verifiedUsers {
            if (user.1["phone"] as? String) == phoneNumberTextField.text! {
                print("can add new dialog for phone number = ", phoneNumberTextField.text!)
            
                let currentUserUID = DataService.dataService.currentUserUID
                let newUserUID = user.0

                let friendsRef = DataService.dataService.currentUserRef.child("friends").child(newUserUID)
                friendsRef.setValue(true)
                
                let newFriendRef = DataService.dataService.usersRef.child(user.0).child("friends").child(currentUserUID)
                newFriendRef.setValue(true)
                
                newFriendRef.setValue([DataService.dataService.currentUserUID: true])
                
                
                
                
                
                
                /*let currentUserUID = DataService.dataService.currentUserUID
                let newUserUID = user.0
                
                let childUpdates =
                    ["/users/\(currentUserUID)/friends/": [newUserUID: true],
                     "/users/\(newUserUID)/friends/": [currentUserUID: true]
                    ]
                
                DataService.dataService.baseRef.updateChildValues(childUpdates)
                */
                
                
                
                
            }
        }
        self.dismiss(animated: true, completion: nil)

    }
    
    func deactivateElements() {
        self.createDialog.isEnabled = false
        self.phoneNumberTextField.isEnabled = false
    }
    
    func activateElements() {
        self.createDialog.isEnabled = true
        self.phoneNumberTextField.isEnabled = true
    }
    
    
    func loadDataFromDatabase() {
        DataService.dataService.usersRef.observe(DataEventType.value, with: { (snapshot) in
            let users = snapshot.value as? [String : AnyObject] ?? [:]
            
            print("new dialog current user id = ", DataService.dataService.currentUserUID)
            for key in users.keys {
                //print("key = ", key)
                //print("current user uid = ", DataService.dataService.currentUserUID)
                let user = users[key] as? [String: AnyObject] ?? [:]
                let isVerified = user["verified"] as? Bool
                
                if isVerified == true && key != DataService.dataService.currentUserUID {
                    self.verifiedUsers.append((key, user))
                    print("user phone = ", user["phone"] as? String)
                }
            }
            self.progressHUD.isHidden = true
            self.activateElements()

        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view did load in NewDialogVC")
        deactivateElements()
        self.view.addSubview(progressHUD)
        
        DataService.dataService.currentUserRef.removeAllObservers()
        DataService.dataService.usersRef.removeAllObservers()
        loadDataFromDatabase()
        
        

        
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
