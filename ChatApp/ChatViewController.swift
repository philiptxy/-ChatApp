//
//  ChatViewController.swift
//  ChatApp
//
//  Created by Philip Teow on 09/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var msgTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        }
    }
    
    var ref : DatabaseReference!
    var selectedContact : User?
    var chats : [Chat] = []
    var currentChat : String = ""
    var combos : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        createChat()
        observeChat()
    }
    
    func createChat() {
        ref.child("chats").observeSingleEvent(of: .value) { (snapshot) in
            self.combos.append(snapshot.key)
        }
        
        
        guard let currentUID = Auth.auth().currentUser?.uid,
            let selectedUID = selectedContact?.uid else {return}
        guard let selectedEmail = selectedContact?.email else {return}
        guard let currentEmail = Auth.auth().currentUser?.email else {return}
        
        let combo = currentUID + selectedUID
        let comboInvert = selectedUID + currentUID
        
        //CHECKS IF THE CHAT HAS ALREADY BEEN CREATED, IF YES, RETURN, IF NO, CREATE NEW CHAT
        for each in combos {
            if each == combo || each == comboInvert {
                currentChat = each
                return
            }
        }
        
        //combos.append(combo)
        
        currentChat = combo
        
        ref.child("chat").child(currentChat)
        
        let participants : [String : String] = ["email1" : currentEmail, "email2" : selectedEmail]
        
        ref.child("chat").child(currentChat).child("participants").setValue(participants)
        
        
        
    }
    
    func observeChat() {
        ref.child("chat").child(currentChat).child("messages").queryOrdered(byChild: "timeStamp").observe(.childAdded) { (snapshot) in
            
            guard let chatDict = snapshot.value as? [String : Any] else {return}
            
            let message = Chat(uid: snapshot.key, dict: chatDict)
            
            DispatchQueue.main.async {
                self.chats.append(message)
                let indexPath = IndexPath(row: self.chats.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
            
        }
    }
    
    @objc func sendMessage() {
        guard let inputText = msgTextField.text else {return}
        guard let currentEmail = Auth.auth().currentUser?.email else {return}
        
        let currentDateTime = Date()
        
        // get the user's calendar
        let userCalendar = Calendar.current
        
        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]
        
        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
        
        guard let year = dateTimeComponents.year?.stringValue,
            let month = dateTimeComponents.month?.stringValue,
            let day = dateTimeComponents.day?.stringValue,
            let hour = dateTimeComponents.hour?.stringValue,
            let minute = dateTimeComponents.minute?.stringValue else {return}
        
        let currentTime : String = year + month + day + hour + minute
        
        guard let currentTimeInt = Int(currentTime) else {return}
        
        let currentMessage = ref.child("chat").child(currentChat).child("messages").childByAutoId()
        
        let messageIdPlaceholder : [String : Any] = ["text" : inputText, "from" : currentEmail, "timeStamp" : currentTimeInt]
        
        ref.child("chat").child(currentChat).child("messages").child(currentMessage.key).setValue(messageIdPlaceholder)
        
        msgTextField.text = ""
        
    }
    
    
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = chats[indexPath.row].text
        
        return cell
    }
}

extension Int {
    var stringValue:String {
        return "\(self)"
    }
}
