//
//  WelcomePageViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 26.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Alamofire

class WelcomePageViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var authorizeButton: UIButton!
    
    @IBAction func tapAuthorizeButton(_ sender: UIButton, forEvent event: UIEvent) {
        performSegue(withIdentifier: "authorize", sender: self)
    }
    
    @IBAction func tapLoginButton(_ sender: UIButton, forEvent event: UIEvent) {

        
        let phoneNumber = "79031050112"
        
        let headers: HTTPHeaders = [
            "Accept": "*/*", //
            "Content-Type": "application/x-www-form-urlencoded",
            "Accept-Encoding": "gzip, deflate, compress",
            "User-Agent": "HTTPie/0.3.0"
        ]
        

        
        
        Alamofire.request("https://w.qiwi.com/oauth/authorize?client_id=qw-fintech&client_secret=Xghj!bkjv64&client-software=qw-fintech-0.0.1&response_type=code&username=" + phoneNumber,
                          method: .post,
                          encoding: JSONEncoding.default,
                          headers: headers).responseJSON
            {
                response in
                //debugPrint(response)
        
                //print("Response JSON: \(String(describing: response.result.value))")
                switch response.result {
                case .success(let value):
                    print("success")
                    //print(value)
                    
                    guard let jsonArray = value as? [String: Any] else { return }
                    print(jsonArray)
         
                    print("code = \(jsonArray["code"]!)")
                    
                case .failure(let error):
                    print("error")
                    print(error)
                }
            }
 
        
        let code = "7eca316b54e3741e91efcd63853ce6a8"
        
        Alamofire.request("https://w.qiwi.com/oauth/access_token?client_id=qw-fintech&client_secret=Xghj!bkjv64&client-software=qw-fintech-0.0.1&grant_type=urn:qiwi:oauth:grant-type:vcode&code=" + code + "&vcode=129098",
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
                                
                            case .failure(let error):
                                print("error")
                                print(error)
                            }

        }
        
        
        let access_token = "878010865c21ca0c20bed6dc45169faf"
        
        
        let authorization: String = phoneNumber + ":" + access_token
        
        let authorizationBase64String = convertToBase64String(str: authorization)
        
        let paymentHeaders: HTTPHeaders = [
            "Accept": "application/vnd.qiwi.v2+json",
            "Content-Type": "application/json",
            "Accept-Encoding": "gzip, deflate, compress",
            "User-Agent": "HTTPie/0.3.0",
            "Authorization": "Token " + authorizationBase64String
        ]
        
        let recieverPhoneNumber = "79099933898"
        
        let paymentParameters: Parameters = [
            "fields": [
                "account": recieverPhoneNumber,
                "prvld": "99"
            ],
            "id": "1498738039642",
            "paymentMethod": [
                "type": "Account",
                "accountId": "643"
            ],
            "sum": [
                "amount": "10",
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

        // Do any additional setup after loading the view.
    }


}


extension String {
    
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
