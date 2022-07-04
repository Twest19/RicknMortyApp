//
//  CharDetailVC.swift
//  RicknMortyApp
//
//  Created by Tim West on 6/25/22.
//

import UIKit

class CharDetailVC: UIViewController {
    
    var charImageView = UIImageView()
    var charNameLabel = UILabel()
    var charStatus = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        configNavBar()
        configCharImage()
        configNameLabel()
        configuCharStatus()
    }
    
    func configNavBar() {
        
        let backButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissSelf))
        backButton.tintColor = .systemGreen
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    
    func configCharImage() {
        view.addSubview(charImageView)
        
        charImageView.contentMode = .scaleAspectFill
        charImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            charImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            charImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            charImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            charImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        
    }
    
    
    func configNameLabel() {
        view.addSubview(charNameLabel)
        
        charNameLabel.textAlignment = .center
        charNameLabel.font = .systemFont(ofSize: 19, weight: .bold)
        charNameLabel.numberOfLines = 0
        charNameLabel.lineBreakMode = .byWordWrapping
        
        charNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            charNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            charNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            charNameLabel.topAnchor.constraint(equalTo: charImageView.bottomAnchor, constant: 60)
        
        ])
        
        
    }
    
    
    func configuCharStatus() {
        view.addSubview(charStatus)
        
        charStatus.textAlignment = .center
        charStatus.font = .systemFont(ofSize: 14, weight: .semibold)
        charStatus.numberOfLines = 0
        charStatus.lineBreakMode = .byWordWrapping
        
        charStatus.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            charStatus.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            charStatus.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            charStatus.topAnchor.constraint(equalTo: charNameLabel.bottomAnchor, constant: 20)
        ])
        
        
    }
    
}
