//
//  ContactsViewController.swift
//  ChatApp
//
//  Created by Philip Teow on 09/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ContactsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    @IBOutlet weak var logOutButton: UIBarButtonItem! {
        didSet {
            logOutButton.target = self
            logOutButton.action = #selector(logOutButtonTapped)
        }
    }
    
    
    var ref : DatabaseReference!
    var contacts : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        observeFireBase()
        
    }
    
    func observeFireBase() {
        ref.child("users").observe(.childAdded) { (snapshot) in
            
            guard let userDict = snapshot.value as? [String : Any] else {return}
            
            if userDict["email"] as? String != Auth.auth().currentUser?.email {
                let contact = User(uid: snapshot.key, userDict: userDict)
                
                DispatchQueue.main.async {
                    self.contacts.append(contact)
                    let indexPath = IndexPath(row: self.contacts.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
            
            //print(snapshot)
        }
        
        
        
    }
    
    @objc func logOutButtonTapped() {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }
}

extension ContactsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = contacts[indexPath.row].username
        return cell
    }
}

extension ContactsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contacts[indexPath.row]
        
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController else {return}
        vc.selectedContact = selectedContact
        
        
        navigationController?.pushViewController(vc, animated: true)
    }
}






