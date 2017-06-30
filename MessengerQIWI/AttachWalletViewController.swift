//
//  AttachWalletViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 30.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class AttachWalletViewController: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    
    var code: String?
    var phone: String?
    
    @IBAction func tapGetCode(_ sender: UIButton, forEvent event: UIEvent) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        requestForCode()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    
    func requestForCode() {
        let headers: HTTPHeaders = [
            "Accept": "*/*", //
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept-Encoding": "gzip, deflate, compress",
            "User-Agent": "HTTPie/0.3.0"
        ]
        
        
        Alamofire.request("https://w.qiwi.com/oauth/authorize?client_id=qw-fintech&client_secret=Xghj!bkjv64&client-software=qw-fintech-0.0.1&response_type=code&username=" + self.phone!,
                          method: .post,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON
            {
                response in
                //debugPrint(response)
                
                //print("Response JSON: \(String(describing: response.result.value))")
                switch response.result {
                case .success(let value):
                    
                    
                    guard let jsonArray = value as? [String: Any] else { return }
                    print(jsonArray)
                    
                    print("code = \(jsonArray["code"]!)")
                    self.code = jsonArray["code"]! as? String
                    print(self.code!)
                    
                case .failure(let error):
                    print("error")
                    print(error)
                }
        }
    }
    
    
    @IBAction func tapSubmit(_ sender: UIButton, forEvent event: UIEvent) {
        
        let recievedCode = codeTextField.text
        
        let headers: HTTPHeaders = [
            "Accept": "*/*", //
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept-Encoding": "gzip, deflate, compress",
            "User-Agent": "HTTPie/0.3.0"
        ]
        
        if recievedCode != "" {
            Alamofire.request("https://w.qiwi.com/oauth/access_token?client_id=qw-fintech&client_secret=Xghj!bkjv64&client-software=qw-fintech-0.0.1&grant_type=urn:qiwi:oauth:grant-type:vcode&code=" + self.code! + "&vcode=" + recievedCode!,
                              method: .post,
                              encoding: JSONEncoding.default,
                              headers: headers).responseJSON {
                                
                                response in
                                //debugPrint(response)
                                switch response.result {
                                case .success(let value):
                                    print("success")
                                    //print(value)
                                    
                                    guard let jsonArray = value as? [String: Any] else { return }
                                    print(jsonArray)
                                    print("access_token = \(jsonArray["access_token"]!)")
                                    
                                    //Save token to database
                                    let token = DataService.dataService.currentUserRef.child("token")
                                    
                                    //write data to Firebase
                                    token.setValue(jsonArray["access_token"]!)
                                    
                                    
                                case .failure(let error):
                                    print(error)
                                }
                                
            }
        }
        

        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let userRef = DataService.dataService.usersRef.child("OD9oMRN6o2S2kk59gh8xFg949Zz2")

        
        DataService.dataService.currentUserRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let user = snapshot.value as? [String : AnyObject] ?? [:]
            
            print("user = ", user)
            let tmp = user["phone"] as? String
            
            let index = tmp?.index((tmp?.startIndex)!, offsetBy: 1)
            self.phone = tmp?.substring(from: index!) 
            
            
        })
    }


}
