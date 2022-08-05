//
//  StackView+Ext.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/4/22.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
