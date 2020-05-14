//
//  LeaderboardCell.swift
//  Swifty
//
//  Created by Malak Sadek on 4/21/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

//This class models a cell in the leaderboard table
class LeaderboardCell: UITableViewCell {

    //UI Connections
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dateJoinedLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
}
