//
//  RMEpisodeVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//

import UIKit

class RMEpisodeVC: RMDataLoadingVC {
    
    let tableView = RMEpisodeTableView()
    weak var delegate: RMCharacterDetailVCDelegate!
    
//    var episode: [Episode] = []
    var episodesBySeason: [String: [Episode]] = [:]
    var seasons: [String] = []

    var totalPages = 0
    var currentPage = 1
    
    var isLoadingEpisodeData: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        configureNavBar()
        configureTableView()
        getEpisodeData(pageNum: currentPage)
    }
    
    
    func getEpisodeData(pageNum: Int) {
        isLoadingEpisodeData = true
        showLoadingView()
        
        NetworkManager.shared.getEpisode(pageNum: pageNum) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let episode):
                print(episode.info.pages)
                self.totalPages = episode.info.pages
                self.updateUI(episode: episode.results)
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
    
    
    private func updateUI(episode: [Episode]) {
        
        for ep in episode {
            if episodesBySeason[ep.season] != nil {
                episodesBySeason[ep.season]!.append(ep)
                print("WORK")
            } else {
                episodesBySeason[ep.season] = [ep]
                print("NO")
            }
        }
        
        episodesBySeason = episodesBySeason.mapValues({ $0.sorted(by: {$0.id < $1.id })})
        seasons = episodesBySeason.map{ $0.key }.sorted()

        DispatchQueue.main.async {
            self.tableView.reloadData()
            print()
            print("RELOADING")
            print()
        }
    }
    
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 120
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.performBatchUpdates(nil)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? EpisodeCell {
            cell.hideEpisodeHiddenView()
        }
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            if currentPage < totalPages {
                guard !isLoadingEpisodeData else { return }
                currentPage += 1
                DispatchQueue.main.async {
                    self.getEpisodeData(pageNum: self.currentPage)
                }
            }
        }
    }
}


extension RMEpisodeVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return seasons.count
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return seasons[section]
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let season = seasons[section]
        
        if let hasEpisodes = episodesBySeason[season] {
            return hasEpisodes.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseID, for: indexPath) as! EpisodeCell
        let season = seasons[indexPath.section]
        let items = episodesBySeason[season]![indexPath.row]
        cell.updateCell(with: items, delegate: self)
        return cell
    }
}


extension RMEpisodeVC: EpisodeVCDelegate {
    func didTapSeeCharactersButton(for episode: Episode) {
        delegate.didRequestEpisodeCharacters(for: episode)
        if let index = tabBarController?.viewControllers?.firstIndex(where: { $0 is UINavigationController }) {
            tabBarController?.selectedIndex = index
        }
    }
}
