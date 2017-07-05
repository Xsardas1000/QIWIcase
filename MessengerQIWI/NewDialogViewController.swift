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
    
    var verifiedUsersPhones: [String] = []
    
    @IBAction func makeDialog(_ sender: UIButton, forEvent event: UIEvent) {
        
        print(verifiedUsersPhones.count)
    }
    
    
    func loadDataFromDatabase() {
        DataService.dataService.usersRef.observe(DataEventType.value, with: { (snapshot) in
            let users = snapshot.value as? [String : AnyObject] ?? [:]
            
            
            for key in users.keys {
                print("key = ", key)
                let user = users[key] as? [String: AnyObject] ?? [:]
                let isVerified = user["verified"] as? Bool
                if isVerified == true {
                    self.verifiedUsersPhones.append((user["phone"] as? String)!)
                }
            }
            
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromDatabase()

        
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
