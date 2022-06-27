//
//  CharacterVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

class CharacterVC: UIViewController {
    
    private var collectionView: UICollectionView!
    var charResults: RMResults?
    
    let networker = NetworkManager.shared
    
    var totalPages = 1
    var currentPages = 1
    var character: [RMCharacter] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        title = "Characters"
        
        networker.fetchCharacter(pageNum: 1) { [weak self] character, error in
            
            if let error = error {
                print("Error: ", error)
                return
            }
            
            if let charArray = character?.results {
                print(charArray)
                self?.character.append(contentsOf: charArray)
            }
            
            if let totalPages = character?.info?.pages {
                self?.totalPages = totalPages
            }
            
            self?.charResults = character
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func configureCollectionView() {
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
        collectionView.prefetchDataSource = self
        // Register Cells
        collectionView.register(RMCharacterCell.self, forCellWithReuseIdentifier: RMCharacterCell.identifier)
        view.addSubview(collectionView)
        collectionView.register(LoadingCell.self, forCellWithReuseIdentifier: LoadingCell.identifier)
    }

}

extension CharacterVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return character.count
        
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if currentPages < totalPages && indexPath.row == character.count - 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier, for: indexPath) as? LoadingCell else { return UICollectionViewCell() }
            DispatchQueue.main.async {
                cell.activityIndicator.startAnimating()
            }
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCell.identifier,
                                                                for: indexPath) as? RMCharacterCell else { return UICollectionViewCell()}
            
            let model = String(describing: character[indexPath.row].id)
            let representedIdentifier = model
            cell.representedIdentifier = representedIdentifier
            
            cell.rmImageView.image = nil
            
            if let image = character[indexPath.row].image {
                
                // Calls the networkers download image method:
                networker.downloadCharImage(character: image) { data, error in
                    
                    if let data = data {
                        let charImage = UIImage(data: data)
                        DispatchQueue.main.async {
                            if (cell.representedIdentifier == representedIdentifier){
                                cell.rmImageView.image = charImage
                            }
                        }
                    } else {
                        if (cell.representedIdentifier == representedIdentifier){
                            DispatchQueue.main.async {
                                cell.rmImageView.image = UIImage(named: "defaultRMImage")
                            }
                        }
                        
                    }
                }
            }
            
            
                
                // Name Label:
                cell.rmNameLabel.text = self.character[indexPath.row].name
                
                // Status Label, IE: Dead, Alive, Unknown
                if let status = self.character[indexPath.row].status {
                    var statusSymbol: String
                    
                    switch status {
                    case "Alive":
                        statusSymbol = "🟢"
                    case "Dead":
                        statusSymbol = "🔴"
                    default:
                        statusSymbol = "⚪️"
                    }
                    cell.rmStatusLabel.text = "Status: \(status) \(statusSymbol)"
                } else {
                    cell.rmStatusLabel.text = "Status: N/A"
                }
            
            
            return cell
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if currentPages < totalPages && indexPath.row == character.count - 1 {
            currentPages = currentPages + 1
            DispatchQueue.main.async {

                self.networker.fetchCharacter(pageNum: self.currentPages) { [weak self] character, error in

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
                        self?.collectionView.reloadData()
                        
                    }

                }


            }
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetching...")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("...Cancel prefetch")
       
    }
    
}
