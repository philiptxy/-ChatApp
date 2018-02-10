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
    
    var chats : [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        observeChat()
    }
    
    func observeChat() {
        ref.child("chat").queryOrdered(byChild: "timestamp").observe(.childAdded) { (snapshot) in
            
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
        
        let userMsg : [String : Any] = ["email" : currentEmail, "msg" : inputText, "timestamp" : Date().timeIntervalSince1970]
        
        ref.child("chat").childByAutoId().setValue(userMsg)
    }


}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = chats[indexPath.row].msg
        
        return cell
    }
}
