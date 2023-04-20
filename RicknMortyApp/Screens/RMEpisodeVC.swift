//
//  RMEpisodeVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//

import UIKit

class RMEpisodeVC: RMDataLoadingVC {
        
    private let tableView = RMEpisodeTableView()
    public weak var delegate: RMCharacterDetailVCDelegate!
    
    let dataStore = RMDataStore.shared

    var totalPages = 0
    var currentPage = 1
    
    var isLoadingEpisodeData: Bool = false
    
    private var selectedIndex : IndexPath = IndexPath(row: -1, section: -1)
    private var isCollapsed = false
    private var notVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        configureTableView()
        fetchEpisodeData(pageNum: currentPage)
    }
    
    
    func updateUI() {
        DispatchQueue.main.async { self.tableView.reloadData() }
    }

    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        // Both row heights allow the differing size of expanded vs nonexpanded cells
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.systemCyan]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.systemCyan]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.title = "Episodes"
        view.backgroundColor = .systemBackground
    }
}


extension RMEpisodeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Creates a bigger cell size to reveal hidden details
        if selectedIndex == indexPath && isCollapsed == true {
            return 250
        }
        // Not selected/expanded? Returns a default size of 60
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Collapses and opens the episode cells
        if selectedIndex == indexPath {
            switch isCollapsed {
            case false:
                isCollapsed = true
            case true:
                isCollapsed = false
            }
        } else {
            isCollapsed = true
        }
        
        selectedIndex = indexPath
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        // Helps prevent bottom most cells from being hidden when selected and expanded
        tableView.endUpdates()
        
        if tableView.visibleCells.last?.isEqual(tableView.cellForRow(at: indexPath)) ?? false {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Pagination for episodes/seasons
        if offsetY > contentHeight - height {
            if currentPage < totalPages {
                guard !isLoadingEpisodeData else { return }
                currentPage += 1
                DispatchQueue.main.async {
                    self.fetchEpisodeData(pageNum: self.currentPage)
                }
            }
        }
    }
}


extension RMEpisodeVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataStore.getSeasons().count
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataStore.getSeasons(by: section)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let season = dataStore.getSeasons(by: section)
        if let hasEpisodes = dataStore.getEpisodeArray(from: season) { return hasEpisodes.count }
        return 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseID, for: indexPath) as! EpisodeCell
        let season = dataStore.getSeasons(by: indexPath.section)
        let items = dataStore.getEpisode(from: season, index: indexPath.row)
        cell.updateCell(with: items, delegate: self)
        return cell
    }
}


extension RMEpisodeVC: EpisodeVCDelegate {
    func didTapSeeCharactersButton(for episode: Episode) {
        delegate.didRequestEpisodeCharacters(for: episode)
        // Navigates back to the Character Tab to view the characters when tapping "view character" button for a selected episode
        if let index = tabBarController?.viewControllers?.firstIndex(where: { $0 is UINavigationController }) {
            tabBarController?.selectedIndex = index
        }
    }
}
