
//
//  DataService.swift
//  Employee
//
//  Created by Максим on 29.06.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import Foundation
import Firebase

var firebase: DatabaseReference!

class DataService {
    
    static let dataService = DataService()
    
    private var _baseRef = Database.database().reference()
    private var _users_Ref = Database.database().reference().child("users")
    private var _profilesRef = Database.database().reference().child("profiles")


    var baseRef: DatabaseReference {
        return _baseRef
    }
    
    var usersRef: DatabaseReference {
        return _users_Ref
    }
    
    var profilesRef: DatabaseReference {
        return _profilesRef
    }
    
    var currentUserRef: DatabaseReference {
        let userUID = Auth.auth().currentUser?.uid
        return DataService.dataService.usersRef.child(userUID!)

    }

}
