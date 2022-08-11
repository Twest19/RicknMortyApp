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
    
    
    public func setUp(description: String, info: String) {
        descriptorLabel.text = description
        infoLabel.text = info
    }
    
    
    private func configure() {
        addSubviews(descriptorLabel, infoLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptorLabel.topAnchor.constraint(equalTo: self.topAnchor),
            descriptorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptorLabel.heightAnchor.constraint(equalToConstant: 18),
            
            infoLabel.topAnchor.constraint(equalTo: descriptorLabel.bottomAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
