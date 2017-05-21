//
//  AddDeckView.swift
//  Kioku
//
//  Created by Archie on 20/05/2017.
//  Copyright © 2017 bestgroup. All rights reserved.
//

import Foundation
import UIKit

class AddDeckView : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var username = ""
    
    let fmdbDataModel = FMDBDataModel()
    
    func addToDeckTable (name: String, definition: String) -> Bool {
        let insertSQL = "INSERT INTO DECKDEFINITION (DECKNAME, DECKDESC) VALUES ('\(name)','\(definition)')"
        
        let insertStatement = fmdbDataModel.UpdateDBWithRequestString(sql: insertSQL)
        
        if (insertStatement)! {
            return true
        }
        else {
            return false
        }
    }
    
    func addToUserDeckReference (username: String, deck: String) -> Bool {
        let insertSQL = "INSERT INTO USERDECKS (USERNAME, DECKNAME) VALUES ('\(username)','\(deck)')"
        
        let insertStatement = fmdbDataModel.UpdateDBWithRequestString(sql: insertSQL)
        
        if (insertStatement)! {
            return true
        }
        else {
            return false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddWords" {
            let awView = segue.destination as! AddWordsView
            
            awView.deckName = self.deckName.text!
            awView.username = self.username
            
        }
    }
    
    @IBAction func nextbutton(_ sender: UIButton) {
        if (addToDeckTable(name: deckName.text!, definition: deckDesc.text!)) && (addToUserDeckReference(username: self.username, deck: deckName.text!)) {
            
            performSegue(withIdentifier: "toAddWords", sender: Any?.self)
        }
        else {
            
        }
        
    }
    
    @IBOutlet weak var deckName: UITextField!
    @IBOutlet weak var deckDesc: UITextField!
}