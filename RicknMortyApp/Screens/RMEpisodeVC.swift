//
//  RMEpisodeVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//  UPDATED 12/8/23

import UIKit

class RMEpisodeVC: RMDataLoadingVC {
    
    public weak var delegate: RMCharacterDetailVCDelegate!
    let tableView = RMEpisodeTableView()
    var tableViewDelegate: RMEpisodeTableViewDelegate!
    var tableViewDatasource: RMEpisodeTableViewDatasource!
    
    let dataStore = RMDataStore.shared

    var totalPages = 0
    var currentPage = 1
    var isLoadingEpisodeData: Bool = false
    
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
        tableViewDelegate = RMEpisodeTableViewDelegate(parentVC: self)
        tableView.delegate = tableViewDelegate
        tableViewDatasource = RMEpisodeTableViewDatasource(parentVC: self)
        tableView.dataSource = tableViewDatasource
        view.addSubview(tableView)
        tableView.setupConstraints(in: view)
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

extension RMEpisodeVC: EpisodeVCDelegate {
    func didTapSeeCharactersButton(for episode: Episode) {
        guard let delegate = delegate else { return }
        delegate.didRequestEpisodeCharacters(for: episode)
        // Navigates back to the Character Tab to view the characters when tapping "view character" button for a selected episode
        if let index = tabBarController?.viewControllers?.firstIndex(where: { $0 is UINavigationController }) {
            tabBarController?.selectedIndex = index
        }
    }
}
