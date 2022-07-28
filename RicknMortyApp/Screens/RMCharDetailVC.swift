//
//  CharDetailVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/25/22.
//

import UIKit

class RMCharDetailVC: UIViewController {
    
    let characterImageView = RMCharacterImageView(frame: .zero)
    let nameLabel = RMPrimaryLabel(textAlignment: .left, fontSize: 20, weight: .bold)
    let statusSpeciesGenderLabel = RMPrimaryLabel(textAlignment: .left, fontSize: 14, weight: .medium)
    let stackView = UIStackView()
    let lastLocationLabel = RMDescriptorView()
    let originLabel = RMDescriptorView()
    let firstEpisodeLabel = RMDescriptorView()
    let lastEpisodeLabel = RMDescriptorView()
    
    var views: [RMDescriptorView] = []
    
    private let padding: CGFloat = 5
    var character: RMCharacter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addingSubViews()
        configNavBar()
        configureCharacterImageView()
        configureNameLabel()
        configureStatusSpeciesGenderLabel()
        configureStackView()
    }
    
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
    
        stackView.addArrangedSubview(lastLocationLabel)
        stackView.addArrangedSubview(originLabel)
        stackView.addArrangedSubview(firstEpisodeLabel)
        stackView.addArrangedSubview(lastEpisodeLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: statusSpeciesGenderLabel.bottomAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    
    func addingSubViews() {
        view.addSubviews(characterImageView, nameLabel, statusSpeciesGenderLabel, stackView)
    }
    
    
    func setUIElements(for character: RMCharacter) {
        characterImageView.downloadImage(from: character.image)
        nameLabel.text = character.name
        statusSpeciesGenderLabel.text = "\(character.status) - \(character.species) - \(character.gender)"
        lastLocationLabel.setInfo(for: character, type: .location)
        originLabel.setInfo(for: character, type: .origin)
        firstEpisodeLabel.setInfo(for: character, type: .firstEpisode)
        lastLocationLabel.setInfo(for: character, type: .lastEpisode)
    }
    
    
    func configureCharacterImageView() {
        
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            characterImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: 300),
            characterImageView.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    
    private func configureNameLabel() {
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    
    private func configureStatusSpeciesGenderLabel() {
        NSLayoutConstraint.activate([
            statusSpeciesGenderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3),
            statusSpeciesGenderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            statusSpeciesGenderLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            statusSpeciesGenderLabel.heightAnchor.constraint(equalToConstant: 18)
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
