//
//  RickMortyModel.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

// MARK: - Info
struct Info: Decodable {
    let count: Int
    var pages: Int
    let next: String?
    let prev: String?
}


struct RMResults: Decodable {
    var info: Info
    var results: [RMCharacter]
}

struct RMCharacter: Decodable {
    var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var origin: Origin
    var location: Location
    var image: String
    var episode: [String]
    
}

struct Origin: Decodable {
    var name: String
    var url: String
}

struct Location: Decodable {
    var name: String
    var url: String
}


