//
//  RMEpisodeVC-NetworkEXT.swift
//  RicknMortyApp
//
//  Created by Tim West on 4/20/23.
//

import Foundation

extension RMEpisodeVC {
    
    func fetchEpisodeData(pageNum: Int) {
        isLoadingEpisodeData = true
        showLoadingView()
        
        NetworkManager.shared.getEpisode(pageNum: pageNum) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let episode):
                self.totalPages = episode.info.pages
                self.dataStore.saveEpisodesBySeason(episodes: episode.results)
                self.updateUI()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorView(with: error, in: self.view)
                    self.isLoadingEpisodeData = false
                }
                return
            }
            self.isLoadingEpisodeData = false
        }
    }
}
