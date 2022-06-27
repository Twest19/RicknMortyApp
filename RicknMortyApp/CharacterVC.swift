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
    
    var totalPages = 1
    var currentPages = 1
    var character: [RMCharacter] = [RMCharacter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        title = "Characters"
        fetch(page: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func fetch(page: Int, refresh: Bool = false) {
            
            guard let url = URL(string: "https://rickandmortyapi.com/api/character/?page=\(page)") else { return }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                
                if refresh {
                    self?.character.removeAll()
                    
                }
                
                
                guard let data = data, error == nil else { return }
                
                guard let _ = response else { return }
                
                // convert to JSON
                do {
                    let characters = try JSONDecoder().decode(RMResults.self, from: data)
                    
                    self?.totalPages = characters.info?.pages ?? 1
                    self?.character.append(contentsOf: characters.results!)
                    self?.charResults = characters
                    
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                    
                } catch {
                    print(error)
                }
                
                
            }
            task.resume()
            
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
            cell.activityIndicator.startAnimating()
            
            return cell
            
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCell.identifier,
                                                                for: indexPath) as? RMCharacterCell else { return UICollectionViewCell()}
            
            let model = String(describing: character[indexPath.row].id)
            let representedIdentifier = model
            cell.representedIdentifier = representedIdentifier
            
            cell.configure(with: character[indexPath.row])
            
            
            
            if let url = URL(string: character[indexPath.row].image ?? "90-90") {
                
                DispatchQueue.main.async {
                    if (cell.representedIdentifier == representedIdentifier) {
                        cell.rmImageView.load(url: url)
                    }
                }
            
            } else {
                cell.rmImageView.image = UIImage(named: "90-90")
            }
            
            if let status = character[indexPath.row].status {
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.fetch(page: self.currentPages)
            }
        }

    }
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetching...")
        
        for indexPath in indexPaths {
            let viewModel = character[indexPath.row]
            viewModel.down
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("...Cancel prefetch")
    }
}
