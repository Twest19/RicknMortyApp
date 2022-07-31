//
//  RMStatusImageView.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/31/22.
//

import UIKit

class RMStatusImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = SFSymbols.circle
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    convenience init(sfSymbol: UIImage?) {
        self.init(frame: .zero)
        image = sfSymbol
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setStatus(for status: String) {
        
        switch status {
        case "Alive":
            tintColor = .systemGreen
        case "Dead":
            tintColor = .systemRed
        default:
            tintColor = .secondaryLabel
        }
    }
}
