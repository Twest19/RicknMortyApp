//
//  Info.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/10/22.
//

import Foundation

// MARK: - Info Model
struct Info: Decodable {
    let count: Int
    var pages: Int
    let next: String?
    let prev: String?
}
