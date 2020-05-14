//
//  MenuController.swift
//  Swifty
//
//  Created by Malak Sadek on 4/21/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit
import FirebaseFirestore
//This is the main menu, it is displayed straight away when the user is logged in, or after they sign in or sign up. They return to it once they have finished a quiz. It inherits from UICollectionViewDelegate & UICollectionViewDataSource to execute their functions since it contains a collectionView.
class MenuController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //UI Connections
    @IBOutlet weak var categories: UICollectionView!
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    var arrayOfCells:[cell] = []
    var count = 0;
    
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
                self.performSegue(withIdentifier: "menutoleaderboard", sender: nil)
            }
        }
    }
    //Holds the different categories of quizzes
    var category:NSDictionary = [:]
    //Holds the user's chosen category to be sent to the following page
    var chosenCategory:String = ""

    //This function is called immediately before the view is displayed, it reads the JSON file containing the questions and fills category with the categories
    override func viewWillAppear(_ animated: Bool) {
        profileButton.setTitle("Profile", for: .normal)
        leaderboardButton.setTitle("Leaderboard", for: .normal)
        if let path = Bundle.main.path(forResource: "Questions", ofType: "JSON")
        {
            if let jsonData = NSData(contentsOfFile: path)
            {
                if let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                {
                    category = (jsonResult["Categories"] as! NSDictionary) 
                }
            }
        }
        
    }
    
    //Collection views can be divided into many sections, but this one only needs a single section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //The number of cells in the categories collection, equal to the number of elements in collection which are read from Questions.JSON (dynamic number)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.allKeys.count+2
    }
    
    //This function is responsible for populating the collectionView which holds the categories with the right icons
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.categories.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if(indexPath.row == 0) {
            cell.backgroundImage.image = UIImage(named: "scifiBackground")
        } else if (indexPath.row == 1) {
            cell.backgroundImage.image = UIImage(named: "comicBackground")
        } else {
            cell.backgroundImage.image = UIImage(named: "comingSoonImage")
        }
        return cell
    }
    
    //This function is called when a user selects a cell in the collection, it sets chosenCategory and calls the following page
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row == 0) || (indexPath.row == 1) {
            chosenCategory = category.allKeys[indexPath.row] as! String
            self.performSegue(withIdentifier: "categoryToTopic", sender: nil)
        }
    }
    
    //This function is called before the second page is loaded, it places the value of chosenCategory from this page, into the variable of the same name on the next page, essentially passing the value between pages
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //The if statement is used because there are other buttons (leaderboard & profile) who would automatically call this function before going to their respective pages, but this action does not apply to them
        if (segue.identifier == "categoryToTopic") {
            let destVC: TopicController=segue.destination as! TopicController
            destVC.chosenCategory = chosenCategory
        }
        else if (segue.identifier == "menutoleaderboard") {
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
