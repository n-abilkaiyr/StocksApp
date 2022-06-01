//
//  ModuleBulilder.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 29.05.2022.
//

import Foundation
import UIKit

final class ModuleBuilder {
    static let shared: ModuleBuilder = .init()
    private init () {}
    
    
    let favoritesService: FavoriteServiceProtocol =  FavoritesLocalService()
        
    private lazy var network: NetworkService = {
        Network()
    }()
    
    private func networkService() -> NetworkService {
        network
    }
    
    private func stocksModule() -> UIViewController {
        let presenter = StocksPersenter(service: stocksService())
        let stocksVC = StocksViewController(presenter: presenter)
        presenter.viewController = stocksVC
        return stocksVC
    }
    
    func detailStockModule(with id: String) -> DetailStockViewController {
        let presenter = StockDetailPresenter(service: stocksService())
        let detailStockVC = DetailStockViewController(presenter: presenter, id: id)
        presenter.stockDetailViewController = detailStockVC
        return detailStockVC
    }
    
    private func favoritesModule() -> UIViewController {
        let presenter = FavoriteStocksPresenter(service: stocksService())
        let favoritesVC = FavoriteStocksViewController(presenter: presenter)
        presenter.viewController = favoritesVC
        return favoritesVC
    }
    
    private  func searchModule() -> UIViewController {
        UIViewController()
    }
    
    private func stocksService() -> StockServiceProtocol {
        StockService(client: network)
    }
    
    
    func tabBarController() -> UIViewController {
        let tabBar = UITabBarController()
        let stockVC = stocksModule()
        let favoritesVC = favoritesModule()
        let searchVC = searchModule()
        
        [favoritesVC, searchVC].forEach { $0.view.backgroundColor = .systemBackground }
        
        
        tabBar.viewControllers = [
            createNavigationController(with: stockVC, title: "Stocks", image:  UIImage(named: "diagramTab")),
            createNavigationController(with: favoritesVC, title: "Favourite", image:  UIImage(named: "favoriteTab")),
            createNavigationController(with: searchVC, title: "Search", image: UIImage(named: "searchTab"))
        ]
        
        return tabBar
    }
    
    
    private func createNavigationController(with rootViewController: UIViewController,
                                            title: String,
                                            image: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        navController.navigationBar.tintColor = .black
        return navController
    }
    
    
}
