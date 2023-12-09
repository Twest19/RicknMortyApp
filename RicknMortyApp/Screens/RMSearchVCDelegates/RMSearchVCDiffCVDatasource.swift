//
//  RMSearchVCDiffCVDatasource.swift
//  RicknMortyApp
//
//  Created by Tim West on 12/8/23.
//

import UIKit


class RMSearchVCDiffCVDatasource: NSObject {
    
    private enum CharacterListSection: Int {
        case main
    }
    
    private var characterListDataSource: UICollectionViewDiffableDataSource<CharacterListSection, RMCharacter.ID>!
    
    weak var parentVC: RMSearchVC?
    
    init(parentVC: RMSearchVC) {
        self.parentVC = parentVC
    }
    
    // MARK: CollectionView DataSource
    func configureDataSource() {
        guard let parentVC = parentVC else { return }
        
        let characterCellRegistration = UICollectionView.CellRegistration<RMCharacterCell, RMCharacter> { cell, indexPath, character in
            cell.cellRepresentedIdentifier = character.id
            cell.set(character: character, representedIdentifier: character.id)
        }
        
        characterListDataSource = UICollectionViewDiffableDataSource(collectionView: parentVC.collectionView,
                                                                     cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            let character = parentVC.dataStore.character(with: itemIdentifier)
            return collectionView.dequeueConfiguredReusableCell(using: characterCellRegistration, for: indexPath, item: character)
        })
    }
    
    // MARK: Update Screen
    func updateUI(with characters: [RMCharacter]) {
        guard let parentVC = parentVC else { return }
        
        parentVC.dataStore.saveCharacters(characters)
        updateData(on: parentVC.dataStore.getCharacters())
    }
    
    // MARK: Update DataSource
    private func updateData(on characters: [RMCharacter]) {
        guard let parentVC = parentVC else { return }
        
        let charID = parentVC.dataStore.getCharacterIds()
        var snapshot = NSDiffableDataSourceSnapshot<CharacterListSection, RMCharacter.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(charID, toSection: .main)
        DispatchQueue.main.async {
            self.characterListDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
