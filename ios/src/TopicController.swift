//
//  TopicController.swift
//  Swifty
//
//  Created by Malak Sadek on 4/21/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

//This page has a list of the topics available for the category chosen in menuController and is called from menuController. It inherits from UICollectionViewDelegate & UICollectionViewDataSource to execute their functions since it contains a collectionView.
class TopicController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
        
    //UI Connections
    @IBOutlet weak var topics: UICollectionView!
    @IBOutlet weak var categoriesLabel: UILabel!
    
    //This is passed from the previous page
    var chosenCategory:String = ""
    //Holds the user's chosen topic to be sent to the following page
    var chosenTopic:String = ""
    //Holds the different topics of quizzes for the chosen category
    var topic:NSDictionary = [:]
    
    //This function is called immediately before the view is displayed, it reads the JSON file containing the questions and fills topic with the topics of the chosen category
    override func viewWillAppear(_ animated: Bool) {
        if let path = Bundle.main.path(forResource: "Questions", ofType: "JSON")
        {
            if let jsonData = NSData(contentsOfFile: path)
            {
                if let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                {
                    let category:NSDictionary = (jsonResult["Categories"] as! NSDictionary)[chosenCategory] as! NSDictionary
                    topic = category["Topics"] as! NSDictionary
                }
            }
        }
        
        categoriesLabel.text = chosenCategory
    }
    
    //This function is responsible for populating the collectionView which holds the topics with the right icons
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.topics.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if(chosenCategory == "SciFi") {
            if(indexPath.row == 0) {
                cell.backgroundImage.image = UIImage(named: "starTrekBackground")
            } else if (indexPath.row == 1) {
                cell.backgroundImage.image = UIImage(named: "menInBlackBackground")
            } else {
                cell.backgroundImage.image = UIImage(named: "starWarsBackground")
            }

        } else if (chosenCategory == "Comics") {
            if(indexPath.row == 0) {
                cell.backgroundImage.image = UIImage(named: "avengersBackground")
            } else if (indexPath.row == 1) {
                cell.backgroundImage.image = UIImage(named: "xmenBackground")
            }
        }

        return cell
    }

    //Collection views can be divided into many sections, but this one only needs a single section
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //The number of cells in the topics collection, equal to the number of elements in topic which are read from Questions.JSON (dynamic number)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topic.allKeys.count
    }
    
    //This function is called when a user selects a cell in the collection, it sets chosenTopic and calls the following page if the user confirms
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alertVC = UIAlertController(title: topic.allKeys[indexPath.row] as? String, message: "Are you sure you want to start this quiz?", preferredStyle: .alert)
        
        let alertActionOkay = UIAlertAction(title: "Let's Do It!", style: .default) {
            (_) in
            self.chosenTopic = self.topic.allKeys[indexPath.row] as! String
            self.performSegue(withIdentifier: "startQuiz", sender: nil)
        }
        
        let alertActionCancel = UIAlertAction(title: "I changed my mind.", style: .default) {
            (_) in
            self.topics.deselectItem(at: indexPath, animated: false)
        }
        
        alertVC.addAction(alertActionOkay)
        alertVC.addAction(alertActionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
     //This function is called before the second page is loaded, it places the values of chosenCategory and chosenTopic from this page, into the variables of the same name on the next page, essentially passing the values between pages
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        //The if statement is used because there are other buttons (back) who would automatically call this function before going to their respective pages, but this action does not apply to them
        if (segue.identifier == "startQuiz") {
            let destVC: QuizController=segue.destination as! QuizController
            destVC.chosenTopic = chosenTopic
            destVC.chosenCategory = chosenCategory
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
