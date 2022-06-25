//
//  UIImageView-Ext.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/24/22.
//

import UIKit

extension UIImageView {
    func load(url: URL){
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
        
    }
}
