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
        translatesAutoresizingMaskIntoConstraints = false
        separatorStyle = .none
        self.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.reuseID)
    }
}
