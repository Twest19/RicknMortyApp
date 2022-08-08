//
//  RMErrorView.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/7/22.
//

import UIKit

// View that displays when a searched character does not exisit
class RMErrorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    convenience init(message: String, error: RMError) {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
