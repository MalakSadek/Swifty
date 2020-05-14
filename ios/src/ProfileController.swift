//
//  ProfileController.swift
//  Swifty
//
//  Created by Malak Sadek on 4/21/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit
import Firebase

//This screen displays the user's information and allows them to change their password or log out, it can be reacehed from the menu screen
class ProfileController: UIViewController {

    //UI Connections
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    //When the log out button is pressed, this function is called
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        //Signs the user out using Firebase and removes their user defaults if they confirm
        let alertVC = UIAlertController(title: "Gone So Soon?", message: "Are you sure you want to log out?", preferredStyle: .alert)
        let alertActionOkay = UIAlertAction(title: "Yes, I'm Sure", style: .default) {
            (_) in

            do {
                try  Auth.auth().signOut()
            } catch {
                print(error)
            }
            self.userDefaultsRemoveObjects()
            self.performSegue(withIdentifier: "profiletoFirstScreen", sender: self)
            
        }
        alertVC.addAction(alertActionOkay)
        let alertActionCancel = UIAlertAction(title: "No, Cancel", style: .default, handler: nil)
        alertVC.addAction(alertActionCancel)
        self.present(alertVC, animated: true, completion: nil)
        
    }

    //When the change password button is pressed, this function is called
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        
        //Sends a password reset email using Firebase and displays an alert
        Auth.auth().sendPasswordReset(withEmail: userDefaults.string(forKey: "email")!) { error in
                let alertVC = UIAlertController(title: "Password Reset", message: "Please check your email for instructions on how to reset your password.", preferredStyle: .alert)
                
                let alertActionCancel = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alertVC.addAction(alertActionCancel)
                self.present(alertVC, animated: true, completion: nil)
            
        }
    }
    
    //This function is called as soon as the view is displayed, it uses a PHP script to obtain the user's information from a MySQL Database and display it
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let db = Firestore.firestore();
        let email = UserDefaults.standard.object(forKey: "email") as! String
        db.collection("Users").whereField("Email", isEqualTo: email) .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                
                    self.nameLabel.text = (document.data()["Username"]! as? String)!
                    self.emailLabel.text = email
                    self.dateLabel.text = (document.data()["Joined"]! as? String)!
                    self.scoreLabel.text = (document.data()["Score"]! as? String)!
                    
                    if let score = Int(self.scoreLabel.text!) {
                        switch (score) {
                        case let x where x < 0:
                            self.rankLabel.text = "Underdog"
                        case 0...50:
                            self.rankLabel.text = "Novice"
                        case 51...100:
                            self.rankLabel.text = "Rookie"
                        case 101...200:
                            self.rankLabel.text = "Expert"
                        case let x where x > 200:
                            self.rankLabel.text = "Genius"
                        default:
                            self.rankLabel.text = "Unavailable right now"
                        }
                    }
                }
            }
        }
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
