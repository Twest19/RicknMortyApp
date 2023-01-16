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
// YOU CAN ONLY SEARCH FOR CHARACTERS, NOT EPISODES OR LOCATIONS FROM THE SHOW!!!


class RMSearchVC: RMDataLoadingVC {
    
    private enum CharacterListSection: Int {
        case main
    }
    
    private var collectionView: RMCharCollectionView!
    private var characterListDataSource: UICollectionViewDiffableDataSource<CharacterListSection, RMCharacter.ID>!
    
    private let searchBar = RMSearchBar()
        
    private var character: [RMCharacter] = []
    
    private var totalPages = 0
    private var currentPage = 1
    
    private var searchedText: String = ""
    private var isSearching = false
    private var isLoadingMoreCharacters = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEpisodeDelegate()
        configureCollectionView()
        configureNavBar()
        configureSearchBar()
        getCharacterData(pageNum: currentPage)
        configureDataSource()
        search(shouldShow: true)
    }
    
    
    func setUpEpisodeDelegate() {
        if let episodeNavVC = self.tabBarController?.viewControllers?.last(where: { $0 is UINavigationController}) as? UINavigationController {
            if let episodeVC = episodeNavVC.viewControllers.first(where: { $0 is RMEpisodeVC}) as? RMEpisodeVC {
                episodeVC.delegate = self
            }
        }
    }
    
    
    func character(with id: Int) -> RMCharacter? {
        return character.first(where: { $0.id == id })
    }
    
    
    func characterIds() -> [RMCharacter.ID] {
        return character.map { $0.id }
    }
    
    
    // MARK: Standard Character or Search Character Request
    private func getCharacterData(pageNum: Int, searchBarText: String = "") {
        showLoadingView()
        isLoadingMoreCharacters = true
        dismissErrorView()

        NetworkManager.shared.getCharacters(pageNum: pageNum, searchBarText: searchBarText) { [weak self] result in
            
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let character):
                self.setTitle(with: searchBarText)
                self.totalPages = character.info.pages
                self.updateUI(with: character.results)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorView(with: error, in: self.view)
                    return
                }
            }
            self.isLoadingMoreCharacters = false
        }
    }
    
    
    // MARK: Character from Episode Request
    // No pagination required with this request hence why the above request is not reused
    private func getEpisodeCharacterData(with characterIDs: String) {
        showLoadingView()
        NetworkManager.shared.getCharacters(using: characterIDs) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let character):
                self.updateUI(with: character)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showErrorView(with: error, in: self.view)
                }
                return
            }
        }
    }
    
    // MARK: CollectionView Config
    private func configureCollectionView() {
        collectionView = RMCharCollectionView(frame: view.frame, collectionViewLayout: Helper.threeColumnCollectionView(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    // MARK: CollectionView DataSource
    private func configureDataSource() {
        let characterCellRegistration = UICollectionView.CellRegistration<RMCharacterCell, RMCharacter> { cell, indexPath, character in
            cell.cellRepresentedIdentifier = character.id
            cell.set(character: character, representedIdentifier: character.id)
        }
        
        characterListDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView,
                                                                     cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            let character = self.character(with: itemIdentifier)!
            return collectionView.dequeueConfiguredReusableCell(using: characterCellRegistration, for: indexPath, item: character)
        })
    }
    
    // MARK: Update Screen
    private func updateUI(with characters: [RMCharacter]) {
        self.character.append(contentsOf: characters)
        self.updateData(on: self.character)
    }
    
    // MARK: Update DataSource
    private func updateData(on characters: [RMCharacter]) {
        let charID = characterIds()

        var snapshot = NSDiffableDataSourceSnapshot<CharacterListSection, RMCharacter.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(charID, toSection: .main)
        DispatchQueue.main.async {
            self.characterListDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    // MARK: Config Nav Bar
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemGreen
    }
}


extension RMSearchVC: UICollectionViewDelegate {
    
    func scrollToTop(animated: Bool) {
        let point = CGPoint(x: -collectionView.adjustedContentInset.left, y: -collectionView.adjustedContentInset.top)
        collectionView.setContentOffset(point, animated: animated)
    }
    
    // MARK: Pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage < totalPages && indexPath.item == character.count - 1 {
            guard !isLoadingMoreCharacters else { return }
            currentPage += 1
            DispatchQueue.main.async {
                self.getCharacterData(pageNum: self.currentPage, searchBarText: self.searchedText)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isSearching { // Checks to make sure a network request is not in progress
            let selectedCharacter = character[indexPath.item]
            let detailVC = RMCharacterDetailVC(for: selectedCharacter, delegate: self)
            let navController = UINavigationController(rootViewController: detailVC)
            navController.modalPresentationStyle = .popover
            present(navController, animated: true)
        }
    }
}


// MARK: RMCHARACTERDETAILVCDELEGATE
extension RMSearchVC: RMCharacterDetailVCDelegate {
    func didRequestEpisodeCharacters(for episode: Episode) {
        // Since the title is set at each network call we check that
        // the current title does not equal the new title that will be set.
        // This prevents unnecessary calls.
        if self.title != episode.nameAndEpisode {
            print("Making Network Call")
            let id = Helper.getID(from: episode.characters)
            // reset screen
            currentPage = 1
            totalPages = 1
            character.removeAll()
            searchBar.text = nil
            search(shouldShow: false)
            // Scroll to top of collectionView
            setTitle(with: episode.nameAndEpisode)
            // Get all the characters from the episode
            getEpisodeCharacterData(with: id)
            // Configuring this again prevents occasional crash within datasource.
            configureDataSource()
        }
        scrollToTop(animated: false)
    }
}


// MARK: SearchBar Stuff
extension RMSearchVC: UISearchBarDelegate {
    
    private func configureSearchBar() {
        searchBar.delegate = self
        showSearchBarButton(shouldShow: true)
    }
    
    // Determines if the search bar should be showing
    private func showSearchBarButton(shouldShow: Bool) {
        switch shouldShow {
        case true:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchbar))
        case false:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    
    private func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
    }
    
    // Cancel is clicked the search bar should not be showing
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
        searchBar.resignFirstResponder()
        if let searchedItem = searchBar.text {
            // Since the title is set at each network call we check that the searchBar text does not equal the current title.
            // This prevents unnecessary calls
            if searchBar.text != self.title {
                // Reset Screen
                character.removeAll()
                totalPages = 0
                currentPage = 1
                searchBar.text = nil
                
                searchedText = searchedItem
                getCharacterData(pageNum: currentPage, searchBarText: searchedItem)
                scrollToTop(animated: false)
                configureDataSource()
            }
        }
    }
    
    
    @objc func showSearchbar() {
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
}
