//
//  File.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/2/22.
//

import Foundation

// Rick and Morty Episode Data
struct Episode: Decodable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
}
