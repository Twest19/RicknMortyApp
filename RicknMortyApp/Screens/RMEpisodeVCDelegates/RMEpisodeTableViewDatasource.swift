//
//  RMEpisodeTableViewDatasource.swift
//  RicknMortyApp
//
//  Created by Tim West on 12/8/23.
//


import UIKit

class RMEpisodeTableViewDatasource: NSObject, UITableViewDataSource {
    
    weak var parentVC: RMEpisodeVC?
    
    init(parentVC: RMEpisodeVC) {
        self.parentVC = parentVC
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let parentVC = parentVC else { return 0 }
        return parentVC.dataStore.getSeasons().count
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let parentVC = parentVC else { return "" }
        return parentVC.dataStore.getSeasons(by: section)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let parentVC = parentVC else { return 0 }
        let season = parentVC.dataStore.getSeasons(by: section)
//        if let hasEpisodes = dataStore.getEpisodeArray(from: season) { return hasEpisodes.count }
//        return 0
        return parentVC.dataStore.getEpisodeArray(from: season)?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseID, for: indexPath) as! EpisodeCell
        guard let parentVC = parentVC else { return cell }
        let season = parentVC.dataStore.getSeasons(by: indexPath.section)
        let items = parentVC.dataStore.getEpisode(from: season, index: indexPath.row)
        cell.updateCell(with: items, delegate: parentVC)
        return cell
    }
}
