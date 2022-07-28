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
}
