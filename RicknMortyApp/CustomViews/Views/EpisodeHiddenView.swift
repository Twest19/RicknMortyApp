//
//  EpisodeHiddenView.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//

import UIKit

class EpisodeHiddenView: UIView {
    
    let labelStackView = UIStackView()
    let dateLabel = RMSecondaryLabel(fontSize: 20)
    let characterNumLabel = RMSecondaryLabel(fontSize: 20)
    let seeCharacterButton = RMButton(color: .systemCyan, title: "View Characters")
    
    let padding: CGFloat = 10
    let leadingPadding: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        self.addSubviews(labelStackView, seeCharacterButton)
        self.backgroundColor = .secondarySystemBackground
        configureStackView()
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
    
    
    private func configureStackView() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.addArrangedSubviews(dateLabel, characterNumLabel)
        
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.spacing = 5
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: leadingPadding),
            labelStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingPadding),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    
    private func configure() {
        
        NSLayoutConstraint.activate([
            seeCharacterButton.topAnchor.constraint(equalTo: self.labelStackView.bottomAnchor, constant: padding),
            seeCharacterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingPadding),
            seeCharacterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -leadingPadding),
            seeCharacterButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        let constraint = seeCharacterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -leadingPadding)
        constraint.priority = UILayoutPriority(999)
        constraint.isActive = true
    }
    
    
    private func configureEpisodeButton() {
        seeCharacterButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func actionButtonTapped() {
        print("TAPPED BUTTON")
    }
}
