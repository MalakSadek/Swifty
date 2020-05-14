//
//  ScoreController.swift
//  Swifty
//
//  Created by Malak Sadek on 4/21/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit
import FirebaseFirestore
//This displays the user's score after a quiz and is reached from the quizController, it gives the user the option to return to the main menu or view the updated leaderboard
class ScoreController: UIViewController {

    //UI Connection
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var scoreMessage: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    //This is passed from the previous page
    var score:Int = 0
    var arrayOfCells:[cell] = []
    var count = 0
    
    //This function is called when the view is displayed, the score label is updated with the score sent from the quiz page and a PHP script is used to update the score of the user in the MySQL Database
    override func viewDidLoad() {
        super.viewDidLoad()

        scoreLabel.text=String(score)
        leaderboardButton.isEnabled=false
        menuButton.isEnabled=false
        if (score <= 0) {
            scoreMessage.text = "Better luck next time! Your Score is:"
        } else {
            scoreMessage.text = "Great Job! Your Score is:"
        }
        let db = Firestore.firestore();
        let email = UserDefaults.standard.object(forKey: "email") as! String
        var oldscore = ""
        db.collection("Users").whereField("Email", isEqualTo: email) .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    oldscore = (document.data()["Score"]! as? String)!
                    
                    var newscore = Int(oldscore)! + self.score
                    
                    //Add popup for level
                    if(Int(oldscore)! < 0) {
                        
                        if (Int(newscore) > 50) && (Int(newscore) < 101) {
                            
                              self.displayPopUp(title: "Congratulations", body: "You've been promoted from Underdog to Rookie")
                            
                        } else if (Int(newscore) > 100) && (Int(newscore) < 201) {
                            
                              self.displayPopUp(title: "Congratulations", body: "You've been promoted from Underdog to Expert")
                            
                        } else if (Int(newscore) > 200) {
                            
                              self.displayPopUp(title: "Congratulations", body: "You've been promoted from Underdog to y")
                            
                        } else if (Int(newscore) > 0) && (Int(newscore) < 51) {
                            
                              self.displayPopUp(title: "Congratulations", body: "You've been promoted from Underdog to Novice")
                            
                        } else if (Int(newscore) > 200) {
                            
                              self.displayPopUp(title: "Congratulations", body: "You've been promoted from Underdog to Genius")
                            
                        }
                        
                    } else if (Int(oldscore)! > 0) && (Int(oldscore)! < 51) {
                        
                        if (Int(newscore) > 50) && (Int(newscore) < 101) {
                            
                              self.displayPopUp(title: "Congratulations", body: "You've been promoted from Novice to Rookie")
                            
                        } else if (Int(newscore) > 100) && (Int(newscore) < 201) {
                            
                              self.displayPopUp(title: "Congratulations", body: "You've been promoted from Novice to Expert")
                            
                        } else if (Int(newscore) > 200) {
                            
                              self.displayPopUp(title: "Congratulations", body: "You've been promoted from Novice to Genius")
                            
                        } else if (Int(newscore) < 0) {
                            
                              self.displayPopUp(title: "Too bad!", body: "You've been demoted from Novice to Underdog")
                            
                        }
                        
                    } else if (Int(oldscore)! > 50) && (Int(oldscore)! < 101){
                        
                        if (Int(newscore) > 0) && (Int(newscore) < 51) {
                            
                              self.displayPopUp(title: "Too bad!", body: "You've been demoted from Rookie to Novice")
                            
                        } else if (Int(newscore) > 100) && (Int(newscore) < 201) {
                            
                              self.displayPopUp(title: "Congratulations", body: "You've been promoted from Rookie to Expert")
                            
                        } else if (Int(newscore) > 200) {
                            
                              self.displayPopUp(title: "Congratulations", body: "You've been promoted from Rookie to Genius")
                            
                        } else if (Int(newscore) < 0) {
                         
                              self.displayPopUp(title: "Too bad", body: "You've been demoted from Rookie to Underdog")
                            
                        }
                        
                    } else if (Int(oldscore)! > 100) && (Int(oldscore)! < 201){
                        
                        if (Int(newscore) > 0) && (Int(newscore) < 51) {
                            
                              self.displayPopUp(title: "Too bad", body: "You've been demoted from Expert to Novice")
                            
                        } else if (Int(newscore) > 50) && (Int(newscore) < 101) {
                            
                              self.displayPopUp(title: "Too bad", body: "You've been demoted from Expert to Rookie")
                            
                        } else if (Int(newscore) > 200) {
                            
                              self.displayPopUp(title: "Congratulations", body: "You've been promoted from Expert to Genius")
                            
                        } else if (Int(newscore) < 0) {
                            
                              self.displayPopUp(title: "Too bad", body: "You've been demoted from Expert to Underdog")
                            
                        }
                        
                    } else if (Int(oldscore)! > 200) {
                        
                        if (Int(newscore) > 50) && (Int(newscore) < 101) {
                            
                              self.displayPopUp(title: "Too bad", body: "You've been demoted from Genius to Rookie")
                            
                        } else if (Int(newscore) > 100) && (Int(newscore) < 201) {
                            
                              self.displayPopUp(title: "Too bad", body: "You've been demoted from Genius to Expert")
                            
                        } else if (Int(newscore) > 0) && (Int(newscore) < 51) {
                            
                              self.displayPopUp(title: "Too bad", body: "You've been demoted from Genius to Novice")
                            
                        } else if (Int(newscore) < 0) {
                            
                              self.displayPopUp(title: "Too bad", body: "You've been demoted from Genius to Underdog")
                        }
                        
                    }                    
                    db.collection("Users").document(document.documentID).setData([ "Score": String(newscore) ], merge: true)
                }
                
                self.leaderboardButton.isEnabled=true
                self.menuButton.isEnabled=true
            }
        }
    }
    

    @IBAction func leaderboardButtonPressed(_ sender: Any) {
        let db = Firestore.firestore();
        
        db.collection("Users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var mycell = cell(username: (document.data()["Username"]! as? String)!,email: (document.data()["Email"]! as? String)!, date: (document.data()["Joined"]! as? String)! ,score: (document.data()["Score"]! as? String)!)
                    
                    self.arrayOfCells.append(mycell)
                    
                    self.arrayOfCells.sort { (lhs: cell, rhs: cell) -> Bool in
                        // you can have additional code here
                        return Int(lhs.score!)! > Int(rhs.score!)!
                    }
                    self.count = self.count + 1
                }
                self.performSegue(withIdentifier: "scoretoleaderboard", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //The if statement is used because there are other buttons (leaderboard & profile) who would automatically call this function before going to their respective pages, but this action does not apply to them
            if (segue.identifier == "scoretoleaderboard") {
                let destVC: LeaderboardController=segue.destination as! LeaderboardController
                destVC.arrayOfCells = self.arrayOfCells
            }
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
