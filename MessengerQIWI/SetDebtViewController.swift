//
//  SetDebtViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 02.07.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class SetDebtViewController: UIViewController {

    var user: UserInfo?
    var currentUser: UserInfo?
    var transactionType: UserInfo.Type?

    @IBOutlet weak var amountMoneyTextField: UITextField!
    
    @IBOutlet weak var commentTextView: UITextView!
    
    @IBAction func sendRequest(_ sender: UIButton, forEvent event: UIEvent) {
        
        print("currentUser = ", self.currentUser!.username!)
        print("reciever = ", self.user!.username!)

        
        let newReseptionRef =
            DataService.dataService.usersRef.child((user?.uid)!).child("reseptions").childByAutoId()
        
        
        let amountMoney = amountMoneyTextField.text
        
        let comment = commentTextView.text
        
        let message: [String: AnyObject] = ["requestID": newReseptionRef.key,
                                            "type":"setDebt",
                                            "comment": comment!,
                                            "senderUID": currentUser!.uid!,
                                            "receiverUID": user!.uid!,
                                            "amount": amountMoney!,
                                            "accepted": false,
                                            "time": Date().timeIntervalSince1970,
                                            "date": getCurrentDate()
                                            ] as [String: AnyObject]
        
        newReseptionRef.setValue(message)
        
        let newRequestRef = DataService.dataService.currentUserRef.child("requests").childByAutoId()
        
        newRequestRef.setValue(message)
        
        
    }
    
    func loadCurrentUserData() {
        DataService.dataService.currentUserRef.observe(DataEventType.value, with: { (snapshot) in
            let user = snapshot.value as? [String : AnyObject] ?? [:]
            self.currentUser = UserInfo(snapshot: user, uid: DataService.dataService.currentUserUID)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentUserData()
        
        //DataService.dataService.currentUserRef.removeAllObservers()
    }

    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        let date = Date()
        
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        return result
    }

}
