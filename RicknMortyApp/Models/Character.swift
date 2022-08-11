//
//  RickMortyModel.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

// MARK: Character Models
struct RMResults: Decodable {
    let info: Info
    let results: [RMCharacter]
}

struct RMCharacter: Identifiable, Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Origin
    let location: Location
    let image: String
    let episode: [String]
    
    var statusSpeciesGender: String {
        return "\(status) - \(species) - \(gender)"
    }
}

struct Origin: Decodable {
    let name: String
    let url: String
}

struct Location: Decodable {
    let name: String
    let url: String
}


