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
        
    var collectionView: RMCharCollectionView!
    var collectionViewDatasource: RMSearchVCDiffCVDatasource!
    var collectionViewDelegate: RMSearchCollectionViewDelegate!
    var rmSearchBarDelegate: RMSearchBarDelegate!
    let searchBar = RMSearchBar()
    
    let dataStore = RMDataStore.shared
    var isLoadingMoreCharacters = false
    var totalPages = 1
    var currentPage = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEpisodeDelegate()
        configureCollectionView()
        configureNavBar()
        configureSearchBar()
        fetchCharacterData(pageNum: currentPage)
        configureCVDatasource()
        rmSearchBarDelegate.search(shouldShow: true)
    }
        
    // MARK: CollectionView Config
    private func configureCollectionView() {
        collectionView = RMCharCollectionView(in: view)
        view.addSubview(collectionView)
        
        collectionViewDelegate = RMSearchCollectionViewDelegate(parentVC: self)
        collectionView.delegate = collectionViewDelegate
    }
    
    // MARK: Datasource config
    func configureCVDatasource() {
        collectionViewDatasource = RMSearchVCDiffCVDatasource(parentVC: self)
        collectionViewDatasource.configureDataSource()
    }
    
    // MARK: Config Nav Bar
    private func configureNavBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    // MARK: Config Search Bar
    private func configureSearchBar() {
        rmSearchBarDelegate = RMSearchBarDelegate(parentVC: self)
        searchBar.delegate = rmSearchBarDelegate
        rmSearchBarDelegate.showSearchBarButton(shouldShow: true)
    }
    
    // Resets screen to default values
    func resetScreen() {
        dataStore.clearCharacters()
        totalPages = 1
        currentPage = 1
        searchBar.text = nil
    }
    
    // MARK: For changing tabs in app when finding chars by episode
    func setupEpisodeDelegate() {
        if let episodeNavVC = self.tabBarController?.viewControllers?.last(where: { $0 is UINavigationController}) as? UINavigationController {
            if let episodeVC = episodeNavVC.viewControllers.first(where: { $0 is RMEpisodeVC}) as? RMEpisodeVC {
                episodeVC.delegate = self
            }
        }
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
            collectionViewDatasource.configureDataSource()
        }
        collectionViewDelegate.scrollToTop(animated: false)
    }
}
