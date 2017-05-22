//
//  FMDBDataModel.swift
//  Kioku
//
//  Created by Archie on 20/05/2017.
//  Copyright © 2017 bestgroup. All rights reserved.
//

import Foundation

class FMDBDataModel : NSObject {
    let fileName = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true).first!)/main.sqlite"
    var contactDB:FMDatabase
    
    override init() {
        contactDB = FMDatabase(path: fileName as String)
    }
    
    func QueryDBWithRequestString (sql : String) -> FMResultSet? {
        
        if (contactDB.open()) {
            let result:FMResultSet? = contactDB.executeQuery(sql, withArgumentsIn: nil)
            
            return result!
        } else {
            print("Error: \(String(describing: contactDB.lastErrorMessage()))")
            return nil;
        }
    }
    
    func UpdateDBWithRequestString(sql : String) -> Bool? {
        if (contactDB.open()) {
            let result = contactDB.executeUpdate(sql, withArgumentsIn: nil)
            
            return result
        } else {
            print("Error: \(String(describing: contactDB.lastErrorMessage()))")
            return false;
        }
    }
    
    func TruncateEverything() {
    
        if contactDB.open() {
            var delSQL = "DELETE FROM WORDBANK"
    
            var delete = contactDB.executeUpdate(delSQL, withArgumentsIn: nil)
    
            if delete {
                print("Wordbank truncate success")
            }
            else {
                print("Wordbank truncate error")
            }
    
            delSQL = "DELETE FROM DECKDEFINITION"
            delete = contactDB.executeUpdate(delSQL, withArgumentsIn: nil)
    
            if delete {
                print("Deck defnition truncate success")
            }
            else {
                print("Deck definition truncate error")
            }
    
            delSQL = "DELETE FROM USERDECKS"
            delete = contactDB.executeUpdate(delSQL, withArgumentsIn: nil)

    
            if delete {
                print("Userdeck truncate success")
            }
            else {
                print("Userdeck truncate error")
            }
            delSQL = "DELETE FROM USERPROGRESS"
            delete = contactDB.executeUpdate(delSQL, withArgumentsIn: nil)
            
            
            if delete {
                print("Userprogress truncate success")
            }
            else {
                print("Userprogress truncate error")
            }
        }
        contactDB.close()
    }

    
    func CloseDB() {
        contactDB.close()
    }
    
}
