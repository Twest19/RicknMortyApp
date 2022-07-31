//
//  RMDescriptorStackView.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/31/22.
//

import UIKit

class RMStackView: UIStackView {
    
    let lastLocationLabel = RMDescriptorView()
    let originLabel = RMDescriptorView()
    let firstEpisodeLabel = RMDescriptorView()
    let lastEpisodeLabel = RMDescriptorView()
    
    var character: RMCharacter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureDescriptorViews()
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDescriptorViews() {
        lastLocationLabel.setUp(description: DescriptorType.location, info: character.location.name)
        originLabel.setUp(description: DescriptorType.origin, info: character.origin.name)
        firstEpisodeLabel.setUp(description: DescriptorType.firstEpisode, info: character.episode[0])
        lastLocationLabel.setUp(description: DescriptorType.lastEpisode, info: "\(character.episode.suffix(1))")
    }
    
    
    private func configure() {
        axis = .vertical
        distribution = .fillEqually
        translatesAutoresizingMaskIntoConstraints = false
        
        let descriptorViews = [lastLocationLabel, originLabel, firstEpisodeLabel, lastEpisodeLabel]
        for view in descriptorViews {
            addArrangedSubview(view)
        }
    }
}
