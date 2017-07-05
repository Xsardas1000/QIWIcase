//
//  Request.swift
//  MessengerQIWI
//
//  Created by Максим on 02.07.17.
//  Copyright © 2017 Максим. All rights reserved.
//

import Foundation
import Firebase

class Request {
    var requestUID: String?
    var senderUID: String?
    var receiverUID: String?
    var type: RequestType?
    var comment: String?
    var time: TimeInterval?
    var accepted: Bool?
    var amount: String?
    var date: String?
    
    init(snapshot: [String: AnyObject]) {
        
        self.requestUID = snapshot["requestUID"] as? String
        self.senderUID = snapshot["senderUID"] as? String
        self.receiverUID = snapshot["receiverUID"] as? String
        let typeStr = snapshot["type"] as? String

        if typeStr == "setDebt" {
            self.type = RequestType.SetDebt
        } else {
            self.type = RequestType.AskMoney
        }
        
        self.accepted = snapshot["accepted"] as? Bool
        self.amount = snapshot["amount"] as? String
        self.comment = snapshot["comment"] as? String
        self.time = snapshot["time"] as? TimeInterval
        self.date = snapshot["date"] as? String
    }
    
    enum RequestType {
        case SetDebt
        case AskMoney
    }
}
