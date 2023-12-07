//
//  RMEpisodeTableView.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//

import UIKit

class RMEpisodeTableView: UITableView {
    

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configureTableView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureTableView() {
        // Both row heights allow the differing size of expanded vs nonexpanded cells
        estimatedRowHeight = 220
        rowHeight = UITableView.automaticDimension
        translatesAutoresizingMaskIntoConstraints = false
//        separatorStyle = .none
        self.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseID)
    }
    
    func setupConstraints(in view: UIView) {
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
