//
//  CharacterVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

class CharacterVC: UIViewController {
    
    private var collectionView: UICollectionView!
    private let navBar = UINavigationBar()
    private let searchBar = UISearchBar()
    private let searchSpinner = UIActivityIndicatorView()
    
    let networker = NetworkManager.shared
    
    var charResults: RMResults?
    var character: [RMCharacter] = []
    
    private var totalPages = 1
    private var currentPages = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureNavBar()
        configureSearchBar()
        configureSearchSpinner()
        title = "Characters"
        getCharacterData(pageNum: 1)
        
    }
    
    
    private func getCharacterData(pageNum: Int = 1, searchBarText: String = "") {
        networker.fetchCharacter(pageNum: pageNum, searchBarText: searchBarText) { [weak self] character, error in

            if let error = error {
                print("Error: ", error)
                return
            }

            if let charArray = character?.results {
                self?.character.append(contentsOf: charArray)
            }

            if let totalPages = character?.info?.pages {
                self?.totalPages = totalPages
            }

            self?.charResults = character

            DispatchQueue.main.async {
                if self?.searchSpinner.isAnimating == true {
                    self?.searchSpinner.stopAnimating()
                }
                
                self?.collectionView.reloadData()
            }

        }
    }
    
    
    private func configureCollectionView() {
        let width = (view.frame.size.width/3)-8
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width+30)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.frame = view.bounds
        collectionView.backgroundView?.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Register Cells
        collectionView.register(RMCharacterCell.self, forCellWithReuseIdentifier: RMCharacterCell.identifier)
        view.addSubview(collectionView)
        collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.identifier)
    }
    
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navBar.tintColor = .black
        showSearchBarButton(shouldShow: true)
    }

    
    @objc func showSearchbar() {
        search(shouldShow: true)
        searchBar.becomeFirstResponder()
    }
    
    private func image(data: Data?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)
        }
        return UIImage(systemName: "defaultRMImage")
    }
    
}

extension CharacterVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return character.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if currentPages < totalPages && indexPath.row == character.count - 1 {
            // for the loading cell w/activity spinner
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier, for: indexPath) as? LoadingCell else { return UICollectionViewCell() }
            
            DispatchQueue.main.async {
                cell.activityIndicator.startAnimating()
            }
            
            return cell
            
        } else {
            // Cell that displays pictures, name, status
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCell.identifier,
                                                                for: indexPath) as? RMCharacterCell else { return UICollectionViewCell()}
            
            
//            cell.rmImageView.image = UIImage(systemName: "defaultRMImage")
            
            // ID used to prevent wrong picture in wrong cell
            let model = String(describing: character[indexPath.row].id)
            let representedIdentifier = model
            cell.representedIdentifier = representedIdentifier
            
            // Set cell's image, also caches
            networker.image(name: character[indexPath.row]) { data, error in
                let img = self.image(data: data)
                DispatchQueue.main.async {
                    if (cell.representedIdentifier == representedIdentifier) {
                        cell.rmImageView.image = img
                    }
                    
                }
                
            }
            
            // Name Label:
            cell.rmNameLabel.text = self.character[indexPath.row].name
            
            // Status Label, IE: Dead, Alive, Unknown
            cell.rmStatusLabel.text = cell.setCharacterStatus(status: self.character[indexPath.row].status)
            
            return cell
        }
        

    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if currentPages < totalPages && indexPath.row == character.count - 1 {
            currentPages = currentPages + 1
            
            if let searchBarText = searchBar.text {
                print("Search bar text: \(searchBarText)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                    self.getCharacterData(pageNum: self.currentPages, searchBarText: searchBarText)
                }
            }
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = CharDetailVC()
        networker.image(name: character[indexPath.row]) { data, error in

            let img = self.image(data: data)
            DispatchQueue.main.async {
                detailVC.charImageView.image = img
                detailVC.charNameLabel.text = self.character[indexPath.row].name
                detailVC.charStatus.text = self.character[indexPath.row].status
            }

        }
        
        let navController = UINavigationController(rootViewController: detailVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: false)
        
    }

}


// MARK: SearchBar Stuff
extension CharacterVC: UISearchBarDelegate {
    
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
        searchBar.tintColor = .black
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
        
        self.searchSpinner.startAnimating()
        self.searchBar.resignFirstResponder()
        
        print(character)
        character = []
        print()
        currentPages = 1
        totalPages = 1
        collectionView.reloadData()
        
        if let searchedItem = searchBar.text {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                self.getCharacterData(searchBarText: searchedItem)
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
