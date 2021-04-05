//
//  MainTabBarController.swift
//  Covaid
//
//  Created by Dr.Drake on 5/17/20.
//  Copyright © 2020 Dr.Drake. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var home: HomeVC?
    var history: HistoryVC?
    var profile: ProfileVC?
    var subVC: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        home = HomeVC()
        history = HistoryVC()
        profile = ProfileVC()
        
        subVC.append(home!)
        subVC.append(history!)
        subVC.append(profile!)
        
        home?.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "home"), tag: 0)
        history?.tabBarItem = UITabBarItem(title: "History", image: #imageLiteral(resourceName: "history"), tag: 1)
        profile?.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "profile"), tag: 2)
        
        
        self.setViewControllers(subVC, animated: true)
        self.selectedIndex = 0
        self.selectedViewController = home
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabBar.tintColor = UIColor(hex: Covaid.color4)
        tabBar.barTintColor = .white
    }
    
}
