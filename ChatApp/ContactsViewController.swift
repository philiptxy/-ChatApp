//
//  ContactsViewController.swift
//  ChatApp
//
//  Created by Philip Teow on 09/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth

class ContactsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var logOutButton: UIBarButtonItem! {
        didSet {
            logOutButton.target = self
            logOutButton.action = #selector(logOutButtonTapped)
        }
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

    }

    @objc func logOutButtonTapped() {
        do{
            try Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            
        }
    }


}
