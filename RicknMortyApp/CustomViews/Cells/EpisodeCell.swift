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
    
    
    public func updateCell(with episode: Episode, delegate: EpisodeVCDelegate) {
        episodeNameView.set(label: episode.nameAndEpisode)
        episodeHiddenView.set(episode: episode, delegate: delegate)
    }
    
    
    private func configureContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        selectionStyle = .none
        episodeHiddenView.isHidden = true
        containerView.axis = .vertical
        containerView.spacing = 5
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
        containerView.addArrangedSubviews(episodeNameView, episodeHiddenView)
    }
    
    
    func showEpisodeHiddenView() {
        episodeHiddenView.isHidden = false
    }

    
    func hideEpisodeHiddenView() {
        episodeHiddenView.isHidden = true
    }
}
