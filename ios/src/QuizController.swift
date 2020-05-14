//
//  QuizController.swift
//  Swifty
//
//  Created by Malak Sadek on 4/21/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

//This is the interface for the quizzes, it is called from topicController and handles all quiz logic. It inherits from UITableViewDelegate & UITableViewDataSource to execute their functions since it contains a tableView.
class QuizController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //UI Connections
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var answerTable: UITableView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    //These are passed from the previous page
    var chosenCategory:String = ""
    var chosenTopic:String = ""
    var randNum = 0
    
    //This holds the questions in the quiz and each question's answers
    var question:NSDictionary = [:]
    //This is used for the count down timer in each question
    var counter:Int = 10
    //This keeps track of the user's score
    var score:Int = 0
    //This counts the number of questions elapsed
    var i:Int = 1
    //This holds the user's selected answer for each question
    var chosenAnswer:String = ""
    
    //This function is called immediately before the view is displayed, it reads the JSON file containing the questions and fills question dictionary with the questions of the chosen topics and an array of answers for each question {question1:[ans 1, ans2, ans3, ans4] , ...}
    override func viewWillAppear(_ animated: Bool) {
        if let path = Bundle.main.path(forResource: "Questions", ofType: "JSON")
        {
            if let jsonData = NSData(contentsOfFile: path)
            {
                if let jsonResult: NSDictionary = try! JSONSerialization.jsonObject(with: jsonData as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                {
                    let category:NSDictionary = (jsonResult["Categories"] as! NSDictionary)[chosenCategory] as! NSDictionary
                    let topic:NSDictionary = (category["Topics"] as! NSDictionary)[chosenTopic] as! NSDictionary
                    
                    question = topic["Questions"] as! NSDictionary
                    questionLabel.text = question.allKeys[i-1] as? String
                    
                }
            }
        }
        
    }
    
    //This randomizes the location of the correct answer in the tableView as it is always in position 0 within the JSON file for practicality
    func shuffle() {
        //Replace a random row with row 0
        randNum = Int.random(in: 0...3)
        let temp = answerTable.cellForRow(at: [0, randNum])!.textLabel!.text
        answerTable.cellForRow(at: [0, randNum])!.textLabel!.text = answerTable.cellForRow(at: [0, 0])!.textLabel!.text
        answerTable.cellForRow(at: [0, 0])!.textLabel!.text = temp
    }
    
    //Table views can be divided into many sections, but this one only needs a single section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //The number of cells in the answers table, always equal to 4 as there are always four options
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    //This function is responsible for populating the tableView which holds the answers to the current question (question.allValues[i-1][indexPath.row] where i is the question index (up to 10), and indexPath.row is the answer index (up to 4)). Since i starts at 1 and not 0, i-1 is used.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.answerTable.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = ((question.allValues[i-1]) as! NSArray)[indexPath.row] as? String
        cell?.textLabel?.textColor = UIColor.white;
        cell?.textLabel?.textAlignment = NSTextAlignment.center;
        
        return cell!
    }
    
    //This is called when the user selects a row from the table, it assigns the chosen answer as the correspondingly indexed element in question's values (which holds the answers to the questions - the questions are the keys). Since i starts at 1 and not 0, i-1 is used.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenAnswer = ((question.allValues[i-1]) as! NSArray)[indexPath.row] as! String
    }
    
    //This function is called when the back button is pressed, it warns the user that they are exiting the quiz, and calls the topics screen if the user confirms. Other screens do not have a function for the back button as they simply go back to the previous screen, however this back button issues a warning and so needed its own function.
    @IBAction func backButtonPressed(_ sender: Any) {
        
        let alertVC = UIAlertController(title: "Warning!", message: "Are you sure you want to go back? Your score will be lost!", preferredStyle: .alert)
        
        let alertActionOkay = UIAlertAction(title: "I'm Sure", style: .default) {
            (_) in
            self.performSegue(withIdentifier: "quizToTopics", sender: nil)
        }
        
        let alertActionCancel = UIAlertAction(title: "Nevermind", style: .default, handler: nil)
        
        alertVC.addAction(alertActionOkay)
        alertVC.addAction(alertActionCancel)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    //This function is called when the answer button is pressed.
    @IBAction func answerButtonPressed(_ sender: Any) {
        //If the answer is correct, (the correct answer is always in position 0 in JSON file), 10 points are added to the score, the answer button turns green, and the correct answer label is displayed.
        if chosenAnswer == (question.allValues[i-1] as! NSArray)[randNum] as! String {
            score = score + 10
            scoreLabel.text = String(score)
            answerButton.backgroundColor = UIColor.green
            correctAnswerLabel.text = "Correct answer!"
            correctAnswerLabel.isHidden = false
            
            //After a delay of one second, the next question is displayed
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.nextQuestion()
                self.shuffle()
            })
        }
        //If the answer is incorrect, 10 points are deducted from the score, the answer button turns red, and the correct answer label is displayed.
        else {
            score = score - 10
            scoreLabel.text = String(score)
            answerButton.backgroundColor = UIColor.red
            correctAnswerLabel.text = "Correct answer is: "+((question.allValues[i-1] as! NSArray)[0] as! String)
            correctAnswerLabel.isHidden = false
            
            //After a delay of two seconds, the next question is displayed
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.nextQuestion()
                self.shuffle()
            })
        }
    }
    
    //The answer button returns orange, the timer is reset, the correct answer text is hidden again, and the next question is displayed
    func nextQuestion() {
        if self.i < self.question.allKeys.count+1 {
            if (self.i != 10) {
                self.answerTable.reloadData()
                self.i = self.i+1
                self.questionNumberLabel.text = "Question "+String(self.i)
                self.questionLabel.text = self.question.allKeys[self.i-1] as? String
                self.counter = 10
                self.progressBar.progress=Float(self.i/10)
                self.correctAnswerLabel.isHidden=true
                self.answerButton.backgroundColor=UIColor(displayP3Red: 0.9, green: 0.521, blue: 0.2, alpha: 1.0)
            } else {
                self.performSegue(withIdentifier: "quizToScore", sender: nil)
            }
        }
    }
    
    //This function is called when the view is displayed, it sets the default selected row for the picker, initializes variables and the timer, and hides the correct answer text
    override func viewDidLoad() {
        super.viewDidLoad()

        timerLabel.text = "10"
        progressBar.progress=0
        scoreLabel.text = String(score)
        correctAnswerLabel.isHidden = true
        self.answerTable.delegate = self
        self.answerTable.dataSource = self
        
        var _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        
    }
    
    //This function is called to update the timer every second (timeInterval=1)
    @objc func update() {
        //If i < the number of questions in the quiz
        if i < question.allKeys.count+1 {
            //If time has not run out for the question yet, decrement counter
            if(counter > 0) {
                timerLabel.text = String(counter-1)
                counter=counter-1
            } else {
                //If time has run out for the question, 10 points are deducted from the score, and the next question is displayed
                score = score - 10
                scoreLabel.text = String(score)
                self.nextQuestion()
                self.shuffle()
            }
        } //If i has reached the number of questions in the quiz, the quiz is finished and the end of quiz page is displayed
        else {
            performSegue(withIdentifier: "quizToScore", sender: nil)
        }
    }
    
    //This function is called before the second page is loaded, it places the value of score from this page, into the variable of the same name on the next page, essentially passing the value between pages
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //The if statement is used because there are other buttons (back, answer) who would automatically call this function before going to their respective pages, but this action does not apply to them
        if(segue.identifier == "quizToScore") {
            let destVC: ScoreController=segue.destination as! ScoreController
            destVC.score = score
        } else {
            let destVC: TopicController=segue.destination as! TopicController
            destVC.chosenCategory = chosenCategory
            destVC.chosenTopic = chosenTopic
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
