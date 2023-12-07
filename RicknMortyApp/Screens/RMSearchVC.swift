//
//  CharacterVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.

//  Updated 1/16/23.

import UIKit

// MARK: This is the VC for the "Character" screen within the app.
// Inherits from the RMDataLoadingVC which provides the proper loading icon, spinners, and errors.

// MARK: Network Request
// This VC makes network request and uses pagination to fill in a three column CollectionView
// with character pictures, name, and their status like "Alive" or "Dead."

// MARK: Functionality
// Each CollectionView Cell can be tapped and a modally presented DetailVC will display more Character info.
// Searches can also be made. See Searching MARK below...
// This VC also is used to display characters for selected episodes. See EpisodeVC for more info.

// MARK: Errors
// Errors will be handled with an error screen that has an image of the fan favorite character "Mr. Poopybutthole"

// MARK: Searching
// A search for a specific character or a name of a character can be made. If the Character does not exist,
// then an error screen will appear giving further instructions.
// You can only search for characters as of right now.


class RMSearchVC: RMDataLoadingVC {
    
    private enum CharacterListSection: Int {
        case main
    }
    
    var collectionView: RMCharCollectionView!
    private var characterListDataSource: UICollectionViewDiffableDataSource<CharacterListSection, RMCharacter.ID>!
    var collectionViewDelegate: RMSearchCollectionViewDelegate!
    private var rmSearchBarDelegate: RMSearchBarDelegate!
    
    let searchBar = RMSearchBar()
    
    let dataStore = RMDataStore.shared
    let loadDelay: TimeInterval = 1
    
    var totalPages = 1
    var currentPage = 1
    
    var searchedText: String = ""
    var isSearching = false
    var isLoadingMoreCharacters = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEpisodeDelegate()
        configureCollectionView()
        configureNavBar()
        configureSearchBar()
        fetchCharacterData(pageNum: currentPage)
        configureDataSource()
        rmSearchBarDelegate.search(shouldShow: true)
    }
    
    
    func setupEpisodeDelegate() {
        if let episodeNavVC = self.tabBarController?.viewControllers?.last(where: { $0 is UINavigationController}) as? UINavigationController {
            if let episodeVC = episodeNavVC.viewControllers.first(where: { $0 is RMEpisodeVC}) as? RMEpisodeVC {
                episodeVC.delegate = self
            }
        }
    }
    
    // MARK: CollectionView Config
    private func configureCollectionView() {
        collectionView = RMCharCollectionView(in: view)
        view.addSubview(collectionView)
        collectionViewDelegate = RMSearchCollectionViewDelegate(parentVC: self)
        collectionView.delegate = collectionViewDelegate
    }
    
    // MARK: CollectionView DataSource
    func configureDataSource() {
        let characterCellRegistration = UICollectionView.CellRegistration<RMCharacterCell, RMCharacter> { cell, indexPath, character in
            cell.cellRepresentedIdentifier = character.id
            cell.set(character: character, representedIdentifier: character.id)
        }
        
        characterListDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                                     cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            let character = self.dataStore.character(with: itemIdentifier)
            return collectionView.dequeueConfiguredReusableCell(using: characterCellRegistration, for: indexPath, item: character)
        })
    }
    
    // MARK: Update Screen
    func updateUI(with characters: [RMCharacter]) {
        dataStore.saveCharacters(characters)
        self.updateData(on: self.dataStore.getCharacters())
    }
    
    // MARK: Update DataSource
    private func updateData(on characters: [RMCharacter]) {
        let charID = dataStore.getCharacterIds()
        var snapshot = NSDiffableDataSourceSnapshot<CharacterListSection, RMCharacter.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(charID, toSection: .main)
        DispatchQueue.main.async {
            self.characterListDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    // MARK: Config Nav Bar
    private func configureNavBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    private func configureSearchBar() {
        rmSearchBarDelegate = RMSearchBarDelegate(parentVC: self)
        searchBar.delegate = rmSearchBarDelegate
        rmSearchBarDelegate.showSearchBarButton(shouldShow: true)
    }
    
    func resetScreen() {
        dataStore.clearCharacters()
        totalPages = 1
        currentPage = 1
        searchBar.text = nil
    }
}


// MARK: RMCHARACTERDETAILVCDELEGATE
extension RMSearchVC: RMCharacterDetailVCDelegate {
    func didRequestEpisodeCharacters(for episode: Episode) {
        // Since the title is set at each network call we check that
        // the current title does not equal the new title that will be set.
        // This prevents unnecessary calls.
        if self.navigationItem.title != episode.nameAndEpisode {
//            print("Making Network Call")
            let id = Helper.getID(from: episode.characters)
            resetScreen()
            rmSearchBarDelegate.search(shouldShow: false)
            // Scroll to top of collectionView
            setTitle(with: episode.nameAndEpisode)
            // Get all the characters from the episode
            fetchEpisodeCharacterData(with: id)
            // Configuring this again prevents occasional crash within datasource.
            configureDataSource()
        }
        
        collectionViewDelegate.scrollToTop(animated: false)
    }
}


