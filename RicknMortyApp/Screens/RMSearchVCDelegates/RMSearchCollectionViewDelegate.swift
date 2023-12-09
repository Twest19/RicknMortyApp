//
//  RMSearchCollectionViewDelegate.swift
//  RicknMortyApp
//
//  Created by Tim West on 12/6/23.
//

import UIKit

class RMSearchCollectionViewDelegate: NSObject, UICollectionViewDelegate {
    
    private var isSearching = false
    private let loadDelay: TimeInterval = 1
    
    weak var parentVC: RMSearchVC?
    
    init(parentVC: RMSearchVC) {
        self.parentVC = parentVC
    }
    
    // MARK: Pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let parentVC = parentVC else { return }
        
        if parentVC.currentPage < parentVC.totalPages && indexPath.item == parentVC.dataStore.getCharacters().count - 1 {
            guard !parentVC.isLoadingMoreCharacters else { return }
            parentVC.currentPage += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + loadDelay) {
                parentVC.fetchCharacterData(pageNum: parentVC.currentPage, searchBarText: parentVC.rmSearchBarDelegate.searchedText)
            }
        }
    }
    
    // Cell was tapped, presents modal/card view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let parentVC = parentVC else { return }
        
        if !isSearching { // Checks to make sure a network request is not in progress
            let selectedCharacter = parentVC.dataStore.getCharactersAt(index: indexPath.item)
            let detailVC = RMCharacterDetailVC(for: selectedCharacter, delegate: parentVC)
            let navController = UINavigationController(rootViewController: detailVC)
            navController.modalPresentationStyle = .popover
            parentVC.present(navController, animated: true)
        }
    }
    
    // Scrolls collection view back to the top. Goes slightly further far large title.
    func scrollToTop(animated: Bool) {
        guard let parentVC = parentVC  else { return }
        
        DispatchQueue.main.async {
            parentVC.collectionView.setContentOffset(CGPoint(x: 0, y: -parentVC.collectionView.adjustedContentInset.top - 1), animated: animated)
        }
    }
}
