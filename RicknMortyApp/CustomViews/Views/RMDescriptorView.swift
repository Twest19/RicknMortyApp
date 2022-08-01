//
//  RMDescriptorView.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/27/22.
//

import UIKit

class RMDescriptorView: UIView {
    
    let descriptorLabel = RMSecondaryLabel(fontSize: 14)
    let infoLabel = RMPrimaryLabel(textAlignment: .left, fontSize: 16, weight: .semibold)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp(description: String, info: String) {
        descriptorLabel.text = description
        infoLabel.text = info
    }
    
    
    private func configure() {
        addSubviews(descriptorLabel, infoLabel)
        
        descriptorLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 3
        
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
