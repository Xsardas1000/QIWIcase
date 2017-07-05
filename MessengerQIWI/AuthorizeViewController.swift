//
//  AuthorizeViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 26.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import MessageUI
import SinchVerification
import Firebase

class AuthorizeViewController: UIViewController, UITextFieldDelegate {
    
    var verification: Verification!
    var applicationKey = "9b5f8dc1-25de-413c-8e72-2b59cc33b72f"

    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var codeTextField: UITextField!
    
    @IBOutlet weak var waitSpinner: UIActivityIndicatorView!
    
    @IBOutlet weak var getCodeButton: UIButton!
    
    @IBOutlet weak var verifyButton: UIButton!
    
    /*  disable the UI while waiting for the call. This is important to do because if the user starts multiple verification requests they might get stuck in a loop where they never get verified and the phone just keeps ringing. I implemented a timeout for 30 seconds before I consider it to be a fail and the user can try again.
    */
    
    func disableUI(_ disable: Bool){
        var alpha:CGFloat = 1.0
        if (disable) {
            alpha = 0.5
            phoneNumberTextField.resignFirstResponder()
            waitSpinner.startAnimating()
            self.statusLabel.text=""
            let delayTime =
                DispatchTime.now() +
                    Double(Int64(30 * Double(NSEC_PER_SEC)))
                    / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(
                deadline: delayTime, execute:
                { () -> Void in
                    self.disableUI(false)
            });
        }
        else{
            self.phoneNumberTextField.becomeFirstResponder()
            self.waitSpinner.stopAnimating()
            
        }
        self.phoneNumberTextField.isEnabled = !disable
        self.getCodeButton.isEnabled = !disable
        self.getCodeButton.alpha = alpha
    }
    
    @IBAction func smsVerification(_ sender: AnyObject) {
        self.disableUI(true);
        verification = SMSVerification(applicationKey, phoneNumber: phoneNumberTextField.text!)
        print("Trying to authorize with phone number: \(phoneNumberTextField.text!)")
        
        print("phoneNumber:", phoneNumberTextField.text!)
        verification.initiate { (result: InitiationResult, error:Error?) -> Void in
            self.disableUI(false)
            if (result.success){
                print("success in authorization")
                self.statusLabel.text = "Введите код"
                //self.performSegue(withIdentifier: "enterPin", sender: sender)
                
            } else {
                self.statusLabel.text = error?.localizedDescription
            }
        }
    }
    
    @IBAction func verify(sender: AnyObject) {
        waitSpinner.startAnimating()
        verifyButton.isEnabled = false
        statusLabel.text  = ""
        codeTextField.isEnabled = false
        print("verfification = ", verification)
        
        
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
                    
                    //возвращаемся обратно
                    self.dismiss(animated: true, completion: nil)
                    
                    
                } else {
                    self.statusLabel.text = error?.localizedDescription
                }
        });
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "enterPin") {
            //let enterCodeVC = segue.destination as! EnterCodeViewController
            //enterCodeVC.verification = self.verification
            
            
            let navVC = segue.destination as? UINavigationController
            
            let enterCodeVC = navVC?.topViewController as! EnterCodeViewController
            enterCodeVC.verification = self.verification
            
            if self.verification == nil {
                print("ver is nil")
            }
            enterCodeVC.check = true
            

            
            print("verification in auth = ", enterCodeVC.verification)
            
            //filling database
            
            //add firebase child node
            
            print("writing in authorize")
            
            let info = DataService.dataService.currentUserRef.child("phone")
            
            //write data to Firebase
            info.setValue(phoneNumberTextField.text)
        }
        
    }
    
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        phoneNumberTextField.delegate = self
        phoneNumberTextField.keyboardType = .numbersAndPunctuation
        phoneNumberTextField.placeholder = "Phone number"
        phoneNumberTextField.keyboardAppearance = .dark
        phoneNumberTextField.textAlignment = .center
        
        waitSpinner.hidesWhenStopped = true
        
    }


    //MARK: - UITextFieldDelegate

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.text!)
        print("textFieldDidBeginEditing")

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = range.range(for: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.characters.count <= 12
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = range.range(for: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return changedText.characters.count <= 12
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("textFieldShouldClear")
        return true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing")
        
        return true
    }

    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        print("textFieldDidEndEditing")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        return true
    }
}




extension NSRange {
    func range(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}






