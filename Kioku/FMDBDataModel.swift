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
    
    func CloseDB() {
        contactDB.close()
    }
    
}
