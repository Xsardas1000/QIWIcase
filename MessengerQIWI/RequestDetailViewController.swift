//
//  RequestDetailViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 09.07.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class RequestDetailViewController: UIViewController {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var acceptedLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    
    var user: UserInfo?
    var request: Request?
    
    var currentUserReceptions: [(String, [String: AnyObject])] = []
    var userRequests: [(String, [String: AnyObject])] = []


    @IBAction func acceptRequest(_ sender: UIButton) {
        
        //DataService.dataService.currentUserRef.child("reseptions").child((request?.requestUID)!).child("accepted").setValue(true)
        
       // DataService.dataService.usersRef.child(user?.uid).child("requests").child(<#T##pathString: String##String#>)
        
        for reception in currentUserReceptions {
            if (reception.1["requestID"] as? String) == request?.requestUID {
                DataService.dataService.currentUserRef.child("reseptions").child(reception.0).child("accepted").setValue(true)
                print("accepting1")
                break
            }
        }
        
        for userRequest in userRequests {
            if (userRequest.1["requestID"] as? String) == request?.requestUID {
                DataService.dataService.usersRef.child((user?.uid)!).child("requests").child(userRequest.0).child("accepted").setValue(true)
                print("accepting2")
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view Did Load RequestDetailVC")
        print("userUID = ", user!.uid!)
        print("requestSenderID = ", request!.senderUID!)
        
        if request?.accepted == true {
            acceptButton.isEnabled = false
        }
        
        if request?.type == Request.RequestType.SetDebt {
            typeLabel.text = "Выставлен долг"
        } else {
            typeLabel.text = "Запрошено"
        }
        amountLabel.text = request?.amount
        dateLabel.text = request?.date
        
        if request?.accepted == true {
            acceptedLabel.text = "Да"
        } else {
            acceptedLabel.text = "Нет"
        }
        
        commentTextView.text = request?.comment
        commentTextView.isEditable = false
        
        loadDataFromDatabase()
        
    }

    func loadDataFromDatabase() {
        DataService.dataService.currentUserRef.child("reseptions").observe(DataEventType.value, with: { (snapshot) in
            let reseptions = snapshot.value as? [String : AnyObject] ?? [:]
            for key in reseptions.keys {
                self.currentUserReceptions.append((key, reseptions[key] as! [String : AnyObject]))
            }

        })
        
        DataService.dataService.usersRef.child((user?.uid)!).child("requests").observe(DataEventType.value, with: { (snapshot) in
            let requests = snapshot.value as? [String : AnyObject] ?? [:]
            for key in requests.keys {
                self.userRequests.append((key, requests[key] as! [String : AnyObject]))
            }
            
        })

    }

}
