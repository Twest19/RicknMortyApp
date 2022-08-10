//
//  RMDataLoadingVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/7/22.
//

import UIKit

class RMDataLoadingVC: UIViewController {
    
    var containerView: UIView!
    var errorView = RMErrorView()

    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) { self.containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            self.containerView.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    
    func showEmptyStateView(with message: String, and error: RMError, in view: UIView) {
//        let emptyStateView = RMErrorView(message: message, error: error)
//        emptyStateView.frame = view.bounds
//        view.addSubview(emptyStateView)
        errorView.setErrorView(with: message, and: error)
        errorView.frame = view.bounds
        view.addSubview(errorView)
    }
    
    
    func dismissErrorView() {
        DispatchQueue.main.async {
            self.errorView.removeFromSuperview()
        }
    }
}


