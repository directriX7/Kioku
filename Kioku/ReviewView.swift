//
//  ReviewView.swift
//  Kioku
//
//  Created by Archie on 20/05/2017.
//  Copyright © 2017 bestgroup. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ReviewView : UIViewController {

    var username = ""
    var deckName = ""
    var totalDeckCard: Int = 0
    
    var idList = [Int]()
    var wordList = [String]()
    var correctChoiceLocation = ""
    var correctChoice = ""
    var totalReview = 0
    var reviewProgressCount: Int = 0
    var correctIndex: Int = 0
    var randChoice = [String]()
    var player: AVAudioPlayer?
    
    
    
    @IBOutlet weak var defLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    var alertController: UIAlertController!
    var defaultAction: UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idList = getIDstoReview(user: username, deck: deckName)
        totalReview = reviewCount(user: username, deck: deckName)
        
        progressLabel.text = "\(reviewProgressCount)/\(totalReview) words reviewed"
        
        correctIndex = idList[reviewProgressCount]
        
        randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
        prepareQuestion(id: correctIndex, choices: randChoice)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    let db = FMDBDataModel()
    // main logic
    
    func playSound() {
        // Fetch the Sound data set.
        if let asset = NSDataAsset(name:"Click"){
            
            do {
                // Use NSDataAsset's data property to access the audio file stored in Sound.
                player = try AVAudioPlayer(data:asset.data, fileTypeHint:"mp3")
                // Play the above sound file.
                player?.play()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }

    @IBOutlet weak var button1label: UIButton!
    @IBOutlet weak var button2label: UIButton!
    @IBOutlet weak var button3label: UIButton!
    @IBOutlet weak var button4label: UIButton!
    @IBOutlet weak var button5label: UIButton!
    @IBOutlet weak var button6label: UIButton!
    
    
    //MARK:
    //MARK: ButtonFunctions
    @IBAction func button1(_ sender: UIButton) {
        playSound()
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        if button1label.titleLabel?.text == correctChoice {
            
            updateStatusToReviewed()
            reviewProgressCount += 1
            button1label.layer.borderColor = UIColor (red: 104/255.0, green: 196/255.0, blue: 115/255.0, alpha: 1.0).cgColor
            button1label.layer.borderWidth = 2.0
            progressLabel.text = "\(reviewProgressCount)/\(totalReview) words reviewed"
            
            // if review still hasn't ended
            if reviewProgressCount != totalReview {
                
                correctIndex = idList[reviewProgressCount]
                randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
                
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
                }
            }
            else {
                finishReview()
            }
        }
        else {
            // should move to the question to the end?
            // this what happens if player clicked wrong
            button1label.layer.borderColor = UIColor (red: 229/255.0, green: 57/255.0, blue: 54/255.0, alpha: 1.0).cgColor
            button1label.layer.borderWidth = 2.0
            // place alert here
            alertController = UIAlertController(title: "Wrong Answer", message: "Wrong answer, the correct answer is \(correctChoice)", preferredStyle: .alert)
            defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
            placeWrongAnswerToEndQueue()
            
            correctIndex = idList[reviewProgressCount]
            randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
            
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
            }
            
            
        }
    }
    
    @IBAction func button2(_ sender: UIButton) {
        playSound()

        let deadlineTime = DispatchTime.now() + .seconds(1)
        
        if button2label.titleLabel?.text == correctChoice {
            // move on to next question call prepareQuestion
            
            
            
            updateStatusToReviewed()
            reviewProgressCount += 1
            button2label.layer.borderColor = UIColor (red: 104/255.0, green: 196/255.0, blue: 115/255.0, alpha: 1.0).cgColor
            button2label.layer.borderWidth = 2.0
            progressLabel.text = "\(reviewProgressCount)/\(totalReview) words reviewed"
            
            // if review still hasn't ended
            if reviewProgressCount != totalReview {
                
                correctIndex = idList[reviewProgressCount]
                randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
                
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
                }
            }
            else {
                finishReview()
            }

        }
        else {
            // place alert here
            button2label.layer.borderColor = UIColor (red: 229/255.0, green: 57/255.0, blue: 54/255.0, alpha: 1.0).cgColor
            button2label.layer.borderWidth = 2.0
            alertController = UIAlertController(title: "Wrong Answer", message: "Wrong answer, the correct answer is \(correctChoice)", preferredStyle: .alert)
            defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
            placeWrongAnswerToEndQueue()
            
            correctIndex = idList[reviewProgressCount]
            randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
            
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
            }
        }
    }
    
    @IBAction func button3(_ sender: UIButton) {
        playSound()

        let deadlineTime = DispatchTime.now() + .seconds(1)
        if button3label.titleLabel?.text == correctChoice {
            // move on to next question call prepareQuestion
            button3label.layer.borderColor = UIColor (red: 104/255.0, green: 196/255.0, blue: 115/255.0, alpha: 1.0).cgColor
            button3label.layer.borderWidth = 2.0
            
            updateStatusToReviewed()
            reviewProgressCount += 1
            progressLabel.text = "\(reviewProgressCount)/\(totalReview) words reviewed"
            
            // if review still hasn't ended
            if reviewProgressCount != totalReview {
                
                correctIndex = idList[reviewProgressCount]
                randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
                
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
                }
            }
            else {
                finishReview()
            }
        }
        else {
            // place alert here
            button3label.layer.borderColor = UIColor (red: 229/255.0, green: 57/255.0, blue: 54/255.0, alpha: 1.0).cgColor
            button3label.layer.borderWidth = 2.0
            
            alertController = UIAlertController(title: "Wrong Answer", message: "Wrong answer, the correct answer is \(correctChoice)", preferredStyle: .alert)
            defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
            placeWrongAnswerToEndQueue()
            
            correctIndex = idList[reviewProgressCount]
            randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
            
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
            }
        }
    }
    
    @IBAction func button4(_ sender: UIButton) {
        playSound()

        let deadlineTime = DispatchTime.now() + .seconds(1)
        
        if button4label.titleLabel?.text == correctChoice {
            // move on to next question call prepareQuestion
            
            button4label.layer.borderColor = UIColor (red: 104/255.0, green: 196/255.0, blue: 115/255.0, alpha: 1.0).cgColor
            button4label.layer.borderWidth = 2.0
            
            updateStatusToReviewed()
            reviewProgressCount += 1
            progressLabel.text = "\(reviewProgressCount)/\(totalReview) words reviewed"
            
            // if review still hasn't ended
            if reviewProgressCount != totalReview {
                
                correctIndex = idList[reviewProgressCount]
                randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
                
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
                }            }
            else {
                finishReview()
            }

        }
        else {
            // place alert here
            button4label.layer.borderColor = UIColor (red: 229/255.0, green: 57/255.0, blue: 54/255.0, alpha: 1.0).cgColor
            button4label.layer.borderWidth = 2.0
            
            alertController = UIAlertController(title: "Wrong Answer", message: "Wrong answer, the correct answer is \(correctChoice)", preferredStyle: .alert)
            defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
            placeWrongAnswerToEndQueue()
            
            correctIndex = idList[reviewProgressCount]
            randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
            
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
            }
        }
    }
    
    @IBAction func button5(_ sender: Any) {
        playSound()

        let deadlineTime = DispatchTime.now() + .seconds(1)
        
        if button5label.titleLabel?.text == correctChoice {
            // move on to next question call prepareQuestion
            button5label.layer.borderColor = UIColor (red: 104/255.0, green: 196/255.0, blue: 115/255.0, alpha: 1.0).cgColor
            button5label.layer.borderWidth = 2.0
            
            
            updateStatusToReviewed()
            reviewProgressCount += 1
            progressLabel.text = "\(reviewProgressCount)/\(totalReview) words reviewed"
            
            // if review still hasn't ended
            if reviewProgressCount != totalReview {
                
                correctIndex = idList[reviewProgressCount]
                randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
                
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
                }
            }
            else {
                finishReview()
            }
        }
        else {
            // place alert here
            button5label.layer.borderColor = UIColor (red: 229/255.0, green: 57/255.0, blue: 54/255.0, alpha: 1.0).cgColor
            button5label.layer.borderWidth = 2.0
            
            alertController = UIAlertController(title: "Wrong Answer", message: "Wrong answer, the correct answer is \(correctChoice)", preferredStyle: .alert)
            defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
            placeWrongAnswerToEndQueue()
            
            correctIndex = idList[reviewProgressCount]
            randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
            
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
            }
        }
    }
    
    @IBAction func button6(_ sender: UIButton) {
        playSound()

        let deadlineTime = DispatchTime.now() + .seconds(1)
        
        if button6label.titleLabel?.text == correctChoice {
            
            // move on to next question call prepareQuestion
            button6label.layer.borderColor = UIColor (red: 104/255.0, green: 196/255.0, blue: 115/255.0, alpha: 1.0).cgColor
            button6label.layer.borderWidth = 2.0
            
            updateStatusToReviewed()
            reviewProgressCount += 1
            progressLabel.text = "\(reviewProgressCount)/\(totalReview) words reviewed"
            
            // if review still hasn't ended
            if reviewProgressCount != totalReview {
                
                correctIndex = idList[reviewProgressCount]
                randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
                
                
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                    self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
                }
            }
            else {
                finishReview()
            }
        }
        else {
            // place alert here
            button6label.layer.borderColor = UIColor (red: 229/255.0, green: 57/255.0, blue: 54/255.0, alpha: 1.0).cgColor
            button6label.layer.borderWidth = 2.0
            
            alertController = UIAlertController(title: "Wrong Answer", message: "Wrong answer, the correct answer is \(correctChoice)", preferredStyle: .alert)
            defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
            
            placeWrongAnswerToEndQueue()
            
            correctIndex = idList[reviewProgressCount]
            randChoice = getRandomChoices(deck: deckName, deckID: correctIndex)
            
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.prepareQuestion(id: self.correctIndex, choices: self.randChoice)
            }
        }
    }
    
    func updateStatusToReviewed() {
        
        let dF = DateFormatter()
        dF.dateFormat = "YYYY-MM-dd"
        let dateNow = dF.string(from: Date())
        print(dateNow)
        let deckID = "\(deckName)\(idList[reviewProgressCount])"
        let updateSQL = "UPDATE USERPROGRESS SET TOREVIEW = 'NO', LASTDATE = '\(dateNow)' WHERE USERNAME = '\(username)' AND DECKID = '\(deckID)'"
        
        let execStatement = db.UpdateDBWithRequestString(sql: updateSQL)
        
        if (execStatement)! {
            print("review update success")
        }
        else {
            print("review update failed")
        }
    }
    
    func finishReview() {
        alertController = UIAlertController(title: "Review completed", message: "You have reviewed \(totalReview) items.", preferredStyle: .alert)
        defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
            
            self.performSegue(withIdentifier: "toDeckList", sender: Any?.self)
        })
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)

        
    }
    
    func placeWrongAnswerToEndQueue() {
        
        // user chooses wrong answer
        // progress doesn't move forward
        // user has to review "again"
        // the wrong answer will be placed at the end of the review queue
        let temp = idList[reviewProgressCount]
        idList.remove(at: reviewProgressCount)
        idList.append(temp)

    }
    
    func resetButtonBorders () {
        
        button1label.layer.borderWidth = 0.0
        button2label.layer.borderWidth = 0.0
        button3label.layer.borderWidth = 0.0
        button4label.layer.borderWidth = 0.0
        button5label.layer.borderWidth = 0.0
        button6label.layer.borderWidth = 0.0
        
    }
    
    func prepareQuestion(id: Int, choices: [String]) {
        var word: String
        var def: String = "test"
        
        
            self.resetButtonBorders()
        

        
        
        // dirty way of shuffling choices, check the extension at the very bottom
        var buttonArray = ["button1", "button2", "button3", "button4", "button5", "button6"].shuffled()
        
        word = getWordtoReview(deckID: "\(deckName)\(id)")
        def = getDefinitiontoReview(deckID: "\(deckName)\(id)")
        
        correctChoice = word
        defLabel.text = def
        
        // help me
        for i in 0...choices.count {
            
            if (buttonArray[i] == "button1") {
                if i != choices.count {
                    button1label.setTitle(choices[i], for: .normal)
                }
                else {
                    button1label.setTitle(word, for: .normal)
                    correctChoiceLocation = "button1"
                }
            }
                
            else if (buttonArray[i] == "button2") {
                
                if i != choices.count {
                    button2label.setTitle(choices[i], for: .normal)
                }
                else {
                    button2label.setTitle(word, for: .normal)
                    correctChoiceLocation = "button2"
                }
            }
                
            else if (buttonArray[i] == "button3") {
                if i != choices.count {
                    button3label.setTitle(choices[i], for: .normal)
                }
                else {
                    button3label.setTitle(word, for: .normal)
                    correctChoiceLocation = "button3"
                }
            }
                
            else if (buttonArray[i] == "button4") {
                if i != choices.count {
                    button4label.setTitle(choices[i], for: .normal)
                }
                else {
                    button4label.setTitle(word, for: .normal)
                    correctChoiceLocation = "button4"
                }
            }
                
            else if (buttonArray[i] == "button5") {
                if i != choices.count {
                    button5label.setTitle(choices[i], for: .normal)
                }
                else {
                    button5label.setTitle(word, for: .normal)
                    correctChoiceLocation = "button5"
                }
            }
                
            else if (buttonArray[i] == "button6") {
                if i != choices.count {
                    button6label.setTitle(choices[i], for: .normal)
                }
                else {
                    button6label.setTitle(word, for: .normal)
                    correctChoiceLocation = "button6"
                }
            }
        
        
        }
        

    }
    
    func reviewCount(user: String, deck: String) -> Int {
        
        var count = 0
        
        let querySQL = "SELECT COUNT(*) AS REVIEWCOUNT FROM USERPROGRESS WHERE TOREVIEW = 'YES' AND USERNAME = '\(user)' AND DECK = '\(deck)'"
        
        let result = db.QueryDBWithRequestString(sql: querySQL)
        
        if result?.next() == true {
            count = Int((result?.int(forColumn: "REVIEWCOUNT"))!)
        }
        else {
            
        }
        
        return count
    }
    
    func getIDstoReview(user: String, deck: String) -> [Int] {
        var idList = [Int]()
        
        let querySQL = "SELECT DECKID FROM USERPROGRESS WHERE TOREVIEW = 'YES' AND USERNAME = '\(user)' AND DECK = '\(deck)'"
        
        let result = db.QueryDBWithRequestString(sql: querySQL)
        var deckid: Int
        
        while result?.next() == true {
            var temp = result?.string(forColumn: "DECKID").components(separatedBy: deckName)[1]
            
            //var tempArr = temp?.components(separatedBy: ")
            deckid = Int(temp!)!
            idList.append(deckid)
        }
        
        
        return idList
        
    }
    
    func getWordtoReview(deckID: String) -> String {
        
        var word = ""
        
        let querySQL = "SELECT WORD FROM WORDBANK WHERE DECKID = '\(deckID)'"
        
        let result = db.QueryDBWithRequestString(sql: querySQL)
        
        if result?.next() == true {
            word = (result?.string(forColumn: "WORD"))!
        }
            
        else {
            
        }
        
        return word
    }
    
    func getDefinitiontoReview(deckID: String) -> String {
        var def = ""
        
        let querySQL = "SELECT DEFINITION FROM WORDBANK WHERE DECKID = '\(deckID)'"
        
        let result = db.QueryDBWithRequestString(sql: querySQL)
        
        if result?.next() == true {
            def = (result?.string(forColumn: "DEFINITION"))!
        }
        else {
            
        }
        
        return def
    }
    // idList(reviewProgressCount) = correct answer
    
    func getRandomChoices(deck: String, deckID: Int) -> [String] {
        var randomChoices = [String]()
        
        // get random choices from deck
        // deckID so randomizer won't fuck up by getting the correct answer
        var randWordIndex: Int
        
        for i in 0...4 {
            repeat{
                randWordIndex = Int(arc4random_uniform(UInt32(totalDeckCard))) + 1
                
            }while randWordIndex == deckID
            
            
            randomChoices.append(getWordtoReview(deckID: "\(deck)\(randWordIndex)"))
            
        }
        
        return randomChoices
    }
    
    
}

//shuffling purposes
extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
