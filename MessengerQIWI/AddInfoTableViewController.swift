//
//  AddInfoTableViewController.swift
//  MessengerQIWI
//
//  Created by Максим on 30.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import UIKit
import Firebase

class AddInfoTableViewController: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var dateOfBirthTimeInterval: TimeInterval = 0
    
    var imagePicker = UIImagePickerController()
    
    @IBAction func tapCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSave(_ sender: UIBarButtonItem) {
        let name = nameTextField.text
        
        var data: Data = Data()
        
        if let image = photoImageView.image {
            data = UIImageJPEGRepresentation(image, 0.1)!
        }
        
        let base64String =
            data.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        
        
        let newInfo: NSDictionary = ["name": name!, "dob": dateOfBirthTimeInterval, "photo": base64String]
        
        //add firebase child node

        let info = DataService.dataService.currentUserRef.child("info")
        
        //write data to Firebase
        info.setValue(newInfo)
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    
    
    
    @IBAction func datePicked(sender: AnyObject) {
        dateOfBirthTimeInterval = datePicker.date.timeIntervalSinceNow
        dateOfBirthTextField.text = formatDate(date: datePicker.date)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 { //нулевая ячейка
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                //если есть камера
                imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                present(imagePicker, animated: true, completion: nil)
                
            } else {
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                present(imagePicker, animated: true, completion: nil)
            }
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}

extension AddInfoTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

