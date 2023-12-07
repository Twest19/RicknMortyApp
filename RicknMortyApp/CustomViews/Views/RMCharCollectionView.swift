//
//  RMCharCollectionVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/4/22.
//

import UIKit

class RMCharCollectionView: UICollectionView {

    init(in view: UIView) {
        let layout = Helper.threeColumnCollectionView(in: view)
        super.init(frame: view.bounds, collectionViewLayout: layout)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerRMCharCells() {
        // Register Cells
        register(RMCharacterCell.self, forCellWithReuseIdentifier: RMCharacterCell.identifier)
        register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.identifier)
    }
    
    private func configure() {
        backgroundColor = .systemBackground
    }
}
