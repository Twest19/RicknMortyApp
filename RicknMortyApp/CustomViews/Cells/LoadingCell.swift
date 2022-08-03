//
//  LoadingCell.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/26/22.
//

import UIKit

class LoadingCell: UICollectionViewCell {
    
    static let identifier = "RMLoadingCell"
    var activityIndicator = UIActivityIndicatorView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureActivityIndicator()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func beginActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
    }
    
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
        }
    }
    
    
    func configureActivityIndicator() {
        contentView.addSubview(activityIndicator)
        contentView.clipsToBounds = true
        activityIndicator.pinToCenter(of: contentView)
    }
}
