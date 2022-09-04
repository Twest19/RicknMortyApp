//
//  RMEpisodeVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//

import UIKit

class RMEpisodeVC: RMDataLoadingVC {
    
    private enum EpisodeListSection: Int {
        case main
    }
    
    private let tableView = RMEpisodeTableView()
    public weak var delegate: RMCharacterDetailVCDelegate!
        
    private var episodesBySeason: [String: [Episode]] = [:]
    private var seasons: [String] = []

    private var totalPages = 0
    private var currentPage = 1
    
    private var isLoadingEpisodeData: Bool = false
    
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
                self.updateUI(with: episode.results)
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
    
    
    private func updateUI(with episodes: [Episode]) {
        sort(episodes: episodes)
        episodesBySeason = episodesBySeason.mapValues({ $0.sorted(by: {$0.id < $1.id })})
        seasons = episodesBySeason.map{ $0.key }.sorted()
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
    
    
    private func sort(episodes: [Episode]) {
        for episode in episodes {
            if episodesBySeason[episode.season] != nil {
                episodesBySeason[episode.season]!.append(episode)
            } else {
                episodesBySeason[episode.season] = [episode]
            }
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
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn) { [unowned self] in
            self.tableView.performBatchUpdates(nil)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? EpisodeCell {
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut) { [unowned self] in
                self.tableView.performBatchUpdates(nil)
                cell.hideEpisodeHiddenView()
            }
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
