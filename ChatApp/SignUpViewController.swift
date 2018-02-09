//
//  SignUpViewController.swift
//  ChatApp
//
//  Created by Terence Chua on 08/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    
    
    //Function to Sign Up New User
    func signUpUser() {
        guard let username = usernameTextField.text,
        let email = emailTextField.text,
        let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text else {return}
        
        //Input Validation
        if !email.contains("@") {
//            showAlert
        }
        
        
        
        
        
    }



}
