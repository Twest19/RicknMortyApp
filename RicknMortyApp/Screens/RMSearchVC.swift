//
//  CharacterVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

class RMSearchVC: UIViewController {
    
    private enum CharacterListSection: Int {
        case main
    }
    
    private var collectionView: RMCharCollectionView!
    private var characterListDataSource: UICollectionViewDiffableDataSource<CharacterListSection, RMCharacter.ID>!
//    private var characterListDataSource: UICollectionViewDiffableDataSource<CharacterListSection, RMCharacter>!
    
    private let navBar = UINavigationBar()
    private let searchBar = UISearchBar()
    private let searchSpinner = UIActivityIndicatorView()
    
    let networker = NetworkManager.shared
    
    var character: [RMCharacter] = []
    
    var totalPages = 0
    var currentPage = 1
    
    var moreCharacters = true
    var isSearching = false
    var isLoadingMoreCharacters = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavBar()
        title = "All Characters"
        configureSearchBar()
        configureSearchSpinner()
        getCharacterData(pageNum: currentPage)
        configureDataSource()
    }
    
    
    func character(with id: Int) -> RMCharacter? {
        return character.first(where: { $0.id == id })
    }
    
    
    func characterIds() -> [RMCharacter.ID] {
        return character.map { $0.id }
    }
    
    
    private func getCharacterData(pageNum: Int, searchBarText: String = "") {
        isLoadingMoreCharacters = true

        networker.fetchCharacter(pageNum: pageNum, searchBarText: searchBarText) { [weak self] character, error in
            
            guard let self = self else { return }
            
            if let error = error {
                print("Error: ", error)
                return
            }
            
            if let character = character {
                self.totalPages = character.info.pages
                self.updateUI(with: character.results)
            }
            
            
            DispatchQueue.main.async {
                if self.searchSpinner.isAnimating == true {
                    self.searchSpinner.stopAnimating()
                }
            }
            self.isLoadingMoreCharacters = false
        }
    }
    
    
    private func getEpisodeCharacterData(with characterIDs: String) {
        networker.getEpisodeCharacters(with: characterIDs) { [weak self] character, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error: ", error)
                return
            }
            
            if let character = character {
                self.updateUI(with: character)
            }
            
            DispatchQueue.main.async {
                if self.searchSpinner.isAnimating == true {
                    self.searchSpinner.stopAnimating()
                }
            }
        }
    }
    
    
    private func configureCollectionView() {
        collectionView = RMCharCollectionView(frame: view.bounds, collectionViewLayout: Helper.threeColumnCollectionView(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
//        collectionView.register(RMCharacterCell.self, forCellWithReuseIdentifier: RMCharacterCell.identifier)
    }
    
    
    private func configureDataSource() {
        let characterCellRegistration = UICollectionView.CellRegistration<RMCharacterCell, RMCharacter> { cell, indexPath, character in
            cell.cellRepresentedIdentifier = character.id
            cell.set(character: character, representedIdentifier: character.id)
        }
        
        characterListDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            let character = self.character(with: itemIdentifier)!
//            print("DATASOURCE CHARACTER= \(character)")
            return collectionView.dequeueConfiguredReusableCell(using: characterCellRegistration, for: indexPath, item: character)
        })
//        characterListDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, char) -> UICollectionViewCell? in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCell.identifier, for: indexPath) as! RMCharacterCell
//            cell.set(character: char, representedIdentifier: char.id)
//            return cell
//        })
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
//            self.characterListDataSource.applySnapshotUsingReloadData(snapshot)
            self.characterListDataSource.apply(snapshot, animatingDifferences: true)
        }
//        var snapshot = NSDiffableDataSourceSnapshot<CharacterListSection, RMCharacter>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(characters)
//        DispatchQueue.main.async {
//            self.characterListDataSource.apply(snapshot, animatingDifferences: true)
//        }
        
    }
    
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        showSearchBarButton(shouldShow: true)
    }

    
    @objc func showSearchbar() {
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
}


extension RMSearchVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage < totalPages && indexPath.item == character.count - 1 {
            print("ROW: \(indexPath.row)")
            print("ITEM: \(indexPath.item)")
            guard moreCharacters, !isLoadingMoreCharacters else { return }
            currentPage += 1
            if let searchBarText = searchBar.text {
                print("Search bar text: \(searchBarText)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.getCharacterData(pageNum: self.currentPage, searchBarText: searchBarText)
                    print("FETCHING AGAIN...")
                }
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
        // reset screen
        print("AYAYAYYAYA")
        
        let id = Helper.getEpisodeNumber(from: episode.characters)
        
        currentPage = 1
        totalPages = 1
        
        character.removeAll()

        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        
        getEpisodeCharacterData(with: id)
        // Configuring this again seems to prevent occasional crash
        configureDataSource()
    }
}


// MARK: SearchBar Stuff
extension RMSearchVC: UISearchBarDelegate {
    
    private func configureSearchSpinner() {
        view.addSubview(searchSpinner)
        searchSpinner.hidesWhenStopped = true
        searchSpinner.style = .large
        searchSpinner.center = collectionView.center
    }
    
    
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
        
        searchSpinner.startAnimating()
        searchBar.resignFirstResponder()
        
        character.removeAll()
        totalPages = 0
        currentPage = 1
        
        if let searchedItem = searchBar.text {
            getCharacterData(pageNum: currentPage, searchBarText: searchedItem)
        }
        search(shouldShow: false)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print("Did begin editing")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print("Did end editing")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("Search text is \(searchText)")
    }
}
