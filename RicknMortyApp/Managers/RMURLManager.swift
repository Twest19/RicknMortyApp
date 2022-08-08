//
//  RMURLManager.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/7/22.
//

import Foundation

protocol RMApiBaseURL {
    func components() -> URLComponents
}

extension RMApiBaseURL {
    func components() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        return components
    }
}


struct CharacterURLManager: RMApiBaseURL {
    
    static var shared = CharacterURLManager()
    
    func characterComponents(with ID: String = "") -> URLComponents {
        var components = components()
        components.path = "/api/character/\(ID)"
        return components
    }
    
    
    func createCharacterURL(pageNum: Int, searchBarText: String = "") -> URL? {
        var components = characterComponents()
        let pages = URLQueryItem(name: "page", value: String(pageNum))
        let userCharacterSearch = URLQueryItem(name: "name", value: searchBarText)
        
        // Provides proper query items for URL
        if searchBarText == "" || searchBarText == " " {
            components.queryItems = [pages]
        } else {
            components.queryItems = [pages, userCharacterSearch]
        }
        return components.url
    }
}


struct EpisodeURLManager: RMApiBaseURL {
    
    static var shared = EpisodeURLManager()
    
    func episodeComponents(episodeNum: String) -> URLComponents {
        var components = components()
        components.path = "/api/episode/\(episodeNum)"
        return components
    }
}
