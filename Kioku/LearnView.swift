//
//  LearnView.swift
//  Kioku
//
//  Created by Archie on 20/05/2017.
//  Copyright © 2017 bestgroup. All rights reserved.
//

import Foundation
import UIKit

class LearnView : UIViewController {
    
    var username = ""
    var deckname = ""
    
    var term = [String]()
    var defn = [String]()
    var size = 0
    var numProg = 0
    
    var temp = 0
    
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var defLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        temp = learnCount(deck: deckname, user: username)
        progress.text = " \(numProg+1)/\(temp)"
        WordsNotLearned(deck: deckname,Username: username, defn: &defn, term: &term)
        size = defn.count
        
        wordLabel.text = term[0]
        defLabel.text = defn[0]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    let db = FMDBDataModel()
    // main logic
    
    func learnCount(deck: String, user: String) -> Int {
        var count = 0

        let querySQL = "SELECT COUNT(*) AS LEARNCOUNT FROM USERPROGRESS WHERE USERNAME = '\(user)' AND LEARNED = 'NO' AND DECK = '\(deck)'"
        
        
        let result = db.QueryDBWithRequestString(sql: querySQL)
        
        if result?.next() == true {
            count = Int((result?.int(forColumn: "LEARNCOUNT"))!)
        }
            
        else{
            print("failed")
        }
        
        return count
    }
    
    func WordsNotLearned(deck: String, Username: String, defn: inout [String], term: inout [String]) {
    
        
     //   var querySQL = "SELECT * FROM WORDBANK WHERE ID = '\(deck)'"
        let query1 = "SELECT WORDBANK.WORD, WORDBANK.DEFINITION FROM WORDBANK JOIN USERPROGRESS ON WORDBANK.DECKID = USERPROGRESS.DECKID WHERE USERPROGRESS.USERNAME = '\(Username)' AND USERPROGRESS.DECK = '\(deck)' AND WORDBANK.DECKID = USERPROGRESS.DECKID"
        
        
        
        let result = db.QueryDBWithRequestString(sql: query1)
        //db.QueryDBWithRequestString(sql: <#T##String#>)
        
        while result?.next() == true
        {
            defn.append((result?.string(forColumn:"DEFINITION"))!)
            
            term.append((result?.string(forColumn:"WORD"))!)
        }
        
        
        
    }
    
    func updateLearned(deck: String, user: String)
    {
        let query2 = "UPDATE USERPROGRESS SET LEARNED = 'YES', TOREVIEW = 'YES' WHERE DECK = '\(deck)' and USERNAME = '\(user)'"
        
        let result = db.UpdateDBWithRequestString(sql:query2)
    
    }
    
    
    @IBAction func Nextq(_ sender: UIButton)
    {
     
        
        if numProg+1 >= size
        // disable next
        {
            let alertController = UIAlertController(title: "Congratulation!", message: "You have learned \(size) of words", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction!) in
            // segue to deck menu
            // update before segue
                self.updateLearned(deck: self.deckname, user: self.username)
               self.navigationController?.popViewController(animated: true)
                
            })
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else
        {
            numProg += 1
            wordLabel.text = term[numProg]
            
            defLabel.text = defn[numProg]
             progress.text = " \(numProg+1)/\(temp)"
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FromLearnToMenu" {
            let dView = segue.destination as! DeckListView
            
            dView.username = self.username
        }
    }

    
    
}
