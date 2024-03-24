//
//  File.swift
//  QuotesRealm
//
//  Created by Миша Вашкевич on 24.03.2024.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name: String
    @Persisted var quotes: List<Quote>
}
