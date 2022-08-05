//
//  RMButton.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/4/22.
//

import UIKit

class RMButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(color: UIColor, title: String) {
        self.init(frame: .zero)
        set(color: color, title: title)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        configuration = .tinted()
        configuration?.cornerStyle = .capsule
    }
    
    public func set(color: UIColor, title: String) {
        configuration?.title = title
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
    }
}
