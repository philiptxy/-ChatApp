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
            tableView.delegate = self
            tableView.separatorStyle = .none
            
            
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
        tableView.reloadData()
//        DispatchQueue.main.async {
//            let indexPath = IndexPath(row: self.chats.count-1, section: 0)
//            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//        }
//        let bottom = CGPoint(x: 0, y: tableView.contentSize.height - tableView.bounds.height)
//        tableView.setContentOffset(bottom, animated: true)

    }
    
    func createChat() {
        ref.child("chat").observeSingleEvent(of: .value) { (snapshot) in
            
            for (k,_) in snapshot.value as? [String:Any] ?? [:] {
                self.combos.append(k)
            }
            
            DispatchQueue.main.async {
                guard let currentUID = Auth.auth().currentUser?.uid,
                    let selectedUID = self.selectedContact?.uid else {return}
                guard let selectedEmail = self.selectedContact?.email else {return}
                guard let currentEmail = Auth.auth().currentUser?.email else {return}
                
                let combo = currentUID + selectedUID
                let comboInvert = selectedUID + currentUID
                
                //CHECKS IF THE CHAT HAS ALREADY BEEN CREATED, IF YES, RETURN, IF NO, CREATE NEW CHAT
                for each in self.combos {
                    if each == combo || each == comboInvert {
                        self.currentChat = each
                        self.observeChat()
                        return
                    }
                }
                
                //combos.append(combo)
                
                self.currentChat = combo
                
                self.ref.child("chat").child(self.currentChat)
                
                let participants : [String : String] = ["email1" : currentEmail, "email2" : selectedEmail]
                
                self.self.ref.child("chat").child(self.currentChat).child("participants").setValue(participants)
                
                self.observeChat()

            }
            
        }
        
//        DispatchQueue.main.async {
//            guard let currentUID = Auth.auth().currentUser?.uid,
//                let selectedUID = self.selectedContact?.uid else {return}
//            guard let selectedEmail = self.selectedContact?.email else {return}
//            guard let currentEmail = Auth.auth().currentUser?.email else {return}
//
//            let combo = currentUID + selectedUID
//            let comboInvert = selectedUID + currentUID
//
//            //CHECKS IF THE CHAT HAS ALREADY BEEN CREATED, IF YES, RETURN, IF NO, CREATE NEW CHAT
//            for each in self.combos {
//                if each == combo || each == comboInvert {
//                    self.currentChat = each
//                    return
//                }
//            }
//
//            //combos.append(combo)
//
//            self.currentChat = combo
//
//            self.ref.child("chat").child(self.currentChat)
//
//            let participants : [String : String] = ["email1" : currentEmail, "email2" : selectedEmail]
//
//            self.ref.child("chat").child(self.currentChat).child("participants").setValue(participants)
//        }
        
        
        
        
    }
    
    func observeChat() {
        ref.child("chat").child(currentChat).child("messages").queryOrdered(byChild: "timeStamp").observe(.childAdded) { (snapshot) in
            
            guard let chatDict = snapshot.value as? [String : Any] else {return}
            
            let message = Chat(uid: snapshot.key, dict: chatDict)
            
            DispatchQueue.main.async {
                self.chats.append(message)
                let indexPath = IndexPath(row: self.chats.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                
//                let bottom = CGPoint(x: 0, y: self.tableView.contentSize.height)
//                self.tableView.setContentOffset(bottom, animated: true)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ChatTableViewCell else {return UITableViewCell()}
        
//        if chats[indexPath.row].text.count < 30 {
//            tableView.rowHeight = 20.5
//        } else if chats[indexPath.row].text.count < 60 {
//            tableView.rowHeight = 41
//        } else {
//            tableView.rowHeight = 61.5
//        }
//
//        var height : CGFloat = 41
        
        cell.selectionStyle = .none
        
        let size: CGSize = chats[indexPath.row].text.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)])
        if size.width > 270 {
            if chats[indexPath.row].from == selectedContact?.email {
                cell.widthLeftLabel.constant = 300.0
            } else {
                cell.widthRightLabel.constant = 300.0
            }
        } else {
            if chats[indexPath.row].from == selectedContact?.email {
                cell.widthLeftLabel.constant = size.width + 50.0
            } else {
                cell.widthRightLabel.constant = size.width + 50.0
            }
        }
        
        view.layoutIfNeeded()

        
        
        
        if chats[indexPath.row].from == selectedContact?.email {
            cell.leftMsgLabel.text = chats[indexPath.row].text
            cell.rightMsgLabel.text = ""
        } else {
            cell.rightMsgLabel.text = chats[indexPath.row].text
            cell.leftMsgLabel.text = ""

        }
        
       // guard let position = UITableViewScrollPosition(rawValue: indexPath.row) else {return UITableViewCell()}
        
        return cell
    }
}

extension ChatViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size: CGSize = chats[indexPath.row].text.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)])
        
        if size.width < 270 {
            return 30
        } else if size.width < 540 {
            return 60
        } else {
            return 90
        }
    }
}

extension Int {
    var stringValue:String {
        return "\(self)"
    }
}
