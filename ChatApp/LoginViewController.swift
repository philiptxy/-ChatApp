//
//  ViewController.swift
//  ChatApp
//
//  Created by Philip Teow on 08/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton! {
        didSet {
            signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        }
    }
    @IBOutlet weak var signUpButton: UIButton!
    
//    @IBOutlet weak var googleSignInButton: GIDSignInButton! {
//        didSet {
//            GIDSignIn.sharedInstance().signIn()
//        }
//    }
    
    var ref : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        
        //skip login page if user is already logged in
        if Auth.auth().currentUser != nil {
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
            
            present(vc, animated: true, completion: nil)
            
        }
        
        //Facebook Login Button
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        let centerY = view.center.y
        loginButton.frame = CGRect(x: 16, y: centerY + 100, width: view.frame.width - 32, height: 50)
        view.addSubview(loginButton)
        loginButton.readPermissions = ["public_profile", "email"]
        
        //Check for existing token if they have already logged in with facebook before
        if FBSDKAccessToken.current() != nil {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
            
            self.present(vc, animated: true, completion: nil)
        }
        
        //Google
        GIDSignIn.sharedInstance().uiDelegate = self
        
        let googleButton = GIDSignInButton()
        GIDSignIn.sharedInstance().delegate = self
        googleButton.frame = CGRect(x: 16, y: centerY + 160, width: view.frame.width - 32, height: 50)
        view.addSubview(googleButton)
        
        
        
    }
    
    @objc func signInButtonTapped() {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let validError = error {
                self.showAlert(withTitle: "Error", message: validError.localizedDescription)
            }
            if user != nil {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}

extension LoginViewController : FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            
            let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email, picture"])
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                
                
                //Getting details based on FB Credentials
                if let validResult = result as? [String : Any] {
                    let id = validResult["id"]
                    let name = validResult["name"]
                    let email = validResult["email"]
                    
                    if let picture = validResult["picture"] as? [String : Any],
                        let data = picture["data"] as? [String : Any],
                        let url = data["url"] as? [String : Any] {
                        let pictureURL = picture["url"]
                    }
                    
                    //Create user ID in database
                    if let validUser = user {
                        let fbUser : [String : Any] = ["email" : email, "username" : name]
                        
                        self.ref.child("users").child(validUser.uid).setValue(fbUser)
                        
                        guard let navVC = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
                        
                        self.navigationController?.popViewController(animated: false)
                        
                        self.present(navVC, animated: false, completion: nil)
                    }
                    
                    
                    
                }
            }
            )}
    }
}

extension LoginViewController : GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let validError = error {
            print(validError.localizedDescription)
            return
        }
        
        print("Successful Google Sign In")
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }
            
            // User is signed in
            if let validUser = user,
                let email = validUser.email,
                let userName = validUser.displayName {
                                
                let googleUser : [String : String] = ["email" : email, "username" : userName]

                self.ref.child("users").child(validUser.uid).setValue(googleUser)
                
                guard let navVC = self.storyboard?.instantiateViewController(withIdentifier: "navigationController") as? UINavigationController else {return}
                
                self.navigationController?.popViewController(animated: false)
                
                self.present(navVC, animated: false, completion: nil)
            }
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
}






