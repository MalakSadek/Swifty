//
//  FirstScreenController.swift
//  Swifty
//
//  Created by Malak Sadek on 4/20/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit
import Firebase

//This is the first page the user encounters when opening the application, it either goes to the menu page if the user is logged in, or displays sign up and sign in button
class FirstScreenController: UIViewController {

    //UI Connections
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var memberLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Hides the sign in and sign up buttons until it determines whether the user is logged in already or not
        signInButton.isHidden = true
        signUpButton.isHidden = true
        memberLabel.isHidden = true
        
        //Creates an instance of the current user stored on the device (using Firebase)
        let user = FirebaseAuth.Auth.auth().currentUser
        
        //The user is logged in if their user defaults are not empty and their email is verified with Firebase
        if (!userDefaultsIsEmpty() && (user?.isEmailVerified)!) {
            
            //Email and password are stored locally in the user defaults
            let values = userDefaultsReading()
            let email = values[0]
            let password = values[1]
            
            //This signs the user in using Firebase, if it fails it requires them to sign in themselves
            FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password)
            { (user, error) in
                if(error != nil){
                    print("INCORRECT view controller sign in")
                    self.userDefaultsRemoveObjects()
                    self.signInButton.isHidden = false
                    self.signUpButton.isHidden = false
                    self.memberLabel.isHidden = false
                    self.loadingIndicator.isHidden = true
                    
                }
                //If it succeeds, it goes onto the menu screen and the user is logged in
                else{
                    self.performSegue(withIdentifier: "FirstViewtoMenu", sender: nil)
                }
            }
        }
        //If the user is not logged in, the sign up and sign in buttons are displayed and the current user session is erased from Firebase
        else
        {
            let user = FirebaseAuth.Auth.auth().currentUser
            user?.delete(completion: { (error) in})
            
            self.userDefaultsRemoveObjects()
            self.signInButton.isHidden = false
            self.signUpButton.isHidden = false
            self.memberLabel.isHidden = false
            self.loadingIndicator.isHidden = true
        }
    }
    
    //Checks the user defaults for previous session information to see whether or not they are logged in
    func userDefaultsIsEmpty()-> Bool{
        let userDefaults = UserDefaults.standard
        if(userDefaults.object(forKey: "email") == nil &&
            userDefaults.object(forKey: "password") == nil &&
            userDefaults.object(forKey: "name") == nil ){
            return true
        }
        return false
    }
    
    //Reads the user defaults values if they are not empty
    func userDefaultsReading()-> [String]{
        let userDefaults = UserDefaults.standard
        let email = userDefaults.string(forKey: "email")!
        let password = userDefaults.string(forKey: "password")!
        let values = [email,password]
        return values
    }
    
    //Deletes user defaults information on the previous session if the user is no longer signed in
    func userDefaultsRemoveObjects() {
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.removeObject(forKey: "name")
        userDefaults.removeObject(forKey: "password")
        userDefaults.removeObject(forKey: "email")
        
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
    
}
