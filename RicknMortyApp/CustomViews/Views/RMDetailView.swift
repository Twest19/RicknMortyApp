//
//  RMDetailView.swift
//  RicknMortyApp
//
//  Created by Tim West on 12/8/23.
//

import UIKit

class RMDetailView: UIView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let episodeOneView = UIView()
    let episodeTwoView = UIView()
    
    private let padding: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createSubviews() {
        configureScrollView()
        configureHeaderView()
        configureEpisodeOneView()
        configureEpisodeTwoView()
    }
    
    
    private func configureScrollView() {
        addSubview(scrollView)
        scrollView.addSubviews(contentView)
        scrollView.pinToEdges(of: self)
        
        contentView.addSubviews(headerView, episodeOneView, episodeTwoView)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 700)
        ])
    }
    
    
    private func configureHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 170)
        ])
    }
    
    
    private func configureEpisodeOneView() {
        episodeOneView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            episodeOneView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            episodeOneView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            episodeOneView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            episodeOneView.heightAnchor.constraint(equalToConstant: 190)
        ])
    }
    
    
    private func configureEpisodeTwoView() {
        episodeTwoView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            episodeTwoView.topAnchor.constraint(equalTo: episodeOneView.bottomAnchor, constant: 20),
            episodeTwoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            episodeTwoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            episodeTwoView.heightAnchor.constraint(equalToConstant: 190)
        ])
    }
}
