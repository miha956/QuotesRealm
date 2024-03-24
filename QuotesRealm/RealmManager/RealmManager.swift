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
    
    let realm = try! Realm()
    
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

