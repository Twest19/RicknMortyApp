//
//  RMCharCollectionVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/4/22.
//

import UIKit

class RMCharCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        registerRMCharCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerRMCharCells() {
        // Register Cells
        register(RMCharacterCell.self, forCellWithReuseIdentifier: RMCharacterCell.identifier)
        register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.identifier)
    }
}
