//
//  SignInController.swift
//  Swifty
//
//  Created by Malak Sadek on 4/21/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit
import Firebase

//This is the sign in form page, reached by pressing the sign in button in the FirstScreenController
class SignInController: UIViewController {

    //UI Connections
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //When the forgotten password button is pressed, this function is called
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
        //Sends a password reset email using Firebase and displays an alert
        Auth.auth().sendPasswordReset(withEmail: emailField.text!) { error in
            self.displayPopUp(title: "Password Reset", body: "Please check your email for instructions on how to reset your password.")
        }
    }
    
    //When the sign in button is pressed, this function is called
    @IBAction func signInButtonPressed(_ sender: Any) {
        //Signs user in using Firebase
        FirebaseAuth.Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!)
        { (user, error) in
            if(error != nil){
                //If there is an error, then the username or password is incorrect
                self.displayPopUp(title: "Error", body: "Invalid email or password, please try again.")
            }
            else{
                //If there is no error, the user is signed in and the user defaults are updated, and the next screen is loaded
                let userDefaults = UserDefaults.standard
                
                userDefaults.set(self.emailField.text, forKey: "email")
                userDefaults.set(self.passwordField.text, forKey: "password")

                self.performSegue(withIdentifier: "signIntoMenu", sender: nil)
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
