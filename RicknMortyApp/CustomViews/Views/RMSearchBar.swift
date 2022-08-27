//
//  RMSearchBar.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/14/22.
//

import UIKit

class RMSearchBar: UISearchBar {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        sizeToFit()
        placeholder = "Search Characters Here..."
        tintColor = .label
        searchBarStyle = .minimal
    }
}
