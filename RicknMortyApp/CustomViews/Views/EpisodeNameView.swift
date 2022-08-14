//
//  EpisodeNameView.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/13/22.
//

import UIKit

class EpisodeNameView: UIView {
    
    let nameCodeLabel = RMPrimaryLabel(textAlignment: .left, fontSize: 25, weight: .semibold)
    private let padding: CGFloat = 10

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func set(label text: String) {
        nameCodeLabel.text = text
    }
    
    
    private func configure() {
        addSubview(nameCodeLabel)
        translatesAutoresizingMaskIntoConstraints = false
        
        nameCodeLabel.numberOfLines = 1
        
        NSLayoutConstraint.activate([
            nameCodeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            nameCodeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            nameCodeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            nameCodeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding)
        ])
    }
}
