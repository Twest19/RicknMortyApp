//
//  UIViewController+EXT.swift
//  RicknMortyApp
//
//  Created by Tim West on 12/8/23.
//

import UIKit

@nonobjc extension UIViewController {
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    func add(childVC: UIViewController, frame: CGRect? = nil) {
        addChild(childVC)
        if let frame = frame {
            childVC.view.frame = frame
        }
        view.addSubview(childVC.view)
        childVC.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}



