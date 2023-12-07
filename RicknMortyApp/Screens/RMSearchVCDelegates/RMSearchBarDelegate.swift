//
//  RMSearchBarDelegate.swift
//  RicknMortyApp
//
//  Created by Tim West on 12/6/23.
//

import UIKit


class RMSearchBarDelegate: NSObject, UISearchBarDelegate {
    
    weak var parentVC: RMSearchVC?
    
    init(parentVC: RMSearchVC) {
        self.parentVC = parentVC
    }

    
    // Determines if the search bar should be showing
    func showSearchBarButton(shouldShow: Bool) {
        guard let parentVC = parentVC else { return }
        
        switch shouldShow {
        case true:
            parentVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchbar))
        case false:
            parentVC.navigationItem.rightBarButtonItem = nil
        }
    }
    
    
    func search(shouldShow: Bool) {
        guard let parentVC = parentVC else { return }
        
        showSearchBarButton(shouldShow: !shouldShow)
        parentVC.searchBar.showsCancelButton = shouldShow
        parentVC.navigationItem.titleView = shouldShow ? parentVC.searchBar : nil
    }
    
    // Cancel is clicked the search bar should not be showing
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let parentVC = parentVC else { return }
        search(shouldShow: false)
        searchBar.resignFirstResponder()
        if let searchedItem = searchBar.text {
            // Since the title is set at each network call we check that the searchBar text does not equal the current title.
            // This prevents unnecessary calls
            if searchBar.text != parentVC.title {
                parentVC.resetScreen()
                parentVC.searchedText = searchedItem
                parentVC.fetchCharacterData(pageNum: parentVC.currentPage, searchBarText: searchedItem)
                parentVC.collectionViewDelegate.scrollToTop(animated: false)
                parentVC.configureDataSource()
            }
        }
    }
    
    
    @objc func showSearchbar() {
        guard let parentVC = parentVC else { return }
        search(shouldShow: true)
        parentVC.searchBar.becomeFirstResponder()
    }
}
