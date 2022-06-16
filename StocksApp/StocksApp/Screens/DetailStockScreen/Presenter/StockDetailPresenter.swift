//
//  StockDetailPresenter.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 30.05.2022.
//

import Foundation
import UIKit
protocol StockDetailViewControllerProtocol: AnyObject {
    func updateView(withChartModel chartModel: ChartsModel)
    func updateView(withLoader isLoading: Bool)
    func updateView(withError message: String)
}
protocol StockDetailPreneterProtocol {
    var stockDetailViewController: StockDetailViewControllerProtocol? { get set }
    var model: StockModelProtocol { get }
    func loadView()
}


final class StockDetailPresenter: StockDetailPreneterProtocol {

    weak var stockDetailViewController: StockDetailViewControllerProtocol?
    private let service: ChartServiceProtocol
    private let stockModel: StockModelProtocol
    
    init(service: ChartServiceProtocol, model: StockModelProtocol) {
        self.service = service
        self.stockModel = model
    }
    
    var model: StockModelProtocol {
        stockModel
    }
    
    func loadView() {
        stockDetailViewController?.updateView(withLoader: true)
        
        service.fetchCharts(id: model.id ) { [weak self] result in
            self?.stockDetailViewController?.updateView(withLoader: false)
            switch result {
            case .success(let charts):
                let chartModel = ChartsModel.build(from: charts)
                self?.stockDetailViewController?.updateView(withChartModel: chartModel)
            case .failure(let error):
                self?.stockDetailViewController?.updateView(withError: error.localizedDescription)
            }
        }
        
    }
}
