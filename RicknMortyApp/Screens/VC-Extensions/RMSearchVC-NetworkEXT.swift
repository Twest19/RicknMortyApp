//
//  RMSearchVC-NetworkEXT.swift
//  RicknMortyApp
//
//  Created by Tim West on 4/7/23.
//

import Foundation

extension RMSearchVC {
    
    // MARK: Standard Character or Search Character Request
    func fetchCharacterData(pageNum: Int, searchBarText: String = "") {
        self.showLoadingView()
        self.isLoadingMoreCharacters = true
        self.dismissErrorView()
        
        NetworkManager.shared.getCharacters(pageNum: pageNum, searchBarText: searchBarText) { [weak self] result in
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let character):
                self.setTitle(with: searchBarText)
                self.totalPages = character.info.pages
                self.collectionViewDatasource.updateUI(with: character.results)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorView(with: error, in: self.view)
                }
            }
            self.isLoadingMoreCharacters = false
        }
    }

    
    // MARK: Character from Episode Request
    // No pagination required with this request hence why the above request is not reused
    func fetchEpisodeCharacterData(with characterIDs: String) {
        self.showLoadingView()
        NetworkManager.shared.getCharacters(using: characterIDs) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()

            switch result {
            case .success(let character):
                self.collectionViewDatasource.updateUI(with: character)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorView(with: error, in: self.view)
                }
            }
        }
    }
}
