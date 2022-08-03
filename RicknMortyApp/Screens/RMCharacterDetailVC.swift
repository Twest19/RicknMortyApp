//
//  CharDetailVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/25/22.
//

import UIKit

class RMCharacterDetailVC: UIViewController {
    
    let headerView = UIView()
    let stackView = UIStackView()
    
    let firstEpisodeLabel = RMDescriptorView()
    let lastEpisodeLabel = RMDescriptorView()
    
    var views: [RMDescriptorView] = []
    
    var character: RMCharacter!
    
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
        setUIElements()
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
    
    
    func setUIElements() {
        DispatchQueue.main.async {
            self.add(childVC: RMDetailHeaderVC(character: self.character), to: self.headerView)
        }
        
        firstEpisodeLabel.setUp(description: DescriptorType.firstEpisode, info: character.episode.first ?? "N/A")
        lastEpisodeLabel.setUp(description: DescriptorType.lastEpisode, info: character.episode.last ?? "N/A")
        
        getEpisodeInfo(episodes: Helper.getEpisodeNumber(from: character.episode.first!, character.episode.last!))
    }
    
    
    private func configureHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemPink
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    
    func getEpisodeInfo(episodes: String) {
        NetworkManager.shared.getEpisodeData(episodes: episodes) { [weak self] episode, error in
            guard let self = self else { return }

            if let error = error {
                print("Error: ", error)
                return
            }
            
            print()
            print(episode)
            print()
        }
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
        dismiss(animated: true, completion: nil)
    }
}
