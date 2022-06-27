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
    var rmStatusLabel = UILabel()
    
    static let identifier = "RMCharCell"
    var representedIdentifier: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //contentView.backgroundColor = .black
        contentView.addSubview(rmNameLabel)
        contentView.addSubview(rmImageView)
        contentView.addSubview(rmStatusLabel)
        contentView.clipsToBounds = true
        configureNameLabel()
        configureRMImage()
        configureStatusLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rmImageView.image = nil
    }
    
    
    
    func configureRMImage() {
        rmImageView.layer.cornerRadius = 8
        //rmImageView.backgroundColor = .systemCyan
        rmImageView.clipsToBounds = true
        
        // Constraints
        rmImageView.translatesAutoresizingMaskIntoConstraints = false
        rmImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        rmImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1.25).isActive = true
        //rmImageView.heightAnchor.constraint(equalToConstant: contentView.frame.height-35).isActive = true
        rmImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -35).isActive = true
        rmImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1.25).isActive = true
        
    }
    
    
    func configureNameLabel() {
        //rmNameLabel.backgroundColor = .green
        rmNameLabel.clipsToBounds = true
        rmNameLabel.font = .systemFont(ofSize: 14, weight: .bold)
        rmNameLabel.numberOfLines = 1
        rmNameLabel.lineBreakMode = .byTruncatingTail
        rmNameLabel.textAlignment = .center
        rmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rmNameLabel.topAnchor.constraint(equalTo: rmImageView.bottomAnchor, constant: 2).isActive = true
        rmNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        rmNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        
    }
    
    func configureStatusLabel() {
        //rmStatusLabel.backgroundColor = .blue
        rmStatusLabel.clipsToBounds = true
        rmStatusLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        rmStatusLabel.numberOfLines = 1
        rmStatusLabel.textAlignment = .left
        rmStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        rmStatusLabel.topAnchor.constraint(equalTo: rmNameLabel.bottomAnchor, constant: 1).isActive = true
        rmStatusLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        rmStatusLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
    }
    
    
}
