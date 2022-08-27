//
//  File.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/2/22.
//

import Foundation

struct EpisodeResults: Decodable {
    let info: Info
    let results: [Episode]
}

// Rick and Morty Episode Data
struct Episode: Decodable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    
    var nameAndEpisode: String {
        return "\(episode) - \(name)"
    }
    
    var season: String {
        return String(Helper.splitEpisodeCode(episode: episode).first!)
    }
    
    var episodeNumber: String {
        return String(Helper.splitEpisodeCode(episode: episode).last!)
    }
}
