//
//  ViewController.swift
//  Kioku
//
//  Created by Archie on 19/05/2017.
//  Copyright © 2017 bestgroup. All rights reserved.
//

import UIKit
import TextFieldEffects

class ViewController: UIViewController {

    @IBOutlet weak var userField: HoshiTextField!
    @IBOutlet weak var passField: HoshiTextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
   
    let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let fmdbDataModel = FMDBDataModel()
    
    
    
// MARK:
// MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        btnLogin.layer.cornerRadius = btnLogin.frame.size.height/2
        btnRegister.layer.cornerRadius = btnRegister.frame.size.height/2
        btnRegister.layer.borderColor = UIColor (red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        btnRegister.layer.borderWidth = 2.0

// MARK:
// MARK: TruncateTables
//        var delSQL = "DELETE FROM WORDBANK"
//        
//        var delete = fmdbDataModel.UpdateDBWithRequestString(sql: delSQL)
//        
//        if delete! {
//            print("Wordbank truncate success")
//        }
//        else {
//            print("Wordbank truncate error")
//        }
//        
//        delSQL = "DELETE FROM DECKDEFINITION"
//        delete = fmdbDataModel.UpdateDBWithRequestString(sql: delSQL)
//        
//        if delete! {
//            print("Deck defnition truncate success")
//        }
//        else {
//            print("Deck definition truncate error")
//        }
//        
//        delSQL = "DELETE FROM USERDECKS"
//        delete = fmdbDataModel.UpdateDBWithRequestString(sql: delSQL)
//        
//        if delete! {
//            print("Userdeck truncate success")
//        }
//        else {
//            print("Userdeck truncate error")
//        }
        
        checkDB()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK:
// MARK: UIControls
    
    func checkDB(){
        
        
        let fManager = FileManager.default
        
        let fileName = "\(filePath)/main.sqlite"
        if !fManager.fileExists(atPath: fileName as String){
            
            let contactDB = FMDatabase(path: fileName as String)
            
            // cannot contact database
            if contactDB == nil{
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            }
            
            if (contactDB?.open())! {
                // Create table for user table
                var create = "CREATE TABLE IF NOT EXISTS USERTABLE(USERNAME TEXT PRIMARY KEY, PASSWORD TEXT)"
                
                if !(contactDB?.executeStatements(create))!{
                    print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                }
                else{
                    print("user table create success")
                }
                
                // Create table for Deck definitions (not the actual content)
                create = "CREATE TABLE IF NOT EXISTS DECKDEFINITION(DECKNAME TEXT PRIMARY KEY, DECKDESC TEXT)"
                
                if !(contactDB?.executeStatements(create))!{
                    print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                }
                else{
                    print("deck def table create success")
                }
                
                // Create table for the word baank
                create = "CREATE TABLE IF NOT EXISTS WORDBANK(ID TEXT, WORD TEXT, DEFINITION TEXT, DECKID TEXT)"
                
                if !(contactDB?.executeStatements(create))!{
                    print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                }
                else{
                    print("word bank table create success")
                }
                
                create = "CREATE TABLE IF NOT EXISTS USERDECKS(USERNAME TEXT, DECK TEXT)"
                
                if !(contactDB?.executeStatements(create))!{
                    print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                }
                else{
                    print("user deck reference table create success")
                }
                
                create = "CREATE TABLE IF NOT EXISTS USERPROGRESS(USERNAME TEXT, DECK TEXT, DECKID TEXT, LEARNED TEXT, TOREVIEW TEXT)"
                
                if !(contactDB?.executeStatements(create))!{
                    print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                }
                else{
                    print("user deck reference table create success")
                }
                
                contactDB?.close()
            } else {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            }
        }
    }
    
    func checkLogin(username: String, password: String) -> Bool{
    
        let sqlString = "SELECT PASSWORD FROM USERTABLE WHERE USERNAME = '\(username)'"
        
        let result:FMResultSet? = fmdbDataModel.QueryDBWithRequestString(sql: sqlString)
        
        if result?.next() == true {
            let dbPass = result?.string(forColumn: "PASSWORD")
            
            if dbPass == password {
                fmdbDataModel.CloseDB()
                return true
            }
            else {
                return false
            }
        }
        else
        {
            fmdbDataModel.CloseDB()
        }
        
        return false
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        if checkLogin(username: userField.text!, password: passField.text!){
            
            performSegue(withIdentifier: "segue_homefromLogin", sender: Any?.self)
            
        } else {
            let alertController = UIAlertController(title: "Login Failed", message: "Login details incorrect!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    // MARK:
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_homefromLogin" {
            let dView = segue.destination as! DeckListView
            
            dView.username = userField.text!
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

