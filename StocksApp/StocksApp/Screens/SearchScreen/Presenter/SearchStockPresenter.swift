//
//  SearchStockPresenter.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 08.06.2022.
//

import Foundation
protocol SearchTextFiledDelegate: AnyObject {
    func textDidChange(to text: String?)
}

protocol SearchStocksPresenterProtocol: SearchTextFiledDelegate {
    var viewController: StocksViewControllerProtocol? { get set }
    var itemCount: Int { get }
    func loadView()
    func model(for indexPath: IndexPath) -> StockModelProtocol
}

final class SearchPersenter: SearchStocksPresenterProtocol {
    private let searchService:  SearchServiceProtocol
    private var filteredStocks: [StockModelProtocol] = []
    weak var viewController: StocksViewControllerProtocol?
    
    init(service: SearchServiceProtocol) {
        self.searchService = service
        startFavoriteNotificationObserving()
    }

    var itemCount: Int {
        filteredStocks.count
    }
    
    func loadView() {
        filteredStocks = searchService.getFilteredStocks(by: nil)
        viewController?.updateView()
    }
    
    func model(for indexPath: IndexPath) -> StockModelProtocol {
        filteredStocks[indexPath.row]
    }
    
}


extension SearchPersenter: FavoriteUpdateServiceProtocol {
    func setFavorite(notification: Notification) {
        guard let id = notification.stockId,
              let index = filteredStocks.firstIndex(where: { $0.id == id }) else {
            return
        }

        viewController?.updateCell(for: IndexPath(row: index, section: 0))
    }
}


extension SearchPersenter: SearchTextFiledDelegate {
    func textDidChange(to text: String?) {
        filteredStocks = searchService.getFilteredStocks(by: text)
        viewController?.updateView()
    }
}

