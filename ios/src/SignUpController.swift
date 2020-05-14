//
//  SignUpController.swift
//  Swifty
//
//  Created by Malak Sadek on 4/20/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

//This is the sign up form page, reached by pressing the sign up button in the FirstScreenController
class SignUpController: UIViewController {

    //UI Connections
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    //This runs a PHP script to check whether the username the user has entered already exists in the database or not to prevent duplicates
    
    func checkUsername()->Bool{
        let db = Firestore.firestore();
        var unique = 1;
        db.collection("Users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if ((document.data()["Username"]! as? String)! == self.usernameField.text) {
                        unique = 0;
                    }
                }
            }
        }
        
        if (unique == 0) {
            return false
        } else {
            return true
        }
    }
    
    //Once the user has entered their information and pressed sign up, this function is called
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        
        //If none of the fields are empty
        if( !(usernameField.text?.isEmpty)! &&
            !(emailField.text?.isEmpty)! &&
            !(passwordField.text?.isEmpty)! &&
            !(confirmPasswordField.text?.isEmpty)!){
            
            //If passwords do not match
            if(passwordField.text != confirmPasswordField.text){
                displayPopUp(title: "Error", body: "Passwords do not match.")
                
            //If the email is not an AUC email
            }else if(!(emailField.text?.contains("@"))!) || (!(emailField.text?.contains("."))!){
                displayPopUp(title: "Error", body: "Invalid email.")
            }
            //If the username already exists
            else if (!checkUsername()) {
                displayPopUp(title: "Username already taken!", body: "Please choose a different username as this one already belongs to another user.")
            }
            //If there are spaces by mistake in the email, they are removed
            else{
                if(emailField.text?.contains(" "))!{
                    emailField.text?.remove(at: (emailField.text?.firstIndex(of: " "))!)
                }
                //A new user is created using Firebase
                FirebaseAuth.Auth.auth().createUser(withEmail: emailField.text!,
                                                    password: passwordField.text!)
                { (user, error) in
                    //If an error is returned, then an account already belongs to the email provided
                    if(error != nil){
                        self.displayPopUp(title: "Error", body: "Account already exists.")
                    }else{
                        
                        //If an error is not returned, the user is created and signed in and an email verification is sent to them, the user defaults are updated and the next screen is then loaded
                        Auth.auth().signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) {
                            (user, error) in
                            if let user = Auth.auth().currentUser {
                                
                                user.sendEmailVerification(completion: nil)
                                self.userDefaultsWriting(email: self.emailField.text!, password: self.passwordField.text!, name: self.usernameField.text!)
                                self.performSegue(withIdentifier: "SignUptoVerify", sender: nil)
                            }
                        }
                    }
                }
                
            }
            
        //If any of the fields are empty
        }else {
            if((usernameField.text?.isEmpty)!){
                usernameField.placeholder = "Can't be empty"
            }
            if((emailField.text?.isEmpty)!){
                emailField.placeholder = "Can't be empty"
            }
            if((passwordField.text?.isEmpty)!){
                passwordField.placeholder = "Can't be empty"
            }
            if((confirmPasswordField.text?.isEmpty)!){
                confirmPasswordField.placeholder = "Can't be empty"
            }
        }
    }
    
    //Displays an alert with the given message and title
    func displayPopUp(title:String, body:String) {
        let alertVC = UIAlertController(title: title, message: body, preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertVC.addAction(alertActionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //Updates the user defaults
    func userDefaultsWriting(email:String, password:String, name:String){
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(email, forKey: "email")
        userDefaults.set(password, forKey: "password")
        userDefaults.set(name, forKey: "name")
    }
    
    //Makes the battery and signal icons white
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //Disables autorotate so that the application does not flip
    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    //Supports only portrait orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .portrait
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

}
