//
//  RealmManager.swift
//  QuotesRealm
//
//  Created by Миша Вашкевич on 02.04.2024.
//

import Foundation
import KeychainSwift

class KeyChainStorage {
    
    static let shared = KeyChainStorage()
    private init(){}
    
    
    func load() -> Data? {
        guard let data = KeychainSwift().getData("databaseKEY") else {return nil}
        return data
    }
    
    func save(key: Data) {
        KeychainSwift().set(key, forKey: "databaseKEY")
    }
    
}

