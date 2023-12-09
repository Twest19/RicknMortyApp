//
//  CharDetailVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/25/22.
//  UPDATED: 12/8/23

import UIKit

protocol RMCharacterDetailVCDelegate: AnyObject {
    func didRequestEpisodeCharacters(for episode: Episode)
}

class RMCharacterDetailVC: RMDataLoadingVC {
    
    let charDetailView = RMDetailView()
    var character: RMCharacter!
    
    weak var delegate: RMCharacterDetailVCDelegate!
    private let padding: CGFloat = 10
    
    
    init(for character: RMCharacter, delegate: RMCharacterDetailVCDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.character = character
        self.delegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = charDetailView
        view.backgroundColor = .systemBackground
        configNavBar()
        getEpisodeInfo(episodes: Helper.getID(from: [character.episode.first!, character.episode.last!]))
    }
    
    
    func setUIElements(with episode: [Episode]) {
        DispatchQueue.main.async {
            self.add(childVC: RMDetailHeaderVC(character: self.character), 
                     to: self.charDetailView.headerView)
            self.add(childVC: FirstEpisodeVC(episode: episode.first!, delegate: self),
                     to: self.charDetailView.episodeOneView)
            self.add(childVC: SecondEpisodeVC(episode: episode.last!, delegate: self),
                     to: self.charDetailView.episodeTwoView)
        }
    }
    
    
    func getEpisodeInfo(episodes: String) {
        self.showLoadingView()
        NetworkManager.shared.getEpisodeData(episodes: episodes) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let episode):
                self.setUIElements(with: episode)
            case .failure(let error):
                print("Error: ", error)
                DispatchQueue.main.async {
                    self.showErrorView(with: error, in: self.view)
                }
            }
        }
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

// MARK: EpisodeVCDelegate
extension RMCharacterDetailVC: EpisodeVCDelegate {

    func didTapSeeCharactersButton(for episode: Episode) {
        guard episode.characters.count != 0 else { return }

        if let delegate = delegate {
            delegate.didRequestEpisodeCharacters(for: episode)
            dismissSelf()
        }
    }
}
