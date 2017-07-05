//
//  User.swift
//  MessengerQIWI
//
//  Created by Максим on 29.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import Foundation
import Firebase

class UserInfo {
    var uid: String?
    var friends: [String: AnyObject]?
    var info: [String: AnyObject]?
    var email: String?
    var phone: String?
    var token: String?
    var username: String?
    var verified: Bool?
    
    
    init(snapshot: [String: AnyObject], uid: String) {
        self.uid = uid
        self.friends = snapshot["friends"] as? [String: AnyObject]
        self.info = snapshot["info"] as? [String: AnyObject]
        self.username = snapshot["username"] as? String
        self.email = snapshot["email"] as? String
        self.token = snapshot["token"] as? String
        self.verified = snapshot["verified"] as? Bool
        self.phone = snapshot["phone"] as? String
    }
}
