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
            
            if let new = splitString.last {
                justNumbers.append(String(new))
            }
        }
        
        return justNumbers.joined(separator: ",")
    }
}


public enum Status: String {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
    case none = ""
}
