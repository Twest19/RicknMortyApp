//
//  RMDetailView.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/10/22.
//

import UIKit

class RMDetailView: UIView {
    
    var detailImage = UIImageView()
    var detailName = UILabel()
    var detailStatus = UILabel()
    var detailFirstSeen = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configDetailImage()
        configDetailName()
        configDetailStatus()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    
    func configDetailImage() {
        self.addSubview(detailImage)
        detailImage.translatesAutoresizingMaskIntoConstraints = false
        detailImage.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            detailImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            detailImage.topAnchor.constraint(equalTo: self.topAnchor),
            detailImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            detailImage.heightAnchor.constraint(equalToConstant: 300)
        ])
    }


    func configDetailName() {
        self.addSubview(detailName)
        detailName.textAlignment = .left
        detailName.numberOfLines = 0
        detailName.textColor = .white
        detailName.font = .systemFont(ofSize: 19, weight: .bold)
        detailName.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailName.topAnchor.constraint(equalTo: detailImage.bottomAnchor, constant: 10),
            detailName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            detailName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)

        ])
    }


    func configDetailStatus() {
        self.addSubview(detailStatus)
        detailStatus.textAlignment = .left
        detailStatus.numberOfLines = 0
        detailStatus.textColor = .white
        detailStatus.font = .systemFont(ofSize: 19, weight: .bold)
        detailStatus.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            detailStatus.topAnchor.constraint(equalTo: detailName.bottomAnchor, constant: 5),
            detailStatus.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            detailStatus.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)

        ])
    }
    
}
