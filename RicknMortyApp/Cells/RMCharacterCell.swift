//
//  RMCharacterCell.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

class RMCharacterCell: UICollectionViewCell {
    
    var characterImageView = RMCharacterImageView(frame: .zero)
    var characterNameLabel = RMPrimaryLabel(textAlignment: .center, fontSize: 16, weight: .bold)
    var statusImageView = UIImageView()
    var statusLabel = RMSecondaryLabel(fontSize: 14)
    var imageIncomingIndicator = UIActivityIndicatorView()
    
    private let padding: CGFloat = 5
    
    static let identifier = "RMCharCell"
    
    // Used to prevent incorrect images in cells
    var cellRepresentedIdentifier: Int = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
        configureCharacterImageView()
        configureActivityIndicator()
        configureNameLabel()
        configureStatusImageView()
        configureStatusLabel()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = Images.placeHolder
    }
    
    
    func setStatus(for status: String) {
        
        switch status {
        case "Alive":
            statusImageView.tintColor = .systemGreen
        case "Dead":
            statusImageView.tintColor = .systemRed
        default:
            statusImageView.tintColor = .secondaryLabel
        }
        
        statusLabel.text = status
    }
    
    
    func set(character: RMCharacter, representedIdentifier: Int) {
        startIndicator()
        downloadCharacterImage(from: character.image, id: representedIdentifier)
        characterNameLabel.text = character.name
        setStatus(for: character.status)
        stopIndicator()
    }
    
    
    func downloadCharacterImage(from url: String, id: Int) {
        // Set cell's image, also caches
        NetworkManager.shared.image(name: url) { [weak self] data, error in
            guard let self = self else { return }
            let img = self.characterImageView.makeImage(data: data)
            DispatchQueue.main.async {
                if (self.cellRepresentedIdentifier == id) {
                    self.characterImageView.image = img
                }
            }
        }
    }
    
    
    func startIndicator() {
        DispatchQueue.main.async {
            self.imageIncomingIndicator.startAnimating()
        }
    }
    
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.imageIncomingIndicator.stopAnimating()
        }
    }
    
    
    func configureContentView() {
        contentView.clipsToBounds = true
        contentView.addSubviews(characterImageView, imageIncomingIndicator, characterNameLabel, statusImageView, statusLabel)
    }
    
    
    private func configureCharacterImageView() {
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            characterImageView.heightAnchor.constraint(equalTo: characterImageView.widthAnchor)
        ])
    }
    
    
    private func configureActivityIndicator() {
        imageIncomingIndicator.hidesWhenStopped = true
        imageIncomingIndicator.pinToCenter(of: characterImageView)
    }
    
    
    private func configureNameLabel() {
        
        NSLayoutConstraint.activate([
            characterNameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 2),
            characterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            characterNameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    private func configureStatusImageView() {
        statusImageView.image = SFSymbols.circle
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            statusImageView.leadingAnchor.constraint(equalTo: characterNameLabel.leadingAnchor, constant: 2),
            statusImageView.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 2),
            statusImageView.heightAnchor.constraint(equalToConstant: 18),
            statusImageView.widthAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    
    private func configureStatusLabel() {
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 2),
            statusLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: padding),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            statusLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}
