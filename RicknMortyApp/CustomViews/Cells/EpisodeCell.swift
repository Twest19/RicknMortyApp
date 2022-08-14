//
//  EpisodeCell.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    static let reuseID = "EpisodeCell"
    
    let containerView = UIStackView()
    let episodeNameView = EpisodeNameView()
    let episodeHiddenView = EpisodeHiddenView()
    
    var isEpisodeHiddenView: Bool {
        return episodeHiddenView.isHidden
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContainerView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        switch isEpisodeHiddenView && selected {
        case true:
            showEpisodeHiddenView()
        case false:
            hideEpisodeHiddenView()
        }
    }
    
    
    public func updateCell(with episode: Episode) {
        episodeNameView.set(label: episode.nameAndEpisode)
        episodeHiddenView.set(date: episode.airDate, characterNum: episode.characters.count)
    }
    
    
    private func configureContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        episodeHiddenView.isHidden = true
        containerView.axis = .vertical
        containerView.spacing = 5
        
        containerView.addArrangedSubviews(episodeNameView, episodeHiddenView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    
    func showEpisodeHiddenView() {
        episodeHiddenView.isHidden = false
    }
    
    
    func hideEpisodeHiddenView() {
        episodeHiddenView.isHidden = true
    }
}
