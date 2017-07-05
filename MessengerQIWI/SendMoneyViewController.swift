//
//  SendMoneyViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 30.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class SendMoneyViewController: UIViewController {

    @IBOutlet weak var amountMoneyTextFiekd: UITextField!
    
    var user: UserInfo?
    
    @IBAction func confirmSend(_ sender: UIButton, forEvent event: UIEvent) {
        if amountMoneyTextFiekd.text != "" {
            print("sending \(String(describing: amountMoneyTextFiekd.text)) rub")
        }
        
        let tmp = user?.phone
        let index = tmp?.index((tmp?.startIndex)!, offsetBy: 1)
        let recieverPhoneNumber = tmp?.substring(from: index!)
        
        
        DataService.dataService.currentUserRef.observe(DataEventType.value, with: { (snapshot) in
            let user = snapshot.value as? [String : AnyObject] ?? [:]
            
            let tmp = user["phone"] as? String
            let index = tmp?.index((tmp?.startIndex)!, offsetBy: 1)
            let currentUserPhoneNumber = tmp?.substring(from: index!)
            
            let token = user["token"] as? String
            
            let amount = self.amountMoneyTextFiekd.text
            let currentTime = String(Int(Date().timeIntervalSince1970 * 1000))
            
            print("reciever = ", recieverPhoneNumber!)
            print("current = ", currentUserPhoneNumber!)
            print("currentTime = ", currentTime)

            
            let authorization: String = currentUserPhoneNumber! + ":" + token!
            let authorizationBase64String = self.convertToBase64String(str: authorization)
            
            let paymentHeaders: HTTPHeaders = [
                "Accept": "application/vnd.qiwi.v2+json",
                "Content-Type": "application/json",
                "Accept-Encoding": "gzip, deflate, compress",
                "User-Agent": "HTTPie/0.3.0",
                "Authorization": "Token " + authorizationBase64String
            ]

            let paymentParameters: Parameters = [
                "fields": [
                    "account": recieverPhoneNumber,
                    "prvld": "99"
                ],
                "id": currentTime,
                "paymentMethod": [
                    "type": "Account",
                    "accountId": "643"
                ],
                "sum": [
                    "amount": amount,
                    "currency": "643"
                ]
            ]
            
            Alamofire.request("https://sinap.qiwi.com/api/terms/99/payments",
                              method: .post,
                              parameters: paymentParameters,
                              encoding: JSONEncoding.default,
                              headers: paymentHeaders).responseJSON {
                                
                                response in
                                debugPrint(response)
                                
            }
        })
    }
    
    func convertToBase64String(str: String) -> String {
        guard let authorizationData = (str as String).data(using: String.Encoding.utf8) else {
            fatalError()
        }
        
        let base64String = (authorizationData as Data).base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        //print(base64String)
        return base64String
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentTime = NSDate().timeIntervalSince1970 * 1000
        
        print("currentTime = \(currentTime)")
    }

    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
