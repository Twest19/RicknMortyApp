//
//  UIView-Extension.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/23/22.
//

import UIKit

extension UIView {
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    
    func pinToCenter(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            heightAnchor.constraint(equalTo: superview.heightAnchor),
            widthAnchor.constraint(equalTo: superview.widthAnchor)
        ])
    }
    
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
