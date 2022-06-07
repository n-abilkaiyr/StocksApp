//
//  Presenter.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 01.06.2022.
//

import Foundation

protocol FavoriteStocksViewControllerProtocol: AnyObject {
    func updateView()
    func updateView(withLoader isLoading: Bool)
    func updateView(withError message: String)
    func updateCell(for indexPath: IndexPath, state: Bool)
}

protocol FavoriteStocksPresenterProtocol {
    var viewController: FavoriteStocksViewControllerProtocol? { get set }
    var itemsCount: Int { get }
    func loadView()
    func model(for indexPath: IndexPath) -> StockModelProtocol
}

final class FavoriteStocksPresenter: FavoriteStocksPresenterProtocol {
 
    weak var viewController: FavoriteStocksViewControllerProtocol?

    private var favoriteStocks: [StockModelProtocol] = []
    private let service: StockServiceProtocol
    
    
    init(service: StockServiceProtocol) {
        self.service = service
        startFavoriteNotificationObserving()
    }
    
    var itemsCount: Int {
        favoriteStocks.count
    }
    
    func loadView() {
        favoriteStocks = service.getFavoriteStocks()
        viewController?.updateView()
    }
    
    func model(for indexPath: IndexPath) -> StockModelProtocol {
        return favoriteStocks[indexPath.row]
    }
    
}


extension FavoriteStocksPresenter: FavoriteUpdateServiceProtocol {
    func setFavorite(notification: Notification) {
        let prevoisFavorites = favoriteStocks
        favoriteStocks = service.getFavoriteStocks()
        
        guard let id = notification.stockId else { return }
       
        if let index = favoriteStocks.firstIndex(where: { $0.id == id }) {
            viewController?.updateCell(for: IndexPath(row: index, section: 0), state: true)
        } else if let index = prevoisFavorites.firstIndex(where: { $0.id == id }){
            viewController?.updateCell(for: IndexPath(row: index, section: 0), state: false)
        }
    }
}
