//
//  VerifyController.swift
//  Swifty
//
//  Created by Malak Sadek on 4/21/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit
import Firebase

//This screen is displayed after the sign up screen, the user must click on the link in the verification email and then press the button on this page to continue. If this page is closed before that happens, the user's account is not created and they must sign up again.
class VerifyController: UIViewController {

    //UI Connections
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tickImage: UIImageView!
    
    //When the user presses the button, this function is called
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        //User defaults are read, they were updated in the previous sign up page and contain correct information
        let values = userDefaultsReading()
        let email = values[0]
        let password = values[1]
        let name = values[2]
        
        //The current date is obtained to be added to the database
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let currentDate = formatter.string(from: date)
        
        //The user is signed in given the obtained credentials using Firebase
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            if let user = Auth.auth().currentUser {
                
                //If the user has not clicked the link in their verficiation email
                if !user.isEmailVerified{
         
                    //Sends an alert that the user did not click the link and asks them if they want the email to be resent
                    let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to "+email+"?", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Send", style: .default) {
                        (_) in
                        //Resends the verification email
                        Auth.auth().signIn(withEmail: email, password: password) {
                            (user, error) in
                            if let user = Auth.auth().currentUser {
                                user.sendEmailVerification(completion: nil)
                            }
                        }
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    
                    alertVC.addAction(alertActionOkay)
                    alertVC.addAction(alertActionCancel)
                    self.present(alertVC, animated: true, completion: nil)
                    
                }
                //The user has clicked the link in the verification email
                else {
                    //The tick image is displayed
                    self.loadingIndicator.isHidden = true
                    self.tickImage.isHidden = false
          
                    let db = Firestore.firestore();
                    var ref: DocumentReference? = nil
                    ref = db.collection("Users").addDocument(data: [
                        "Email": email,
                        "Joined": currentDate,
                        "Score": "0",
                        "Username": name,
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                            self.performSegue(withIdentifier: "verifyToMenu", sender: nil)
                        }
                    }
                    
                }
            }
        }
    }
    
    //This function is called as soon as the view is displayed, it hides the tick image because that is only shown after the user verifies their email
    override func viewDidLoad() {
        super.viewDidLoad()
        tickImage.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    //Reads the user defaults values if they are not empty
    func userDefaultsReading()-> [String]{
        let userDefaults = UserDefaults.standard
        let email = userDefaults.string(forKey: "email")!
        let password = userDefaults.string(forKey: "password")!
        let name = userDefaults.string(forKey: "name")!
        let values = [email,password,name]
        return values
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
