//
//  RealmManager.swift
//  QuotesRealm
//
//  Created by Миша Вашкевич on 24.03.2024.
//

import Foundation
import RealmSwift


protocol RealmManagerProtocol {
    
    func saveToDataBase(quote: Quote)
    func fetchAllQuotes() -> [Quote]
    func fetchQuotesByCatigory() -> [Category]
}

class RealmManager: RealmManagerProtocol {
    
    var networkManager: NetworkManagerProtocol?
    
    var realm: Realm {
        setupDatabase()
    }
    
    private func setupDatabase() -> Realm {
        
        var key: Data = {
            var key = Data(count: 64)
            _ = key.withUnsafeMutableBytes { (pointer: UnsafeMutableRawBufferPointer) in
                SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            }
            return key
        }()
    
        if let keyInStorage = KeyChainStorage.shared.load() {
            key = keyInStorage
        } else {
            KeyChainStorage.shared.save(key: key)
        }
        var config = Realm.Configuration(encryptionKey: key)
        var realm: Realm = try! Realm(configuration: config)
        
        return realm
    }
        
    func saveToDataBase(quote: Quote) {
        let categories = realm.objects(Category.self)
        
        if quote.categories.isEmpty {
             quote.categories.append("Without Category")
         }
        
        quote.categories.forEach { categoryName in
            let capitalizedCategoryName = categoryName.capitalized
            
            if let existingCategory = categories.first(where: { $0.name == capitalizedCategoryName }) {
                do {
                    try realm.write {
                        existingCategory.quotes.append(quote)
                    }
                } catch {
                    print("write error")
                }
            } else {
                let newCategory = Category()
                newCategory.name = capitalizedCategoryName
                newCategory.quotes.append(quote)
                do {
                    try realm.write {
                        realm.add(newCategory)
                    }
                } catch {
                    print("write error")
                }
            }
        }
    }
    
    func fetchAllQuotes() -> [Quote] {
        
            self.networkManager?.fetchData(complition: { error in
                guard let error = error else { return }
                print(error)
            })
        
        let categories = realm.objects(Category.self)
        
        var quotes: [Quote] = []
        categories.forEach { category in
            category.quotes.forEach { quote in
                if !quotes.contains(where: {$0.id == quote.id}) {
                    quotes.append(quote)
                }
            }
        }
        return Array(quotes.sorted(by: { $0.createdAt < $1.createdAt}))
    }
    
    func fetchQuotesByCatigory() -> [Category] {
        let categories = realm.objects(Category.self)
        
        if categories.isEmpty {
            return []
        } else {
            return Array(categories)
        }
    }
}

