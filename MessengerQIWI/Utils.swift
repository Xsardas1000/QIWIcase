//
//  Utils.swift
//  Employee
//
//  Created by Максим on 28.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import Foundation
import UIKit

func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = DateFormatter.Style.medium
    let dateString = dateFormatter.string(from: date)
    return dateString
}

func displayAlert(title: String, message: String, viewController: UIViewController) {
    let alert  = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: UIAlertControllerStyle.alert)
    
    let action = UIAlertAction(title: "OK",
                               style: UIAlertActionStyle.default,
                               handler: nil)
    
    alert.addAction(action)
    viewController.present(alert, animated: true, completion: nil)
}
