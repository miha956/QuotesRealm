//
//  NetworkManager.swift
//  QuotesRealm
//
//  Created by Миша Вашкевич on 24.03.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    var realmManager: RealmManagerProtocol { get set }
    func fetchData(complition: @escaping(Error?) -> Void)
    
}

class NetworkManager: NetworkManagerProtocol {
    
    let url: URL = URL(string: "https://api.chucknorris.io/jokes/random")!
    let session = URLSession.shared
    var realmManager: RealmManagerProtocol = RealmManager()
    
    
    func fetchData(complition: @escaping(Error?) -> Void) {
        let urlRequest = URLRequest(url: url)
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                complition(error)
            }
            guard let data = data else { return }
            do {
                let quote  = try JSONDecoder().decode(Quote.self, from: data)
                DispatchQueue.main.async {
                    self.realmManager.saveToDataBase(quote: quote)
                }
            } catch let error {
                complition(error)
            }
        }.resume()
    }
    
}
