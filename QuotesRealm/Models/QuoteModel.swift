//
//  Quotes.swift
//  QuotesRealm
//
//  Created by Миша Вашкевич on 24.03.2024.
//

import Foundation
import RealmSwift

class Quote: Object, Decodable {
    @Persisted var categories: List<String>
    @Persisted var createdAt: String
    @Persisted var iconURL: String
    @Persisted var id: String
    @Persisted var updatedAt: String
    @Persisted var url: String
    @Persisted var value: String

    enum CodingKeys: String, CodingKey {
        case categories
        case createdAt = "created_at"
        case iconURL = "icon_url"
        case id
        case updatedAt = "updated_at"
        case url, value
    }
}
