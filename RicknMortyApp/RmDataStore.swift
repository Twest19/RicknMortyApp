//
//  RmDataStore.swift
//  RicknMortyApp
//
//  Created by Tim West on 1/16/23.
//

import Foundation


class RMDataStore {
    
    
    public static let shared = RMDataStore()
    
    private var rmCharacters: [RMCharacter] = []
    private var rmEpisodes: [Episode] = []
    
    private init() {}
    
    
    // MARK: Characters
    func saveCharacters(_ character: [RMCharacter]) {
        rmCharacters.append(contentsOf: character)
    }
    
    func getCharacters() -> [RMCharacter] {
        return rmCharacters
    }
    
    func getCharacterIds() -> [RMCharacter.ID] {
        return rmCharacters.map { $0.id }
    }
    
    func character(with id: Int) -> RMCharacter? {
        return rmCharacters.first(where: { $0.id == id })
    }
    
    func clearCharacters() {
        rmCharacters = []
    }
    
    
    // MARK: Episodes
    func saveEpisodes(_ episodes: [Episode]) {
        rmEpisodes = episodes
    }
    
    func getEpisodes() -> [Episode] {
        return rmEpisodes
    }
    
    func clearEpisodes() {
        rmEpisodes = []
    }
}
