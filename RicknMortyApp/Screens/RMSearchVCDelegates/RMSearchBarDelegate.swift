//
//  RMSearchBarDelegate.swift
//  RicknMortyApp
//
//  Created by Tim West on 12/6/23.
//

import UIKit


class RMSearchBarDelegate: NSObject, UISearchBarDelegate {
    
    var searchedText: String = ""
    weak var parentVC: RMSearchVC?
    
    init(parentVC: RMSearchVC) {
        self.parentVC = parentVC
    }

    // SearchBarDelegate Method
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    // SearchBarDelegate Method
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let parentVC = parentVC else { return }
        search(shouldShow: false)
        searchBar.resignFirstResponder()
        if let searchedItem = searchBar.text {
            // Since the title is set at each network call we check that the searchBar text does not equal the current title.
            // This prevents unnecessary calls
            if searchBar.text != parentVC.title {
                parentVC.resetScreen()
                searchedText = searchedItem
                parentVC.fetchCharacterData(pageNum: parentVC.currentPage, searchBarText: searchedItem)
                parentVC.collectionViewDelegate.scrollToTop(animated: false)
                parentVC.collectionViewDatasource.configureDataSource()
            }
        }
    }
}


extension RMSearchBarDelegate {
    
    // Determines if the search bar magnifying glass symbol should show
    func showSearchBarButton(shouldShow: Bool) {
        guard let parentVC = parentVC else { return }
        
        switch shouldShow {
        case true:
            parentVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchbar))
        case false:
            parentVC.navigationItem.rightBarButtonItem = nil
        }
    }
    
    // Applying the showing/hiding of search bar
    func search(shouldShow: Bool) {
        guard let parentVC = parentVC else { return }
        
        showSearchBarButton(shouldShow: !shouldShow)
        parentVC.searchBar.showsCancelButton = shouldShow
        parentVC.navigationItem.titleView = shouldShow ? parentVC.searchBar : nil
    }
    
    @objc func showSearchbar() {
        guard let parentVC = parentVC else { return }
        search(shouldShow: true)
        parentVC.searchBar.becomeFirstResponder()
    }
}
