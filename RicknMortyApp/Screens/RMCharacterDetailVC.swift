//
//  CharDetailVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/25/22.
//

import UIKit

protocol RMCharacterDetailVCDelegate: AnyObject {
    func didRequestEpisodeCharacters(for episode: String)
}

class RMCharacterDetailVC: UIViewController {
    
    let headerView = UIView()
    let episodeOneView = UIView()
    let episodeTwoView = UIView()
    let stackView = UIStackView()
    
    var views: [RMDescriptorView] = []
    
    var character: RMCharacter!
    
    weak var delegate: RMCharacterDetailVCDelegate!
    private let padding: CGFloat = 10
    
    
    init(for character: RMCharacter){
        super.init(nibName: nil, bundle: nil)
        self.character = character
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubviews(headerView, stackView)
        configNavBar()
        configureHeaderView()
        configureStackView()
        getEpisodeInfo(episodes: Helper.getEpisodeNumber(from: character.episode.first!, character.episode.last!))
    }
    
    
    func getEpisodeInfo(episodes: String) {
        NetworkManager.shared.getEpisodeData(episodes: episodes) { [weak self] episode, error in
            guard let self = self else { return }

            if let error = error {
                print("Error: ", error)
                return
            }
            
            if let episode = episode {
                DispatchQueue.main.async {
                    self.setUIElements(with: episode)
    //                self.firstEpisodeLabel.setUp(description: DescriptorType.firstEpisode, info: episode?.first?.name ?? "N/A")
    //                self.lastEpisodeLabel.setUp(description: DescriptorType.lastEpisode, info: episode?.last?.name ?? "N/A")
                }
            }
        }
    }
    
    
    func setUIElements(with episode: [Episode]) {
        DispatchQueue.main.async {
            self.add(childVC: RMDetailHeaderVC(character: self.character), to: self.headerView)
            self.add(childVC: FirstEpisodeVC(episode: episode.first!, delegate: self), to: self.episodeOneView)
        }
    }
    
    
    private func configureHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemPink
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 170)
        ])
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
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
        ])
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    func configNavBar() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSelf))
        backButton.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = backButton
    }
    
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
}

extension RMCharacterDetailVC: FirstEpisodeVCDelegate {
    
    func didTapSeeCharactersButton(for episode: Episode) {
        guard episode.characters.count != 0 else {
            return
        }
        
        delegate.didRequestEpisodeCharacters(for: episode.characters)
        dismissSelf()
    }
}

