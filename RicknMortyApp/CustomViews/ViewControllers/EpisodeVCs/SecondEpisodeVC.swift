//
//  SecondEpisodeVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/5/22.
//

import UIKit

class SecondEpisodeVC: RMEpisodeInfoVC {

    weak var delegate: EpisodeVCDelegate!
    
    var codeAndName: String {
        return "\(episode.episode) - \(episode.name)"
    }
    
    init(episode: Episode, delegate: EpisodeVCDelegate) {
        super.init(episode: episode)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    
    private func configureItems() {
        descriptorViewOne.setUp(description: DescriptorType.lastEpisode, info: codeAndName)
        descriptorViewTwo.setUp(description: DescriptorType.airDate, info: episode.airDate)
        actionButton.set(color: .systemCyan, title: "View Characters")
    }
    
    
    override func actionButtonTapped() {
        delegate.didTapSeeCharactersButton(for: episode)
    }
}
