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
    
    var defaultDescriptorFontSize: CGFloat = 14
    var defaultInfoFontSize: CGFloat = 16
    
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
    
    
    public func changeFont(size: CGFloat) {
        descriptorLabel.font = UIFont.systemFont(ofSize: size)
        infoLabel.font = UIFont.systemFont(ofSize: size + 2)
        
        defaultInfoFontSize = size
        defaultInfoFontSize = size
    }
    
    
    private func configure() {
        addSubviews(descriptorLabel, infoLabel)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptorLabel.topAnchor.constraint(equalTo: self.topAnchor),
            descriptorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptorLabel.heightAnchor.constraint(equalToConstant: defaultDescriptorFontSize + 4),
            
            infoLabel.topAnchor.constraint(equalTo: descriptorLabel.bottomAnchor, constant: 3),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            infoLabel.heightAnchor.constraint(equalToConstant: defaultInfoFontSize + 4)
        ])
    }
}
