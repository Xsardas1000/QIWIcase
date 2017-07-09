//
//  EnterCodeViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 27.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import MessageUI
import SinchVerification

/*
class EnterCodeViewController: UIViewController {
    
    var verification: Verification!
    var applicationKey = "your key"
    var check: Bool = false
    
    @IBOutlet weak var waitSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var verifyButton: UIButton!
    
    
    
    
    
    @IBAction func verify(sender: AnyObject) {
        waitSpinner.startAnimating()
        verifyButton.isEnabled = false
        statusLabel.text  = ""
        codeTextField.isEnabled = false
        print(verification)
        
        print("check = ", self.check)
        if (verification == nil) {
            print("no verify")
        }
        verification.verify(
            codeTextField.text!, completion:
            { (success:Bool, error:Error?) -> Void in
                self.waitSpinner.stopAnimating()
                self.verifyButton.isEnabled = true
                self.codeTextField.isEnabled = true
                if (success) {
                    self.statusLabel.text = "Verified"
                    
                    
                    let info = DataService.dataService.currentUserRef.child("verified")
                    
                    //write data to Firebase
                    info.setValue(true)
                    
                    
                } else {
                    self.statusLabel.text = error?.localizedDescription
                }
        });
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        waitSpinner.hidesWhenStopped = true
    }
    


}
*/
