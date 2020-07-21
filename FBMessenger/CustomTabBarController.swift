//
//  CustomTabBarController.swift
//  FBMessenger
//
//  Created by Hanlin Chen on 7/21/20.
//  Copyright © 2020 Hanlin Chen. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let friendController = FriendController(collectionViewLayout: layout)
        let recentMessageNavController = UINavigationController(rootViewController: friendController)
        recentMessageNavController.tabBarItem.title = "Recent"
        recentMessageNavController.tabBarItem.image = UIImage(named: "recent")
 
        viewControllers = [recentMessageNavController, creatDummyViewController(title: "Calls", imageName: "calls"),
            creatDummyViewController(title: "Groups", imageName: "groups"),
            creatDummyViewController(title: "People", imageName: "people"),
            creatDummyViewController(title: "Settings", imageName: "settings")]
    }
    
    private func creatDummyViewController(title: String, imageName:String)-> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image =  UIImage(named: imageName)
        
        return navController
    }
    
}
