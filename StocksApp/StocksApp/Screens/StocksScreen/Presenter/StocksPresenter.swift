//
//  StocksPresenter.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 28.05.2022.
//

import Foundation

protocol StocksViewControllerProtocol: AnyObject {
    func updateView()
    func updateView(withLoader isLoading: Bool)
    func updateView(withError message: String)
    func updateCell(for indexPath: IndexPath)
}

protocol StocksPresenterProtocol: StockModelsDelegate {
    var viewController: StocksViewControllerProtocol? { get set }
    var itemCount: Int { get }
    func loadView()
    func model(for indexPath: IndexPath) -> StockModelProtocol
}

final class StocksPersenter: StocksPresenterProtocol {
    private let service:  StockServiceProtocol
    private var stocks: [StockModelProtocol] = []
    weak var viewController: StocksViewControllerProtocol?
    
    init(service: StockServiceProtocol) {
        self.service = service
        startFavoriteNotificationObserving()
    }

    var itemCount: Int {
        stocks.count
    }
    
    func loadView() {
        viewController?.updateView(withLoader: true)
        service.fetchStocks {[weak self] result in
            self?.viewController?.updateView(withLoader: false)
            switch result {
            case .success(let stocks):
                self?.stocks = stocks
                self?.viewController?.updateView()
            case .failure(let error):
                self?.viewController?.updateView(withError: error.localizedDescription)
            }
        }
    }
    
    func model(for indexPath: IndexPath) -> StockModelProtocol {
        stocks[indexPath.row]
    }
    
}


// MARK: - FavoriteUpdateServiceProtocol
extension StocksPersenter: FavoriteUpdateServiceProtocol {
    func setFavorite(notification: Notification) {
        guard let id = notification.stockId,
              let index = stocks.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        viewController?.updateCell(for: IndexPath(row: index, section: 0))
    }
    
}


