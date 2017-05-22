//
//  DeckListView.swift
//  Kioku
//
//  Created by Archie on 19/05/2017.
//  Copyright © 2017 bestgroup. All rights reserved.
//

import Foundation
import UIKit

class DeckListView : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var decknameLabel: UILabel!
    @IBOutlet weak var wordcountLabel: UILabel!
    @IBOutlet weak var deckdescLabel: UILabel!
    @IBOutlet weak var wordslearnedLabel: UILabel!
    @IBOutlet weak var toreviewLabel: UILabel!
    @IBOutlet weak var decksTable: UITableView!
    
    let db = FMDBDataModel()
    
    let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    var userDecks = [String]()
    var username = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForReviews(username: self.username)
        
        decksTable.delegate = self
        decksTable.dataSource = self
        self.decksTable.register(UITableViewCell.self, forCellReuseIdentifier: "customcell")
        refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData() {
        retrieveUserDecks(usrname: username)
        self.decksTable.reloadData()
    }
    
    func retrieveDesc(deck: String) -> String {
        
        var desc = ""
        let querySQL = "SELECT DECKDESC FROM DECKDEFINITION WHERE DECKNAME = '\(deck)'"
        
        let result = db.QueryDBWithRequestString(sql: querySQL)
        
        if result?.next() == true {
            desc = (result?.string(forColumn: "DECKDESC"))!
            return desc
        }
        
        return desc
    }
    
    func retrieveWordCount(deck: String) -> Int {
        
        var wordCount = 0
        let querySQL = "SELECT COUNT(*) AS WORDCOUNT FROM WORDBANK WHERE ID = '\(deck)'"
        
        let result = db.QueryDBWithRequestString(sql: querySQL)
        
        if result?.next() == true {
            wordCount = Int((result?.int(forColumn: "WORDCOUNT"))!)
        }
        return wordCount
        
    }
    
    
    // retrieve count of words learned
    func retrieveWordsLearnCount(user: String, deck: String) -> Int {
        var count = 0
        
        let querySQL = "SELECT COUNT(*) AS LEARNCOUNT FROM USERPROGRESS WHERE USERNAME = '\(user)' AND DECK = '\(deck)' AND LEARNED = 'YES'"
        let result = db.QueryDBWithRequestString(sql: querySQL)
        
        if result?.next() == true {
            count = Int((result?.int(forColumn: "LEARNCOUNT"))!)
        }
        
        return count
    }
    
    func retrieveWordstoReviewCount(username: String, deck: String) -> Int {
        var count = 0
        
        let querySQL = "SELECT COUNT(*) AS REVIEWCOUNT FROM USERPROGRESS WHERE USERNAME = '\(username)' AND DECK = '\(deck)' AND TOREVIEW = 'YES'"
        
        let result = db.QueryDBWithRequestString(sql: querySQL)
        
        if result?.next() == true {
            count = Int((result?.int(forColumn: "REVIEWCOUNT"))!)
        }
        
        return count
    }
    
    func retrieveUserDecks(usrname: String) {
        
        let fileName = "\(filePath)/main.sqlite"
        
        let contactDB = FMDatabase(path: fileName as String)
        
        if (contactDB?.open())! {
            let queryStatement = "SELECT DECKNAME FROM USERDECKS WHERE USERNAME = '\(usrname)'"
            
            let result:FMResultSet? = contactDB?.executeQuery(queryStatement, withArgumentsIn: nil)
            userDecks.removeAll()
            while result?.next() == true {
                
                userDecks.append((result?.string(forColumn: "DECKNAME"))!)
            }
            
        }
        else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        contactDB?.close()
        
    }
    
    func checkIfNeedLearn(username: String, deck: String) -> Bool {
        
        let querySQL = "SELECT LEARNED FROM USERPROGRESS WHERE USERNAME = '\(username)' AND DECK = '\(deck)' AND LEARNED = 'NO'"
        
        let result = db.QueryDBWithRequestString(sql: querySQL)
        
        if result?.next() == true {
            return true
        }
        else {
            return false
        }
        
    }
    
    func countAllCardsFromUser(username: String) -> Int {
        var count = 0
        
        let querySQL = "SELECT COUNT(*) AS CARDCOUNT FROM USERPROGRESS WHERE USERNAME = '\(username)'"
        
        let result = db.QueryDBWithRequestString(sql: querySQL)
        
        if result?.next() == true {
            count = Int((result?.int(forColumn: "CARDCOUNT"))!)
        }
        
        return count
        
        
    }
    
    func checkForReviews(username: String) {
        
        let dF = DateFormatter()

        
        let querySQL = "SELECT LASTDATE, DECKID FROM USERPROGRESS WHERE USERNAME = '\(username)' AND TOREVIEW = 'NO' AND LEARNED = 'YES' AND LASTDATE != NULL"
        let results = db.QueryDBWithRequestString(sql: querySQL)
        
        while results?.next() == true {
            let date = results?.string(forColumn: "LASTDATE")
            let deckID = results?.string(forColumn: "DECKID")
            
            // -86400.0 means one day
            // if greater than one day, then card needs to be reviewed!
            if (Double((dF.date(from: date!)?.timeIntervalSinceNow)!) > -86400.0) {
                changeReviewState(user: self.username, deckID: deckID!)
            }
            
        }
        
        
    }
    
    func changeReviewState(user: String, deckID: String) {
        
        let updateSQL = "UPDATE USERPROGRESS SET TOREVIEW = 'YES' WHERE USERNAME = '\(user)' AND DECKID = '\(deckID)'"
        let execStatement = db.UpdateDBWithRequestString(sql: updateSQL)
        
        if (execStatement!) {
            print("change review state success")
        }
        else {
            print("something went wrong")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.userDecks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath as IndexPath)
        cell.textLabel?.text = userDecks[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let cellName = cell?.textLabel?.text	
        
        let totalWordCount = retrieveWordCount(deck: cellName!)
        
        decknameLabel.text = cellName
        deckdescLabel.text = retrieveDesc(deck: cellName!)
        wordcountLabel.text = "\(String(totalWordCount)) words in the deck"
        
        let wordsLearned = retrieveWordsLearnCount(user: self.username, deck: cellName!)
        wordslearnedLabel.text = "\(wordsLearned)/\(totalWordCount) words learned"
        
        let toReview = retrieveWordstoReviewCount(username: self.username, deck: cellName!)
        toreviewLabel.text = "\(toReview) words to review"
        
        
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addDeck" {
            let adView = segue.destination as! AddDeckView
            
            adView.username = self.username
        }
        if segue.identifier == "toReview" {
            let trView = segue.destination as! ReviewView
            
            trView.username = self.username
            trView.deckName = decknameLabel.text!
            trView.totalDeckCard = retrieveWordCount(deck: decknameLabel.text!)
        }
         if segue.identifier == "toLearn" {
            let tlView = segue.destination as! LearnView
            
            tlView.username = self.username
            tlView.deckname = decknameLabel.text!
            
        }
        
    }
    
    @IBAction func learnButton(_ sender: UIButton) {
        if (checkIfNeedLearn(username: self.username, deck: decknameLabel.text!)) {
            
        }
        else {
            let alertController = UIAlertController(title: "No Words to Learn", message: "There are no more words to learn!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler:  { (UIAlertAction) in
            })
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion:{
                
            })

        }
    }
    
    @IBAction func reviewButton(_ sender: UIButton) {
        if (retrieveWordstoReviewCount(username: self.username, deck: decknameLabel.text!) > 0) {
            
        }
        else {
            let alertController = UIAlertController(title: "No Words to Review", message: "There are no more words to review! Please check back again another day!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler:  { (UIAlertAction) in
            })
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion:{
                
            })
            
        }

    }
    
    //MARK: Navigation
    
    @IBAction func unwindToDeckList(segue: UIStoryboardSegue) {
        refreshData()
    }
}
