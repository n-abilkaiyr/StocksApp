//
//  StockDetailPresenter.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 30.05.2022.
//

import Foundation
import UIKit
protocol StockDetailViewControllerProtocol: AnyObject {
    func updateView()
    func updateView(withLoader isLoading: Bool)
    func updateView(withError message: String)
}
protocol StockDetailPreneterProtocol {
    var stockDetailViewController: StockDetailViewControllerProtocol? { get set }
    func loadView(with id: String)
    func model() -> StockDetailModelProtocol?
}


final class StockDetailPresenter: StockDetailPreneterProtocol {
    weak var stockDetailViewController: StockDetailViewControllerProtocol?
    private let service: StockServiceProtocol
    private var stockDetailModel: StockDetailModelProtocol?
    
    init(service: StockServiceProtocol) {
        self.service = service
    }
    
    func loadView(with id: String) {
        stockDetailViewController?.updateView(withLoader: true)
        service.fetchStockDetails(id: id) { [weak self] result in
            self?.stockDetailViewController?.updateView(withLoader: false)
            switch result {
            case .success(let stockDetail):
                self?.stockDetailModel = StockDetailModel(stockDetailResponse: stockDetail)
                self?.stockDetailViewController?.updateView()
            case .failure(let error):
                self?.stockDetailViewController?.updateView(withError: error.localizedDescription)
            }
        }
    }
    
    func model() -> StockDetailModelProtocol? {
        stockDetailModel
    }
    
    
}
