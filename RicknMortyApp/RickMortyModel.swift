//
//  RickMortyModel.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

// MARK: - Info
struct Info: Codable {
    let count: Int?
    var pages: Int?
    let next: String?
    let prev: String?
}


struct RMResults: Codable {
    var info: Info?
    var results: [RMCharacter]?
}

struct RMCharacter: Codable {
    
    var id: Int?
    var name: String?
    var status: String?
    var image: String?
    
}

class ViewModel {
    
    var someCharacter: RMResults?
    
    func fetch() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let data = data, error == nil else { return }
            
            guard let _ = response else {
                return
            }
            
            // convert to JSON
            do {
                let characters = try JSONDecoder().decode(RMResults.self, from: data)
                
                DispatchQueue.main.async {
                    self?.someCharacter = characters

                }
                
            } catch {
                print(error)
            }
            
            
        }
        task.resume()
    }
}


