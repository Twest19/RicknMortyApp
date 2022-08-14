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
        selectedIndex = 1
    }
    
    
    private func configCharVCTab() -> UINavigationController {
        let charVC = RMSearchVC()
        charVC.tabBarItem.title = "Characters"
        charVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        return UINavigationController(rootViewController: charVC)
    }
    
    
    private func configEpisodeVCTab() -> UINavigationController {
        let episodeVC = RMEpisodeVC()
        episodeVC.tabBarItem.title = "Episode"
        episodeVC.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
        
        return UINavigationController(rootViewController: episodeVC)
    }
}
