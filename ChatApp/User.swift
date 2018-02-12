//
//  User.swift
//  ChatApp
//
//  Created by Philip Teow on 10/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import Foundation

class User {
    var uid : String = ""
    var email : String = ""
    var username : String = ""
    var imageURL : String = ""
    
    init(uid: String, userDict: [String : Any]){
        self.uid = uid
        self.email = userDict["email"] as? String ?? "No email"
        self.username = userDict["username"] as? String ?? "No username"
        self.imageURL = userDict["profilePicURL"] as? String ?? "No URL"
    }
    
}
