//
//  RMDescriptorView.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/27/22.
//

import UIKit

enum DescriptorType {
    case location, firstEpisode, lastEpisode, origin
}

class RMDescriptorView: UIView {
    
    let descriptorLabel = RMSecondaryLabel(fontSize: 14)
    let infoLabel = RMPrimaryLabel(textAlignment: .left, fontSize: 16, weight: .semibold)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setInfo(for character: RMCharacter, type: DescriptorType) {
        switch type {
        case .location:
            descriptorLabel.text = "Last known location:"
            infoLabel.text = character.location.name
            print()
            print(character.episode.suffix(1))
            print()
        case .firstEpisode:
            descriptorLabel.text = "First seen in:"
            print(character.episode[0])
            infoLabel.text = "N/A"
        case .lastEpisode:
            descriptorLabel.text = "Last seen in:"
            print(character.episode.suffix(1))
            infoLabel.text = "N/A"
        case .origin:
            descriptorLabel.text = "Origin:"
            infoLabel.text = character.origin.name
        }
    }
    
    
    private func configure() {
        addSubviews(descriptorLabel, infoLabel)
        
        descriptorLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 5
        
        NSLayoutConstraint.activate([
            descriptorLabel.topAnchor.constraint(equalTo: self.topAnchor),
            descriptorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            descriptorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            descriptorLabel.heightAnchor.constraint(equalToConstant: 18),
            
            infoLabel.topAnchor.constraint(equalTo: descriptorLabel.bottomAnchor, constant: padding),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            infoLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
