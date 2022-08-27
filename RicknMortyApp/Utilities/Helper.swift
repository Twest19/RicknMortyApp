//
//  Helper.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/26/22.
//

import UIKit

enum Helper {
    static func threeColumnCollectionView(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 5
        let minimumItemSpacing: CGFloat = 10
        let availableWith = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWith / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    
    static func getEpisodeNumber(from episodeURLs: [String]) -> String {
        var justNumbers: [String] = []
        
        for url in episodeURLs {
            let splitString = url.split(whereSeparator: { $0 == "/"} )
            
            if let id = splitString.last {
                justNumbers.append(String(id))
            }
        }
        return justNumbers.joined(separator: ",")
    }
    
//    // Condensed version of the above. Use this to create one mass query with ID numbers.
//    static func getID(from url: [String]) -> String {
//        // Takes in an array of url strings and gets the ID number off the end of each url.
//        // Then adds all the ids to a string seperated by commas.
//        print(url.map({ $0.split(whereSeparator: { $0 == "/"})}).map({ Int($0.last!)! }).sorted().map({ "\($0)"}).joined(separator: ","))
//        return url.map({ $0.split(whereSeparator: { $0 == "/"})}).map({ "\($0.last!)"}).sorted().joined(separator: ",")
//    }
    
    
    static func getID(from url: [String]) -> String {
        
        return url.map({ $0.split(whereSeparator: { $0 == "/"})}).map({ Int($0.last!)! }).sorted().map({ "\($0)"}).joined(separator: ",")
    }
    
    
    static func splitEpisodeCode(episode: String) -> [Substring] {
        var episode = episode
        let index = episode.index(episode.startIndex, offsetBy: 3)
        episode.insert(" ", at: index)
        
        return episode.split(whereSeparator: { $0 == " " })
    }
}
