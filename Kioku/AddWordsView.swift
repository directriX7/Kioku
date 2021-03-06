//
//  AddWordsView.swift
//  Kioku
//
//  Created by Archie on 20/05/2017.
//  Copyright © 2017 bestgroup. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import AVFoundation


class AddWordsView : UIViewController {
    
    @IBOutlet weak var wordsStackView: UIStackView!
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(username)
        print(deckName)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    // Count the words inside the deck for ID Tag
    func countIdFromDeck(deckName: String) -> Int {
        var count = 0
        let countSQL = "SELECT COUNT(*) AS IDCOUNT FROM WORDBANK WHERE ID = '\(deckName)'"
        
        let results = fmdbDataModel.QueryDBWithRequestString(sql: countSQL)
        
        if results?.next() == true {
            count = Int((results?.int(forColumn: "IDCOUNT"))!)
            return count
        }
        
        return count
    }
    
    
    func linkWordListToProfile(user: String, deck: String) {
        let totalCount = countIdFromDeck(deckName: deck)
        var insertSQL = ""
        var deckID = ""
        
        for i in 0..<totalCount {
            deckID = "\(deck)\(String(i+1))"

            insertSQL = "INSERT INTO USERPROGRESS (USERNAME, DECK, DECKID, LEARNED, TOREVIEW) VALUES('\(user)', '\(deck)', '\(deckID)', 'NO', 'NO')"
            
            let insertStatement = fmdbDataModel.UpdateDBWithRequestString(sql: insertSQL)
            
            if (insertStatement)! {
                print("insert success")
            }
            else {
                print("insert failed")
            }
            
        }
    }
    
    // Sve the word inside the workbank with appropriate tags
    func saveWord(word: String, def: String, deck: String) -> Bool {
        
        let wordsCount = countIdFromDeck(deckName: deck) + 1
        let deckID = "\(deck)\(String(wordsCount))"
        
        let addSQL = "INSERT INTO WORDBANK (ID, WORD, DEFINITION, DECKID) VALUES ('\(deck)','\(word)','\(def)','\(deckID)')"
        
        let insertStatement = fmdbDataModel.UpdateDBWithRequestString(sql: addSQL)
        
        if (insertStatement)! {
            return true
        } else {
            return false
        }
        
        
        
    }
    
    var deckName = ""
    var username = ""
    
    let fmdbDataModel = FMDBDataModel()
//    let WORD_XCOORD = 15.0
//    let WORD_YCOORD = 150.0
//    let WORD_WIDTH = 160.0
//    let WORD_HEIGHT = 30.0
//    
//    let DEF_XCOORD = 189.0
//    let DEF_YCOORD = 150.0
//    let DEF_WIDTH = 178.0
//    let DEF_HEIGHT = 30.0
    
    
    var wordFieldList : [UITextField] = []
    var defFieldList : [UITextField] = []
    
    @IBAction func addButton(_ sender: UIButton) {
        
        playSound()
        /*let instanceCount = wordFieldList.count
        let WORD_NEWYCOORD : Double = WORD_YCOORD + (45.0 * Double(instanceCount))
        
        // add new word field
        let newWord = UITextField(frame: CGRect(x: WORD_XCOORD, y: WORD_NEWYCOORD, width: WORD_WIDTH, height: WORD_HEIGHT))
        newWord.placeholder = "Add word"
        newWord.font = UIFont.systemFont(ofSize: 15)
        newWord.borderStyle = UITextBorderStyle.roundedRect
        newWord.autocorrectionType = UITextAutocorrectionType.no
        newWord.keyboardType = UIKeyboardType.default
        newWord.returnKeyType = UIReturnKeyType.done
        newWord.clearButtonMode = UITextFieldViewMode.whileEditing;
        newWord.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        newWord.autocapitalizationType = UITextAutocapitalizationType.none
        
        
        self.view.addSubview(newWord)
        wordFieldList.append(newWord)
        
        //add new definition field
        let DEF_NEWYCOORD : Double = DEF_YCOORD + (45 * Double(instanceCount))
        
        let newDef = UITextField(frame: CGRect(x: DEF_XCOORD, y: DEF_NEWYCOORD, width: DEF_WIDTH, height: DEF_HEIGHT))
        newDef.placeholder = "Add definition"
        newDef.font = UIFont.systemFont(ofSize: 15)
        newDef.borderStyle = UITextBorderStyle.roundedRect
        newDef.autocorrectionType = UITextAutocorrectionType.no
        newDef.keyboardType = UIKeyboardType.default
        newDef.returnKeyType = UIReturnKeyType.done
        newDef.clearButtonMode = UITextFieldViewMode.whileEditing;
        newDef.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        newDef.autocapitalizationType = UITextAutocapitalizationType.none
 
        self.view.addSubview(newDef)
        defFieldList.append(newDef)
         */
        
        let addWordsItemView = Bundle.main.loadNibNamed("AddWordsItemView", owner: nil, options: nil)?[0] as! UIStackView
        wordsStackView.addArrangedSubview(addWordsItemView)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        playSound()
        var success = true
        var addedWordsCount = 0
        
        for i in 0..<wordsStackView.arrangedSubviews.count {
            let stackView:UIStackView = wordsStackView.arrangedSubviews[i] as! UIStackView
            let word:HoshiTextField = stackView.arrangedSubviews[0] as! HoshiTextField
            let desc:HoshiTextField = stackView.arrangedSubviews[1] as! HoshiTextField
            
            if (word.text!.characters.count > 0 ||
                desc.text!.characters.count > 0) {
                
                
                if (!saveWord(word: word.text!, def: desc.text!, deck: deckName)) {
                    success = false
                    break;
                }
                else {
                    addedWordsCount += 1
                }
            }
        }
        
        var alertController:UIAlertController
        var defaultAction:UIAlertAction
        
        if (success) {
            //connect word list to profile
            linkWordListToProfile(user: username, deck: deckName)
            alertController = UIAlertController(title: "Words added", message: "A total of \(addedWordsCount) words have been added to the deck!", preferredStyle: .alert)
            defaultAction = UIAlertAction(title: "OK", style: .default, handler:  { (UIAlertAction) in
                self.performSegue(withIdentifier: "toDeckList", sender: Any?.self)
            })
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion:{
                
            })
        } else {
            alertController = UIAlertController(title: "Words not added", message: "Uh oh, something went wrong!", preferredStyle: .alert)
            defaultAction = UIAlertAction(title: "OK", style: .default, handler:  { (UIAlertAction) in
                
            })
            
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion:{
                
            })
        }
    }
}
