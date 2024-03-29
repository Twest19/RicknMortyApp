//
//  EpisodeCell.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    static let reuseID = "EpisodeCell"
    
    let episodeNameView = EpisodeNameView()
    let episodeHiddenView = EpisodeHiddenView()
    
    var isEpisodeHiddenView: Bool {
        return episodeHiddenView.isHidden
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    public func updateCell(with episode: Episode, delegate: EpisodeVCDelegate) {
        episodeNameView.set(label: episode.numberAndName)
        episodeHiddenView.set(episode: episode, delegate: delegate)
    }

    
    private func configureCell() {
        contentView.addSubviews(episodeNameView, episodeHiddenView)
        contentView.clipsToBounds = true
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            episodeNameView.topAnchor.constraint(equalTo: contentView.topAnchor),
            episodeNameView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            episodeNameView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            episodeNameView.heightAnchor.constraint(equalToConstant: 55),
            
            episodeHiddenView.topAnchor.constraint(equalTo: episodeNameView.bottomAnchor, constant: 10),
            episodeHiddenView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            episodeHiddenView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            episodeHiddenView.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
}
