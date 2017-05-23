//
//  RegisterView.swift
//  Kioku
//
//  Created by Archie on 19/05/2017.
//  Copyright © 2017 bestgroup. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects

class RegisterView : UIViewController , UITextFieldDelegate {

    @IBOutlet weak var tncswitch: UISwitch!
    @IBOutlet weak var tnclabel: UILabel!
    
    @IBOutlet weak var userExistsImage: UIImageView!
    @IBOutlet weak var passMatchImage: UIImageView!
    @IBOutlet weak var verifyPassMatchImage: UIImageView!
    @IBOutlet weak var userfield: HoshiTextField!
    @IBOutlet weak var passfield: HoshiTextField!
    @IBOutlet weak var confirmpassfield: HoshiTextField!
    @IBOutlet weak var btnRegister: UIButton!
    
    var userExists = false
    var passMatch = false
    let fmdbDataModel = FMDBDataModel()
    
    // MARK:
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        tncswitch.addTarget(self, action: #selector(switchStateChange(_:)), for: UIControlEvents.valueChanged)
        
//        userfield.addTarget(self, action: #selector(usrFieldDidChange(_:)), for: .editingChanged)
        passfield.addTarget(self, action: #selector(confirmPassCheck(_:)), for: .editingChanged)
        confirmpassfield.addTarget(self, action: #selector(confirmPassCheck(_:)), for: .editingChanged)
        btnRegister.layer.cornerRadius = btnRegister.frame.size.height/2
        btnRegister.layer.borderColor = UIColor (red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        btnRegister.layer.borderWidth = 2.0
        
        userExistsImage.alpha = 0
        passMatchImage.alpha = 0
        verifyPassMatchImage.alpha = 0
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:
    // MARK: Private Methods
    
    func switchStateChange(_ sw: UISwitch) {
        if sw.isOn {
            tnclabel.text = "Yes, I have \"read\" the Terms & Conditions."
        }
        else {
            tnclabel.text = "No, I haven't read the Terms & Conditions yet."
        }
    }
    
    // Register the user
    func registerUser(username: String, password: String) {
        
        let sqlString = "INSERT INTO USERTABLE (USERNAME, PASSWORD) VALUES('\(username)','\(password)')"
        
        let result = fmdbDataModel.UpdateDBWithRequestString(sql: sqlString)
        
        if !result! {// If inserting fails
//            print("Error: \(String(describing: contactDB.lastErrorMessage()))")
        } else {// Alert prompt confirming registration completion
            let alertController = UIAlertController(title: "Registration Completed", message: "You have registered successfully! You can now add decks to your profile and start learning right away!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler:  { (UIAlertAction) in
                self.performSegue(withIdentifier: "segue_home", sender: Any?.self)
            })
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion:{
                
            })
        }
    }
    
    
    // Check if username exists in database, implemented in textChange event
    func checkUserExists(username: String) -> Bool {
        
        let sqlString = "SELECT * FROM USERTABLE WHERE USERNAME = '\(username)'"
        
        let result:FMResultSet? = fmdbDataModel.QueryDBWithRequestString(sql: sqlString)
        
        if result?.next() == true {
            
            let usr = result?.string(forColumn: "USERNAME")
            
            // if the username and username retrieved from DB is equal, the username must've already existed
            // therefore user shouldn't be allowed to register
            if usr == username {
                fmdbDataModel.CloseDB()
                return true
            }
        } else {
            // no result means username probably doesn't exist in DB 
            // therefore allow user to register
            fmdbDataModel.CloseDB()
            return false
        }
        return false
    }
    
    // every text change,
    func usrFieldDidChange(_ textField: UITextField) {
        
        
    }
    
    func confirmPassCheck(_ textField: UITextField) {
        passMatchImage.alpha = (passfield.text?.characters.count)! >= 3 ? 1.0 : 0.0
        verifyPassMatchImage.alpha = 1.0
        if !(passfield.text! == confirmpassfield.text!) {
            verifyPassMatchImage.image = UIImage(named:"ico_cross")
            confirmpassfield.borderActiveColor = UIColor.red
            confirmpassfield.borderInactiveColor = UIColor.red
//            let bordColor : UIColor = UIColor.red
//            confirmpassfield.layer.borderWidth = 1.0
//            confirmpassfield.layer.borderColor = bordColor.cgColor
            passMatch = false
        } else {
            verifyPassMatchImage.image = UIImage(named:"ico_check")
            confirmpassfield.borderActiveColor = UIColor.blue
            confirmpassfield.borderInactiveColor = UIColor.blue
            passMatch = true
        }
    }
    
    // MARK:
    // MARK: UIControls
    @IBAction func registerbutton(_ sender: UIButton) {
        
        if checkUserExists(username: userfield.text!) {
            userExistsImage.alpha = 1.0
            userExistsImage.image = UIImage(named:"ico_cross")
            userfield.borderActiveColor = UIColor.red
            userfield.borderInactiveColor = UIColor.red
            userExists = true
        } else {
            userExistsImage.alpha = 0
            userfield.layer.borderWidth = 0.0
            userExistsImage.image = UIImage(named:"ico_check")
            userExists = false
            
        }
        
        if (!userExists) && (passMatch) && (tncswitch.isOn) {
            userfield.borderActiveColor = UIColor.blue
            userfield.borderInactiveColor = UIColor.blue
            
            registerUser(username: userfield.text!, password: passfield.text!)
        } else {
            
            print("\(userExists)   \(passMatch) \(tncswitch.isOn)")
            let alertController = UIAlertController(title: "Registration Error", message: "You still have some errors left, please review your registration data before proceeding.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK:
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue_home") {
            print("register success")
        }
    }
    
    // MARK:
    // MARK: UITextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    
}
