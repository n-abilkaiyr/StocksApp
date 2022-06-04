//
//  ModuleBulilder.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 29.05.2022.
//

import Foundation
import UIKit

final class Assembly {
    static let assembler: Assembly = .init()
    let favoritesService: FavoriteServiceProtocol =  FavoritesLocalService()
    private init () {}
    
    
    private lazy var network: NetworkService = Network()
    private lazy var stocksService: StockServiceProtocol = StockService(client: network)
    private lazy var chartsService: ChartServiceProtocol = ChartService(client: network)
    private lazy var stocksPresenter: StocksPresenterProtocol = StocksPersenter(service: stocksService)
    
    private func stocksModule() -> UIViewController {
        let stocksVC = StocksViewController(presenter: stocksPresenter)
        stocksPresenter.viewController = stocksVC
        return stocksVC
    }
    
    func detailStockModule(with model: StockModelProtocol) -> DetailStockViewController {
        let presenter = StockDetailPresenter(service: chartsService, model: model)
        let detailStockVC = DetailStockViewController(presenter: presenter)
        presenter.stockDetailViewController = detailStockVC
        return detailStockVC
    }
    
    private func favoritesModule() -> UIViewController {
        let presenter = FavoriteStocksPresenter(service: stocksService)
        let favoritesVC = FavoriteStocksViewController(presenter: presenter)
        presenter.viewController = favoritesVC
        presenter.delegate = stocksPresenter
        return favoritesVC
    }
    
    private  func searchModule() -> UIViewController {
        UIViewController()
    }
    
    
    
    func tabBarController() -> UIViewController {
        let tabBar = UITabBarController()
        let stockVC = stocksModule()
        let favoritesVC = favoritesModule()
        let searchVC = searchModule()
        
       
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
