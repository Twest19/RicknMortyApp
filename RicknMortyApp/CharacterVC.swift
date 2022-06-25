//
//  CharacterVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

class CharacterVC: UIViewController {
    
    private var collectionView: UICollectionView?
    private var charResults: RMResults?
    
    let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Characters"
        collectionView?.backgroundColor = .darkGray
        configureCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
    }
    
    func configureCollectionView() {
        let width = (view.frame.size.width/3)-8
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: width+25)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.frame = view.bounds
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        // Register Cells
        collectionView.register(RMCharacterCell.self, forCellWithReuseIdentifier: RMCharacterCell.identifier)
        
    }
    
    
    func fetch() {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let data = data, error == nil else { return }
            
            guard let _ = response else {
                return
            }
            
            // convert to JSON
            do {
                let characters = try JSONDecoder().decode(RMResults.self, from: data)
                
                DispatchQueue.main.async {
                    self?.charResults = characters
                    self?.collectionView?.reloadData()
                }
                
            } catch {
                print(error)
            }
            
            
        }
        task.resume()
    }

}

extension CharacterVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return charResults?.results?.count ?? 1
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCell.identifier,
                                                            for: indexPath) as? RMCharacterCell else { return UICollectionViewCell()}
        print()
        let results = charResults?.results?[indexPath.item]
        print(results as Any)
        
        if let url = URL(string: results?.image ?? "90-90") {
            cell.rmImageView.load(url: url)
        
        } else {
            cell.rmImageView.image = UIImage(named: "90-90")
        }
        
        cell.rmNameLabel.text = results?.name ?? ""
        
        
        return cell
    }
    
}
