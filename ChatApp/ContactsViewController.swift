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
import FirebaseStorage
import FBSDKLoginKit

class ContactsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = 69
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
        
        //CHILD ADDED
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
            
            print(snapshot)
        }
        
        
        //CHILD CHANGED
        ref.child("users").observe(.childChanged) { (snapshot) in
            
            guard let dict = snapshot.value as? [String:Any] else {return}
            
            
            for (index, item) in self.contacts.enumerated() {
                if item.uid == snapshot.key {
                    self.contacts[index] = User(uid: snapshot.key, userDict: dict)
                    
                    DispatchQueue.main.async {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            print(snapshot.key)
        }
    }
    
    @objc func logOutButtonTapped() {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            FBSDKLoginManager().logOut()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func getImage(_ urlString: String, _ imageView: UIImageView) {
        guard let url = URL.init(string: urlString) else {return}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            if let validData = data {
                let profileImage = UIImage(data: validData)
                
                DispatchQueue.main.async {
                    imageView.image = profileImage
                }
            }
        }
        task.resume()
    }
}

extension ContactsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ContactsTableViewCell else {return UITableViewCell()}
        
        if let imageViewForCell = cell.profileImageView {
            
            cell.nameLabel.text = contacts[indexPath.row].username
            
            let picURL = contacts[indexPath.row].imageURL
            
            getImage(picURL, imageViewForCell)
        }
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






