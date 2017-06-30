//
//  ProfileViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 29.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userPhoto: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var realName: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var dob: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    var user: [String : AnyObject]?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let usersRef = Database.database().reference().child("users")
        
        //let userUID = Auth.auth().currentUser?.uid
        
        //let userRef = DataService.dataService.usersRef.child("OD9oMRN6o2S2kk59gh8xFg949Zz2")
        
        //let userRef = DataService.dataService.usersRef.child("OD9oMRN6o2S2kk59gh8xFg949Zz2")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        DataService.dataService.currentUserRef.observe(DataEventType.value, with: { (snapshot) in
            let user = snapshot.value as? [String : AnyObject] ?? [:]
            
            self.user = user
            //print("user = ", user)
            
            //Setting values known after login
            self.username.text = user["username"] as? String
            self.email.text = user["email"] as? String
            
            if user["phone"] != nil && user["verified"] != nil {
                if (user["verified"] as! Bool) == true {
                    self.phoneNumber.text = user["phone"] as? String
                }
            }
            
            //if user has not already filled userinfo
            if user["info"] == nil {
                print("no info")
            } else {
                print("filling info")
                

                let info = user["info"] as! [String: AnyObject]
                
                self.realName.text = info["name"] as? String
                
                
                let dobTimeInterval = info["dob"] as! TimeInterval
                self.dob.text = self.populateTimeInterval(timeInterval: dobTimeInterval)
                
                let base64String = info["photo"] as! String
                self.userPhoto.image =  self.populateImage(imageString: base64String)
                

            }
        })
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

    }
    
    
    //MARK: - Populate TimeInterval as Image
    
    func populateTimeInterval(timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSinceNow: timeInterval)
        return formatDate(date: date)
    }
    
    func populateImage(imageString: String) -> UIImage {
        
        let decodedData = Data(base64Encoded: imageString,
                               options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        
        let decodedImage = UIImage(data: decodedData!)
        
        return decodedImage!
    }
    
    

    @IBAction func addPhoneNumber(_ sender: UIButton, forEvent event: UIEvent) {
    }
    
    
    @IBAction func attachWallet(_ sender: UIButton, forEvent event: UIEvent) {
        //можно привязать кошелек если авторизовались с помощью телефона и он есть в базе
        if (self.user?["verified"] as! Bool) == true {
            print("user verified and goes to attach wallet")
            
            performSegue(withIdentifier: "attachSegue", sender: nil)
        }
        
    }

    @IBAction func openDialogs(_ sender: UIButton, forEvent event: UIEvent) {
    }

    @IBAction func logout() {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        UserDefaults.standard.set(nil, forKey: "uid")
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "ShowLogin")
        UIApplication.shared.keyWindow?.rootViewController = loginViewController
    }

}