//
//  EpisodeHiddenView.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//

import UIKit

class EpisodeHiddenView: UIView {
    
    weak var delegate: EpisodeVCDelegate?
    
    let labelStackView = UIStackView()
    let descriptorViewOne = RMDescriptorView()
    let descriptorViewTwo = RMDescriptorView()
    let seeCharacterButton = RMButton(color: .systemCyan, title: "View Characters")
    
    let padding: CGFloat = 10
    let leadingPadding: CGFloat = 20
    
    var episode: Episode!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        configureStackView()
        configure()
        configureEpisodeButton()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews(labelStackView, seeCharacterButton)
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 16
    }
    
    
    public func set(episode: Episode, delegate: EpisodeVCDelegate) {
        self.episode = episode
        self.delegate = delegate
        descriptorViewOne.setUp(description: DescriptorType.airDate, info: episode.airDate)
        descriptorViewTwo.setUp(description: DescriptorType.totalCharacters, info: String(episode.characters.count))
    }
    
    
    private func configureStackView() {
        descriptorViewOne.changeFont(size: 20)
        descriptorViewTwo.changeFont(size: 20)
        descriptorViewTwo.descriptorLabel.textAlignment = .center
        descriptorViewTwo.infoLabel.textAlignment = .center
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.addArrangedSubviews(descriptorViewOne, descriptorViewTwo)
        
        labelStackView.axis = .horizontal
        labelStackView.alignment = .leading
        labelStackView.spacing = 5
        labelStackView.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: leadingPadding),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingPadding),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelStackView.heightAnchor.constraint(equalToConstant: 57)
        ])
    }
    
    
    private func configure() {
        
        NSLayoutConstraint.activate([
            seeCharacterButton.topAnchor.constraint(equalTo: self.labelStackView.bottomAnchor, constant: padding),
            seeCharacterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingPadding),
            seeCharacterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -leadingPadding),
            seeCharacterButton.heightAnchor.constraint(equalToConstant: 46)
        ])
        // This constraint was causing issues. Setting priority to 999 solved those issues
        let constraint = seeCharacterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -leadingPadding)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
    }
    
    
    private func configureEpisodeButton() {
        seeCharacterButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    
    @objc func didTapButton() {
        if let delegate = delegate {
            delegate.didTapSeeCharactersButton(for: episode)
        }
    }
}


