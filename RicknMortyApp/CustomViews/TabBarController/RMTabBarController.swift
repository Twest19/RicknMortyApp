//
//  RMTabBarController.swift
//  RicknMortyApp
//
//  Created by Tim West on 7/26/22.
//

import UIKit

class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [configCharVCTab(), configEpisodeVCTab()]
    }
    
    
    private func configCharVCTab() -> UINavigationController {
        let charVC = RMSearchVC()
        charVC.tabBarItem = UITabBarItem(title: "Character", image: SFSymbols.peopleFill, tag: 0)
        return UINavigationController(rootViewController: charVC)
    }
    
    
    private func configEpisodeVCTab() -> UINavigationController {
        let episodeVC = RMEpisodeVC()
        episodeVC.tabBarItem = UITabBarItem(title: "Episode", image: SFSymbols.film, tag: 1)
        return UINavigationController(rootViewController: episodeVC)
    }
}
