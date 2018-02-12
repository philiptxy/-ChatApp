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
    var from : String = ""
  //  var username : String = ""
    var text : String = ""
    var timeStamp : Double = 0
    
    init(uid: String, dict: [String : Any]) {
        
        self.uid = uid
        from = dict["from"] as? String ?? "No Email"
      //  username = dict["username"] as? String ?? "No Username"
        text = dict["text"] as? String ?? "No Message"
        timeStamp = dict["timeStamp"] as? Double ?? 0

    }
    
    
}
