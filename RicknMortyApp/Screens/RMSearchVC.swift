//
//  CharacterVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

class RMSearchVC: RMDataLoadingVC {
    
    private enum CharacterListSection: Int {
        case main
    }
    
    private var collectionView: RMCharCollectionView!
    private var characterListDataSource: UICollectionViewDiffableDataSource<CharacterListSection, RMCharacter.ID>!
    
    private let navBar = UINavigationBar()
    private let searchBar = UISearchBar()
    
    
    private let networker = NetworkManager.shared
    
    private var character: [RMCharacter] = []
    
    private var totalPages = 0
    private var currentPage = 1
    
    private var searchedText: String = ""
    private var moreCharacters = true
    private var isSearching = false
    private var isLoadingMoreCharacters = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavBar()
        configureSearchBar()
        getCharacterData(pageNum: currentPage)
        configureDataSource()
        search(shouldShow: true)
    }
    
    
    func character(with id: Int) -> RMCharacter? {
        return character.first(where: { $0.id == id })
    }
    
    
    func characterIds() -> [RMCharacter.ID] {
        return character.map { $0.id }
    }
    
    
    private func getCharacterData(pageNum: Int, searchBarText: String = "") {
        showLoadingView()
        isLoadingMoreCharacters = true
        dismissErrorView()

        networker.getCharacters(pageNum: pageNum, searchBarText: searchBarText) { [weak self] result in
            
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
    
    
    private func getEpisodeCharacterData(with characterIDs: String) {
        showLoadingView()
        networker.getEpisodeCharacters(with: characterIDs) { [weak self] result in
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
    
    
    private func configureCollectionView() {
        collectionView = RMCharCollectionView(frame: view.frame, collectionViewLayout: Helper.threeColumnCollectionView(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    
    private func configureDataSource() {
        let characterCellRegistration = UICollectionView.CellRegistration<RMCharacterCell, RMCharacter> { cell, indexPath, character in
            cell.cellRepresentedIdentifier = character.id
            cell.set(character: character, representedIdentifier: character.id)
        }
        
        characterListDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            let character = self.character(with: itemIdentifier)!
            return collectionView.dequeueConfiguredReusableCell(using: characterCellRegistration, for: indexPath, item: character)
        })
    }
    
    
    private func updateUI(with characters: [RMCharacter]) {
        self.character.append(contentsOf: characters)
        self.updateData(on: self.character)
    }
    
    
    private func updateData(on characters: [RMCharacter]) {
        let charID = characterIds()

        var snapshot = NSDiffableDataSourceSnapshot<CharacterListSection, RMCharacter.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(charID, toSection: .main)
        DispatchQueue.main.async {
            self.characterListDataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemGreen
        showSearchBarButton(shouldShow: true)
    }
}


extension RMSearchVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage < totalPages && indexPath.item == character.count - 1 {
            guard moreCharacters, !isLoadingMoreCharacters else { return }
            currentPage += 1
            DispatchQueue.main.async {
                self.getCharacterData(pageNum: self.currentPage, searchBarText: self.searchedText)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isSearching {
            let selectedCharacter = character[indexPath.item]
           
            let detailVC = RMCharacterDetailVC(for: selectedCharacter)
            detailVC.delegate = self
            
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
        // the current title does not equal the new title that will be set
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
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            setTitle(with: episode.nameAndEpisode)
            // Get all the characters from the episode
            getEpisodeCharacterData(with: id)
            // Configuring this again prevents occasional crash within datasource.
            configureDataSource()
        }
    }
}


// MARK: SearchBar Stuff
extension RMSearchVC: UISearchBarDelegate {
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.placeholder = "Search Characters Here..."
        searchBar.tintColor = .label
        searchBar.searchBarStyle = .minimal
    }
    
    
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
                configureDataSource()
            }
        }
    }
    
    
    @objc func showSearchbar() {
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
}
