//
//  EpisodeInfoVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/4/22.
//

import UIKit

protocol EpisodeInfoVCDelegate: AnyObject {
    func didTapSeeCharactersButton(for episode: Episode)
}

class RMEpisodeInfoVC: UIViewController {
    
    let stackView = UIStackView()
    let descriptorViewOne = RMDescriptorView()
    let descriptorViewTwo = RMDescriptorView()
    let actionButton = RMButton()
    
    var episode: Episode!
    
    
    init(episode: Episode) {
        super.init(nibName: nil, bundle: nil)
        self.episode = episode
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        layoutUIItems()
        configureStackView()
        configureEpisodeButton()
    }
    
    
    private func configureView() {
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 16
    }
    
    
    private func layoutUIItems() {
        view.addSubviews(stackView, actionButton)
        
        let padding: CGFloat = 15
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 90),
            
            actionButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 46)
        ])
    }
    
    
//    private func layoutUIItems() {
//        view.addSubviews(stackView, actionButton)
//
//        let padding: CGFloat = 15
//
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
//            stackView.heightAnchor.constraint(equalToConstant: 50),
//
//            actionButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: padding),
//            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
//            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
//            actionButton.heightAnchor.constraint(equalToConstant: 46)
//        ])
//    }
    
    
    private func configureStackView() {
        stackView.addArrangedSubviews(descriptorViewOne, descriptorViewTwo)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
    }
    
    
    private func configureEpisodeButton() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @objc func actionButtonTapped() {}

}
