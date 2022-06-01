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
}

protocol FavoriteStocksPresenterProtocol {
    var viewController: FavoriteStocksViewControllerProtocol? { get set }
    var itemsCount: Int { get }
    func loadView()
    func model(for indexPath: IndexPath) -> StockModelProtocol
   
}

final class FavoriteStocksPresenter: FavoriteStocksPresenterProtocol {

    weak var viewController: FavoriteStocksViewControllerProtocol?
    private let favoriteService = ModuleBuilder.shared.favoritesService
    private let service: StockServiceProtocol
    private var allStocks: [Stock] = []
    
    private var favoriteStockModels: [StockModelProtocol]  {
        allStocks
            .map {StockModel(stock: $0)}
            .filter{ favoriteService.isFavorite(for: $0.id) }

    }
    
    
    init(service: StockServiceProtocol) {
        self.service = service
    }
    
    var itemsCount: Int {
        favoriteStockModels.count
    }
    
    func loadView() {
        viewController?.updateView(withLoader: true)
        service.fetchStocks { [weak self] result in
            self?.viewController?.updateView(withLoader: false)
            switch result {
            case .success(let stocks):
                self?.allStocks = stocks
                self?.viewController?.updateView()
            case .failure(let error):
                self?.viewController?.updateView(withError: error.localizedDescription)
            }
        }
    }
    
    func model(for indexPath: IndexPath) -> StockModelProtocol {
        favoriteStockModels[indexPath.row]
    }
    
    
}
