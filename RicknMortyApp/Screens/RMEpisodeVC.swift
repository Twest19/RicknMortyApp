//
//  RMEpisodeVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//

import UIKit

class RMEpisodeVC: RMDataLoadingVC {
    
    let tableView = RMEpisodeTableView()
    
    var episode: [Episode] = []
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        self.episode.append(contentsOf: episode)
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        navigationController?.navigationBar.tintColor = .systemCyan
        title = "Episodes"
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
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentPage < totalPages && indexPath.row == episode.count - 1 {
            guard !isLoadingEpisodeData else { return }
            currentPage += 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.getEpisodeData(pageNum: self.currentPage)
            }
        }
    }
}


extension RMEpisodeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episode.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.reuseID, for: indexPath) as! EpisodeCell
        cell.updateCell(with: episode[indexPath.row])
        return cell
    }
}
