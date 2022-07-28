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
        viewControllers = [configCharVCTab()]
    }
    
    
    func configCharVCTab() -> UINavigationController {
        let charVC = CharacterVC()
        charVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        
        return UINavigationController(rootViewController: charVC)
    }
}
