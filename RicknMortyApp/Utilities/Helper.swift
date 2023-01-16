//
//  Helper.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/26/22.
//

import UIKit


// MARK: Helper enum for various utility type functions
enum Helper {
    
    
    // MARK: Create a three column CollectionView as seen in the Character Screen
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
    
    
    // MARK: Extracts the episode eumber so that a proper query can be made using the numbers.
    // Shorter version below...
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
    
    
    // MARK: Extracts the ID number off the end of the provided URLs.
    // Then returns a String of all the IDS to be used in a network request
    static func getID(from url: [String]) -> String {
        
        return url.map({ $0.split(whereSeparator: { $0 == "/"})}).map({ Int($0.last!)! }).sorted().map({ "\($0)"}).joined(separator: ",")
    }
    
    
    // MARK: Splits the episode code so that the season and episode number can be used
    // EX: S01E01 -> using the below and .first on the end returns S01
    // Using .last on the end returns the episode -> E01
    static func splitEpisodeCode(episode: String) -> [Substring] {
        var episode = episode
        let index = episode.index(episode.startIndex, offsetBy: 3)
        episode.insert(" ", at: index)
        
        return episode.split(whereSeparator: { $0 == " " })
    }
}
