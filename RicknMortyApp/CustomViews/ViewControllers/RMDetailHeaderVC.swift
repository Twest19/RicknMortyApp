//
//  RMCharacterDetailVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/2/22.
//

import UIKit

class RMDetailHeaderVC: UIViewController {
    
    let characterImageView = RMCharacterImageView(frame: .zero)
    let statusImageView = RMStatusImageView(sfSymbol: SFSymbols.circle)
    let nameLabel = RMPrimaryLabel(textAlignment: .left, fontSize: 20, weight: .bold)
    let statusSpeciesGenderLabel = RMPrimaryLabel(textAlignment: .left, fontSize: 14, weight: .medium)
    let lastLocationLabel = RMDescriptorView()
    let originLabel = RMDescriptorView()
    
    var character: RMCharacter!
    
    private let padding: CGFloat = 10
    
    
    init(character: RMCharacter) {
        super.init(nibName: nil, bundle: nil)
        self.character = character
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addingSubViews()
        configureCharacterImageView()
        configureNameLabel()
        configureStatusImageView()
        configureStatusSpeciesGenderLabel()
        configureOriginLabel()
        configureLastLocationLabel()
        setUIElements()
    }
    
    
    private func addingSubViews() {
        view.addSubviews(characterImageView, nameLabel, statusImageView, statusSpeciesGenderLabel, originLabel, lastLocationLabel)
    }
    
    
    func setUIElements() {
        characterImageView.downloadImage(from: character.image)
        statusImageView.setStatus(for: character.status)
        
        nameLabel.text = character.name
        statusSpeciesGenderLabel.text = "\(character.status) - \(character.species) - \(character.gender)"
        
        lastLocationLabel.setUp(description: DescriptorType.location, info: character.location.name)
        originLabel.setUp(description: DescriptorType.origin, info: character.origin.name)
    }
    
    
    func configureCharacterImageView() {
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            characterImageView.heightAnchor.constraint(equalToConstant: 150),
            characterImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
    private func configureNameLabel() {
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    
    private func configureStatusImageView() {
        
        NSLayoutConstraint.activate([
            statusImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            statusImageView.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: padding),
            statusImageView.heightAnchor.constraint(equalToConstant: 14),
            statusImageView.widthAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    
    private func configureStatusSpeciesGenderLabel() {
        
        NSLayoutConstraint.activate([
            statusSpeciesGenderLabel.centerYAnchor.constraint(equalTo: statusImageView.centerYAnchor),
            statusSpeciesGenderLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 2),
            statusSpeciesGenderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            statusSpeciesGenderLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    
    private func configureOriginLabel() {
        
        NSLayoutConstraint.activate([
            originLabel.topAnchor.constraint(equalTo: statusSpeciesGenderLabel.bottomAnchor, constant: padding),
            originLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 8),
            originLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            originLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    private func configureLastLocationLabel() {
        
        NSLayoutConstraint.activate([
            lastLocationLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: padding),
            lastLocationLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 8),
            lastLocationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            lastLocationLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
