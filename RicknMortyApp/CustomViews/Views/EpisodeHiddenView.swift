//
//  EpisodeHiddenView.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//

import UIKit

class EpisodeHiddenView: UIView {
    
    let dateLabel = RMSecondaryLabel(fontSize: 20)
    let characterNumLabel = RMSecondaryLabel(fontSize: 20)
    let seeCharacterButton = RMButton(color: .systemCyan, title: "View Characters")
    
    let padding: CGFloat = 10
    let leadingPadding: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureEpisodeButton()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func set(date text: String, characterNum: Int) {
        dateLabel.text = "Air Date: \(text)"
        characterNumLabel.text = "Total Characters: \(characterNum)"
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(dateLabel, characterNumLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingPadding),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            dateLabel.bottomAnchor.constraint(equalTo: characterNumLabel.topAnchor, constant: -padding),
            
            characterNumLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: padding),
            characterNumLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingPadding),
            characterNumLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            characterNumLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
                    
//            seeCharacterButton.topAnchor.constraint(equalTo: characterNumLabel.bottomAnchor, constant: padding),
//            seeCharacterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingPadding),
//            seeCharacterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -leadingPadding),
//            seeCharacterButton.heightAnchor.constraint(equalToConstant: 45),
//            seeCharacterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
    
    
    private func configureEpisodeButton() {
        seeCharacterButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() {
        print("TAPPED BUTTON")
    }
}
