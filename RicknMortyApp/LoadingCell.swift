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
        //contentView.backgroundColor = .black
        contentView.addSubview(activityIndicator)
        contentView.clipsToBounds = true
        configureActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureActivityIndicator() {
        
        activityIndicator.clipsToBounds = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        activityIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    
    }
    
}
