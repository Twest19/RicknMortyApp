//
//  CharDetailVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/25/22.
//

import UIKit

protocol RMCharacterDetailVCDelegate: AnyObject {
    func didRequestEpisodeCharacters(for episode: Episode)
}

class RMCharacterDetailVC: RMDataLoadingVC {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let episodeOneView = UIView()
    let episodeTwoView = UIView()
    
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
        view.addSubviews(scrollView)
        configNavBar()
        configureScrollView()
        configureHeaderView()
        configureEpisodeOneView()
        configureEpisodeTwoView()
        
        getEpisodeInfo(episodes: Helper.getID(from: [character.episode.first!, character.episode.last!]))
    }
    
    
    func getEpisodeInfo(episodes: String) {
        showLoadingView()
        NetworkManager.shared.getEpisodeData(episodes: episodes) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let episode):
                self.setUIElements(with: episode)
                
            case .failure(let error):
                print("Error: ", error)
                return
            }
        }
    }
    
    
    func setUIElements(with episode: [Episode]) {
        DispatchQueue.main.async {
            self.add(childVC: RMDetailHeaderVC(character: self.character), to: self.headerView)
            self.add(childVC: FirstEpisodeVC(episode: episode.first!, delegate: self), to: self.episodeOneView)
            self.add(childVC: SecondEpisodeVC(episode: episode.last!, delegate: self), to: self.episodeTwoView)
        }
    }
    
    
    private func configureScrollView() {
        scrollView.addSubviews(contentView)
        scrollView.pinToEdges(of: view)
        
        contentView.addSubviews(headerView, episodeOneView, episodeTwoView)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 700)
        ])
    }
    
    
    private func configureHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    
    private func configureEpisodeOneView() {
        episodeOneView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            episodeOneView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            episodeOneView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            episodeOneView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            episodeOneView.heightAnchor.constraint(equalToConstant: 190)
        ])
    }
    
    
    private func configureEpisodeTwoView() {
        episodeTwoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            episodeTwoView.topAnchor.constraint(equalTo: episodeOneView.bottomAnchor, constant: 20),
            episodeTwoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            episodeTwoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            episodeTwoView.heightAnchor.constraint(equalToConstant: 190)
        ])
    }
    
    
    func configNavBar() {
        let backButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissSelf))
        backButton.tintColor = .systemGreen
        navigationItem.rightBarButtonItem = backButton
    }
    
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
}

extension RMCharacterDetailVC: EpisodeVCDelegate {
    
    func didTapSeeCharactersButton(for episode: Episode) {
        guard episode.characters.count != 0 else {
            return
        }
        print("\nDETAILVC FIRSTEPISODEDELEGATE")
        
        if let delegate = delegate {
            delegate.didRequestEpisodeCharacters(for: episode)
            dismissSelf()
            print("DETAILVC FIRSTEPISODEDELEGATE\n")
        }
    }
}
