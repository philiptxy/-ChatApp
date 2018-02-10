//
//  Chat.swift
//  ChatApp
//
//  Created by Terence Chua on 09/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import Foundation

class Chat {
    var uid : String = ""
    var email : String = ""
    var username : String = ""
    var msg : String = ""
    var timestamp : Double = 0
    
    init(uid: String, dict: [String : Any]) {
        
        self.uid = uid
        email = dict["email"] as? String ?? "No Email"
        username = dict["username"] as? String ?? "No Username"
        msg = dict["msg"] as? String ?? "No Message"
        timestamp = dict["timestamp"] as? Double ?? 0

    }
    
    
}
