//
//  CharDetailVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/25/22.
//

import UIKit

class RMCharDetailVC: UIViewController {
    
    let characterImageView = RMCharacterImageView(frame: .zero)
    let statusImageView = RMStatusImageView(sfSymbol: SFSymbols.circle)
    let nameLabel = RMPrimaryLabel(textAlignment: .left, fontSize: 20, weight: .bold)
    let statusSpeciesGenderLabel = RMPrimaryLabel(textAlignment: .left, fontSize: 14, weight: .medium)
    let lastLocationLabel = RMDescriptorView()
    let originLabel = RMDescriptorView()
    
    let stackView = UIStackView()
    
    let firstEpisodeLabel = RMDescriptorView()
    let lastEpisodeLabel = RMDescriptorView()
    
    var views: [RMDescriptorView] = []
    
    private let padding: CGFloat = 10
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addingSubViews()
        configNavBar()
        configureCharacterImageView()
        configureNameLabel()
        configureStatusImageView()
        configureStatusSpeciesGenderLabel()
        configureOriginLabel()
        configureLastLocationLabel()
        configureStackView()
    }
    
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let descriptorViews = [firstEpisodeLabel, lastEpisodeLabel]
        for view in descriptorViews {
            stackView.addArrangedSubview(view)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    
    func addingSubViews() {
        view.addSubviews(characterImageView, nameLabel, statusImageView, statusSpeciesGenderLabel, originLabel, lastLocationLabel, stackView)
    }
    
    
    func setUIElements(for character: RMCharacter) {
        characterImageView.downloadImage(from: character.image)
        nameLabel.text = character.name
        statusImageView.setStatus(for: character.status)
        statusSpeciesGenderLabel.text = "\(character.status) - \(character.species) - \(character.gender)"
        configureDescriptorViews(character: character)
    }
    
    
    func configureDescriptorViews(character: RMCharacter) {
        lastLocationLabel.setUp(description: DescriptorType.location, info: character.location.name)
        originLabel.setUp(description: DescriptorType.origin, info: character.origin.name)
        firstEpisodeLabel.setUp(description: DescriptorType.firstEpisode, info: character.episode.first ?? "N/A")
        lastEpisodeLabel.setUp(description: DescriptorType.lastEpisode, info: character.episode.last ?? "N/A")
    }
    
    
    func configureCharacterImageView() {
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            characterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            characterImageView.heightAnchor.constraint(equalToConstant: 150),
            characterImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
    private func configureNameLabel() {
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
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
            statusSpeciesGenderLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: padding),
            statusSpeciesGenderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            statusSpeciesGenderLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    
    private func configureOriginLabel() {
        originLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            originLabel.topAnchor.constraint(equalTo: statusSpeciesGenderLabel.bottomAnchor, constant: padding),
            originLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 8),
            originLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            originLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    private func configureLastLocationLabel() {
        lastLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lastLocationLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: padding),
            lastLocationLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 8),
            lastLocationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            lastLocationLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    func configNavBar() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSelf))
        backButton.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = backButton
    }
    
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}
