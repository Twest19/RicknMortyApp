//
//  RMErrorView.swift
//  RicknMortyApp
//
//  Created by Tim West on 8/7/22.
//

import UIKit

// View that displays when a searched character does not exisit
class RMErrorView: UIView {
    
    let errorLabel = RMSecondaryLabel(fontSize: 24)
    let errorImageView = UIImageView()
    
    private let padding: CGFloat = 20
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(errorLabel, errorImageView)
        configureErrorLabel()
        configureErrorImageView()
    }
    
    
    convenience init(error: RMError) {
        self.init(frame: .zero)
        errorLabel.text = error.rawValue
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setErrorView(with error: RMError) {
        errorLabel.text = error.rawValue
    }
    
    
    private func configureErrorLabel() {
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.numberOfLines = 4
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            errorLabel.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    
    private func configureErrorImageView() {
        errorImageView.image = Images.errorImage
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorImageView.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10),
            errorImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            errorImageView.widthAnchor.constraint(equalToConstant: 97),
            errorImageView.heightAnchor.constraint(equalToConstant: 284)
        ])
    }
}
