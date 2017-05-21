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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decksTable.delegate = self
        decksTable.dataSource = self
        self.decksTable.register(UITableViewCell.self, forCellReuseIdentifier: "customcell")
        retrieveUserDecks(usrname: username)
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    @IBOutlet weak var decknameLabel: UILabel!
    @IBOutlet weak var wordcountLabel: UILabel!
    @IBOutlet weak var deckdescLabel: UILabel!
    @IBOutlet weak var wordslearnedLabel: UILabel!
    @IBOutlet weak var toreviewLabel: UILabel!
    
    
    let db = FMDBDataModel()
    
    let filePath = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
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
            
            while result?.next() == true {
                
                userDecks.append((result?.string(forColumn: "DECKNAME"))!)
            }
            
        }
        else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
        }
        contactDB?.close()
        
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
//            let trView = segue.destination as! ReviewView
//            
//            trView.username = self.username
//            trView.deckName = decknameLabel.text!
        }
         if segue.identifier == "toLearn" {
            let tlView = segue.destination as! LearnView
            
            tlView.username = self.username
            tlView.deckname = decknameLabel.text!
            
        }
        
    }
    
    var userDecks = [String]()
    var username = ""
    
    @IBOutlet weak var decksTable: UITableView!
    
    //MARK: Navigation
    
    @IBAction func unwindToDeckList(segue: UIStoryboardSegue) {
    
    }
}
