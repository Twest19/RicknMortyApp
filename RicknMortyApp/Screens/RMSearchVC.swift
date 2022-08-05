//
//  CharacterVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

class RMSearchVC: UIViewController {
    
    private var collectionView: RMCharCollectionView!
    private let navBar = UINavigationBar()
    private let searchBar = UISearchBar()
    private let searchSpinner = UIActivityIndicatorView()
    
    let networker = NetworkManager.shared
    
    var character: [RMCharacter] = []
    var episode: Episode!
    
    var totalPages = 0
    var currentPage = 1
    
    var moreCharacters = true
    var isSearching = false
    var isLoadingMoreCharacters = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavBar()
        configureSearchBar()
        configureSearchSpinner()
        title = "All Characters"
        getCharacterData(pageNum: currentPage)
    }
    
    
    private func getCharacterData(pageNum: Int, searchBarText: String = "") {
        isLoadingMoreCharacters = true
        switch searchBarText {
        case "", " ":
            title = "All Characters"
        default:
            title = searchBarText
        }
        networker.fetchCharacter(pageNum: pageNum, searchBarText: searchBarText) { [weak self] character, error in
            
            guard let self = self else { return }
            
            if let error = error {
                print("Error: ", error)
                return
            }
            
            if let character = character {
                self.character.append(contentsOf: character.results)
                self.totalPages = character.info.pages
            }
            
            
            DispatchQueue.main.async {
                if self.searchSpinner.isAnimating == true {
                    self.searchSpinner.stopAnimating()
                }
                self.collectionView.reloadData()
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
                self.character.append(contentsOf: character)
            }
            DispatchQueue.main.async {
                if self.searchSpinner.isAnimating == true {
                    self.searchSpinner.stopAnimating()
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    
    private func configureCollectionView() {
        collectionView = RMCharCollectionView(frame: view.bounds, collectionViewLayout: Helper.threeColumnCollectionView(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
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


extension RMSearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return character.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Cell that displays pictures, name, status
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCell.identifier, for: indexPath) as? RMCharacterCell else { return UICollectionViewCell()}
        
        // ID used to prevent wrong picture in wrong cell
        let character = character[indexPath.item]
        cell.cellRepresentedIdentifier = character.id
        cell.set(character: character, representedIdentifier: character.id)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPage < totalPages && indexPath.row == character.count - 1 {
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


extension RMSearchVC: RMCharacterDetailVCDelegate {
    func didRequestEpisodeCharacters(for episode: Episode) {
        // reset screen
        print("AYAYAYYAYA")
        self.episode = episode
        title = episode.name
        currentPage = 1
        totalPages = 1
        
        character.removeAll()

        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        
        getEpisodeCharacterData(with: Helper.getEpisodeNumber(from: episode.characters))
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
        currentPage = 1
        
        if let searchedItem = searchBar.text {
            getCharacterData(pageNum: self.currentPage, searchBarText: searchedItem)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
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
