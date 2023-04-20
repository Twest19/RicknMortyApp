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
    private var episodesBySeason: [String: [Episode]] = [:]
    private var seasons: [String] = []
    
    private init() {}
    
    
    // MARK: Characters
    func saveCharacters(_ character: [RMCharacter]) {
        rmCharacters.append(contentsOf: character)
    }
   
    func getCharactersAt(index: Int) -> RMCharacter {
        return rmCharacters[index]
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
    func saveEpisodesBySeason(episodes: [Episode]) {
        for episode in episodes {
            if episodesBySeason[episode.season] != nil {
                sortEpisodesInOrder(episode, in: &episodesBySeason[episode.season]!)
            } else {
                episodesBySeason[episode.season] = [episode]
            }
        }
        seasons = getSortedSeasons()
    }
    
    private func sortEpisodesInOrder(_ episode: Episode, in seasonEpisodes: inout [Episode]) {
        let index = seasonEpisodes.firstIndex { $0.id > episode.id } ?? seasonEpisodes.endIndex
        seasonEpisodes.insert(episode, at: index)
    }
    
    func saveEpisodes(_ episodes: [Episode]) {
        rmEpisodes = episodes
    }
    
    func getEpisodesBySeason() -> [String: [Episode]] {
        return episodesBySeason
    }
    
    func getEpisode(from season: String, index: Int) -> Episode {
        return episodesBySeason[season]![index]
    }
    
    func getEpisodeArray(from season: String) -> [Episode]? {
        return episodesBySeason[season]
    }
    
    func getEpisodes() -> [Episode] {
        return rmEpisodes
    }
    
    
    // MARK: Episode - Season:
    func getSortedSeasons() -> [String] {
        return episodesBySeason.keys.sorted()
    }
    
    func getSeasons() -> [String] {
        return seasons
    }
    
    func getSeasons(by index: Int) -> String {
        return seasons[index]
    }
    
    
    // MARK: Clear
    func clearEpisodes() {
        rmEpisodes = []
    }
    
    func clearSeasonsAndEpisodes() {
        episodesBySeason = [:]
    }
}
