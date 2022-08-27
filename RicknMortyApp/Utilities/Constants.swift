//
//  Constants.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/27/22.
//

import UIKit


enum SFSymbols {
    static let circle = UIImage(systemName: "circle.fill")
}


enum Images {
    static let placeHolder = UIImage(named: "RMPlaceholder")
    static let rmTwo = UIImage(named: "defaultTwo")
    static let errorImage = UIImage(named: "MrPErrorImage")
}


enum DescriptorType {
    static let location = "Last known location:"
    static let firstEpisode = "First seen in:"
    static let lastEpisode = "Last seen in:"
    static let origin = "Origin:"
    static let onlyOneEpisode = "Only seen in:"
    static let airDate = "Air Date:"
    static let totalCharacters = "Total Characters:"
}


enum Status: String {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
    case none = ""
}


//enum Seasons: Int {
//    case S01 = 11
//    case S02, S03, S04, S05 = 10
//}


enum Seasons: String {
    case S01 = "S01"
    case S02 = "S02"
    case S03 = "S03"
    case S04 = "S04"
    case S05 = "S05"
}
