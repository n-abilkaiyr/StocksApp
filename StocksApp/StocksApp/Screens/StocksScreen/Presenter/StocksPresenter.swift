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
}

protocol StocksPresenterProtocol {
    var viewController: StocksViewControllerProtocol? { get set }
    var itemCount: Int { get }
    func loadView()
    func model(for indexPath: IndexPath) -> StockModelProtocol
}

final class StocksPersenter: StocksPresenterProtocol {
   
    private let service:  StockServiceProtocol
    private var allStocks: [Stock] = []
    weak var viewController: StocksViewControllerProtocol?
    
    init(service: StockServiceProtocol) {
        self.service = service
    }
    
    private var stockModels: [StockModelProtocol]  {
        allStocks.map {StockModel(stock: $0)}
    }
    
    var itemCount: Int {
        allStocks.count
    }
    
    func loadView() {
        viewController?.updateView(withLoader: true)
        service.fetchStocks {[weak self] result in
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
        stockModels[indexPath.row]
    }
    
}
