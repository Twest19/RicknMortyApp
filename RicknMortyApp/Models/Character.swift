//
//  RickMortyModel.swift
//  RicknMortyApp
//

import UIKit

// MARK: RMResults Model
struct RMResults: Decodable {
    let info: Info
    let results: [RMCharacter]
}

// MARK: RMCharacter Model
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

// MARK: Origin Model
struct Origin: Decodable {
    let name: String
    let url: String
}

// MARK: Location Model
struct Location: Decodable {
    let name: String
    let url: String
}
