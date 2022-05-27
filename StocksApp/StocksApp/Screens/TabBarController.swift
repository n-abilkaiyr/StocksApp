//
//  TabBarController.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 27.05.2022.
//

import UIKit


class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
    }
    
    
    func setupViewControllers() {
        guard let stockImage = UIImage(named: "diagramTab"),
              let favoriteImage = UIImage(named: "favoriteTab"),
              let searchImage = UIImage(named: "searchTab") else  { return }
        
        let stocksViewController = StocksViewController()
        let favoriteViewController = UIViewController()
        let searchViewController = UIViewController()
        
        favoriteViewController.view.backgroundColor = .systemBackground
        searchViewController.view.backgroundColor = .systemBackground
        
        viewControllers = [
            createNavigationController(with: stocksViewController, title: "Stocks", image: stockImage),
            createNavigationController(with: favoriteViewController, title: "Favourite", image: favoriteImage),
            
            createNavigationController(with: searchViewController, title: "Search", image: searchImage)
        ]
    }
    
    private func createNavigationController(with rootViewController: UIViewController,
                                            title: String,
                                            image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.navigationBar.tintColor = .black
        return navController
        
    }
}

