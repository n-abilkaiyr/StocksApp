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
    var delegate: StockModelsDelegate? { get set }
    var itemsCount: Int { get }
    func loadView()
    func model(for indexPath: IndexPath) -> StockModelProtocol
}

final class FavoriteStocksPresenter: FavoriteStocksPresenterProtocol {
    weak var delegate: StockModelsDelegate?
    weak var viewController: FavoriteStocksViewControllerProtocol?
    
    private let favoriteService = Assembly.assembler.favoritesService
    private var stocks: [StockModelProtocol] = []
    private var previousfavoriteService: [StockModelProtocol] = []
    
    private var favoriteStockModels: [StockModelProtocol]  {
        stocks.filter { $0.isFavorite }
    }
    
    init() {
        startFavoriteNotificationObserving()
    }
    
    var itemsCount: Int {
        favoriteStockModels.count
    }
    
    func loadView() {
        stocks = delegate?.stockModels() ?? []
        previousfavoriteService = favoriteStockModels
        viewController?.updateView()
    }
    
    func model(for indexPath: IndexPath) -> StockModelProtocol {
        return favoriteStockModels[indexPath.row]
    }
    
}


extension FavoriteStocksPresenter: FavoriteUpdateServiceProtocol {
    func setFavorite(notification: Notification) {
        guard let id = notification.stockId else { return }
        guard let index = favoriteStockModels.firstIndex(where: { $0.id == id }) else  {
            
            if let newIndex = previousfavoriteService.firstIndex(where: { $0.id == id }) {
                previousfavoriteService = favoriteStockModels
                viewController?.updateCell(for: IndexPath(row: newIndex, section: 0), state: false)
            }
          return
        }
        viewController?.updateCell(for: IndexPath(row: index, section: 0), state: true)
        previousfavoriteService = favoriteStockModels
    }
    
}
