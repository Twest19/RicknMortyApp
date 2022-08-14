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
