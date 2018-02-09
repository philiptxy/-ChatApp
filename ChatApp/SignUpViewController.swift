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
            showAlert(withTitle: "Invalid Email Format", message: "Please input a valid email")
        } else if username.count < 3 {
            showAlert(withTitle: "Invalid Username", message: "Username must contain at least 3 characters")
        } else if password.count < 7 {
            showAlert(withTitle: "Invalid Password", message: "Password must be at least 7 characters long")
        } else if confirmPassword != password {
            showAlert(withTitle: "Passwords Do Not Match", message: "Please enter the same passwords")
        } else {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                
                //Error
                if let validError = error {
                    self.showAlert(withTitle: "ERROR", message: validError.localizedDescription)
                }
                
                
                //Successful Creation of New User
                if let validUser = user {
                    //let 
                }
                
                
                
            })
            
            
            
            
            
            
        }
        
        
        
        
        
    }



}
