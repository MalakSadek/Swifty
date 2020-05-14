//
//  LeaderboardController.swift
//  Swifty
//
//  Created by Malak Sadek on 4/21/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//



//TODO: Make element a struct and order scores in leaderboard
//TODO: Make same mechanism in scoreController


import UIKit
import FirebaseFirestore
//This displays the leaderboard for the users with the top 5 scores, it can be reached from the menu screen and the 'end of quiz' screen. It inherits from UITableViewDelegate & UITableViewDataSource to execute their functions since it contains a tableView.

struct cell {
    var username: String?
    var email: String?
    var date: String?
    var score: String?
    
    init(username:String? = "", email:String?="", date:String?="", score:String?="") {
        self.username = username
        self.email = email
        self.date = date
        self.score = score
    }
};

class LeaderboardController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Holds the users' information
    var arrayOfCells:[cell] = []
    var count = 0;
    
    //UI Connection
    @IBOutlet weak var leaderboard: UITableView!
    
    //This function is called immediately before the view is displayed, it calls a PHP script to obtain the leaderboard information from a MySQL database and places it ranking
    override func viewWillAppear(_ animated: Bool) {
        
        leaderboard.separatorStyle = .none
        leaderboard.tableFooterView = UIView(frame: .zero)
    }
    
    //The number of sections in the leaderboard
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //The number of rows in the leaderboard, always 5 since it's the top 5 players
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    //This function is responsible for populating the tableView which holds the leaderboard
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        //Makes its cells have the class LeaderboardCell
        let cell = self.leaderboard.dequeueReusableCell(withIdentifier: "cell") as! LeaderboardCell
        
        //Ranks the users from 1 to 5
        let indexValue :String = String(format: "%d", indexPath.row+1)
        cell.rankLabel.text = indexValue
        
        //Populates the cell with the required information from ranking
        cell.usernameLabel.text = arrayOfCells[indexPath.row].username
        
        cell.dateJoinedLabel.text =  arrayOfCells[indexPath.row].date
        
        cell.scoreLabel.text =  arrayOfCells[indexPath.row].score
        
        if let scorevalue = Int(cell.scoreLabel.text!) {
            switch (scorevalue) {
            case let x where x < 0:
                cell.levelLabel.text = "Underdog"
            case 0...50:
               cell.levelLabel.text = "Novice"
            case 51...100:
                cell.levelLabel.text = "Rookie"
            case 101...200:
                cell.levelLabel.text = "Expert"
            case let x where x > 200:
                cell.levelLabel.text = "Genius"
            default:
                cell.levelLabel.text = "Unavailable right now"
            }
        }

        return cell
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
