//
//  ViewController.swift
//  ChatApp
//
//  Created by Philip Teow on 08/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        }
    }
    @IBOutlet weak var signUpButton: UIButton! 
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //skip login page if user is already logged in
        if Auth.auth().currentUser != nil {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
            
            present(vc, animated: true, completion: nil)
           
        }
        
    }

    @objc func signInButtonTapped() {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                //showError
                print("ERROR")
            }
            if user != nil {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    


}










