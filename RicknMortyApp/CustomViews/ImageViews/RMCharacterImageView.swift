//
//  RMImageView.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/27/22.
//

import UIKit

class RMCharacterImageView: UIImageView {
    
    let placeHolderImage = Images.placeHolder
    var imageIncomingIndicator = UIActivityIndicatorView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureSpinner()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func configure() {
        layer.cornerRadius = 8
        clipsToBounds = true
        image = placeHolderImage
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageIncomingIndicator)
    }
    
    
    private func configureSpinner() {
        imageIncomingIndicator.hidesWhenStopped = true
        imageIncomingIndicator.pinToCenter(of: self)
    }
    
    
    func makeImage(data: Data?) -> UIImage? {
        if let data = data {
            return UIImage(data: data)
        }
        return placeHolderImage
    }
    
    
    func downloadImage(from url: String) {
        startIndicator()
        // Set cell's image, also caches
        NetworkManager.shared.downloadImageUsing(URLString: url) { [weak self] result in
            guard let self = self else { return }
            self.stopIndicator()
            
            switch result {
            case .success(let data):
                let img = self.makeImage(data: data)
                DispatchQueue.main.async {
                    self.image = img
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.image = self.placeHolderImage
                }
                return
            }
        }
    }
    
    
    func startIndicator() {
        DispatchQueue.main.async {
            self.imageIncomingIndicator.startAnimating()
        }
    }
    
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.imageIncomingIndicator.stopAnimating()
        }
    }
}
