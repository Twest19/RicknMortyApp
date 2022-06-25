//
//  RMCharacterCell.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

class RMCharacterCell: UICollectionViewCell {
    
    var rmImageView = UIImageView()
    var rmNameLabel = UILabel()
    
    static let identifier = "RMCharCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //contentView.backgroundColor = .black
        contentView.addSubview(rmNameLabel)
        contentView.addSubview(rmImageView)
        contentView.clipsToBounds = true
        configureNameLabel()
        configureRMImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureRMImage() {
        rmImageView.layer.cornerRadius = 8
        //rmImageView.backgroundColor = .systemCyan
        rmImageView.clipsToBounds = true
        
        // Constraints
        rmImageView.translatesAutoresizingMaskIntoConstraints = false
        rmImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        rmImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3).isActive = true
        rmImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height-30).isActive = true
        rmImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1.25).isActive = true
        
    }
    
    
    func configureNameLabel() {
        rmNameLabel.clipsToBounds = true
        rmNameLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        rmNameLabel.numberOfLines = 1
        rmNameLabel.lineBreakMode = .byTruncatingTail
        rmNameLabel.textAlignment = .center
        rmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rmNameLabel.topAnchor.constraint(equalTo: rmImageView.bottomAnchor, constant: 5).isActive = true
        rmNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        rmNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        
    }
    
    
}
