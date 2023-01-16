//
//  RMURLManager.swift
//  RicknMortyApp
//

import Foundation

// Base URL
class RMApiBaseURL {
    func components() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "rickandmortyapi.com"
        // Returns the proper URL Components to be used in all URLs
        return components
    }
}

// Inherits the base URL and adds on the character components
class CharacterURLManager: RMApiBaseURL {
    
    static var shared = CharacterURLManager()
    
    func characterComponents(with ID: String = "") -> URLComponents {
        var components = components()
        components.path = "/api/character/\(ID)"
        // Returns the proper URL Components
        return components
    }
    
    // Creates a character URL using the above character URL components
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
        // Returns completed URL
        return components.url
    }
}

// Inherits Base URL and adds the proper Episode components
class EpisodeURLManager: RMApiBaseURL {
    
    static var shared = EpisodeURLManager()
    
    func episodeComponents(episodeNum: String = "") -> URLComponents {
        var components = components()
        components.path = "/api/episode/\(episodeNum)"
        // Returns the proper URL Components
        return components
    }
    
    // Creates an episode URL using the above episode URL components
    func createEpisodeURL(pageNum: Int) -> URL? {
        var components = episodeComponents()
        let pageNum = URLQueryItem(name: "page", value: String(pageNum))
        components.queryItems = [pageNum]
        // Returns completed URL
        return components.url
    }
}
