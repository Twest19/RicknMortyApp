//
//  RMErrorView.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/7/22.
//

import UIKit

// View that displays when a searched character does not exisit
class RMErrorView: UIView {
    
    let messageLabel = RMPrimaryLabel(textAlignment: .left, fontSize: 30, weight: .heavy)
    let errorLabel = RMSecondaryLabel(fontSize: 24)
    let errorImageView = UIImageView()
    
    private let padding: CGFloat = 20
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(messageLabel, errorLabel, errorImageView)
        configureMessageLabel()
        configureErrorLabel()
        configureErrorImageView()
    }
    
    
    convenience init(message: String, error: RMError) {
        self.init(frame: .zero)
        messageLabel.text = message
        errorLabel.text = error.rawValue
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setErrorView(with message: String, and error: RMError) {
        messageLabel.text = message
        errorLabel.text = error.rawValue
    }
    
    
    private func configureMessageLabel() {
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 2
        
//        NSLayoutConstraint.activate([
//            messageLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
//            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
//            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
//            messageLabel.heightAnchor.constraint(equalToConstant: 200)
//        ])
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            messageLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    
    private func configureErrorLabel() {
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            errorLabel.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    
    private func configureErrorImageView() {
        errorImageView.image = Images.rmOne
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 45),
            errorImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorImageView.widthAnchor.constraint(equalToConstant: 350),
            errorImageView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}
