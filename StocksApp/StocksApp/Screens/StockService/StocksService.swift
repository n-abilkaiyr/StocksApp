//
//  StocksService.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 27.05.2022.
//

import Foundation
typealias ServiceCompletion = (Result<[Stock], NetworkError>) -> (Void)
typealias ClientCompletion = (Result<[StockModelProtocol], NetworkError>) -> (Void)

protocol StockServiceProtocol {
    func fetchStocks(currency: String, count: Int, completion: @escaping ClientCompletion)
    
    func fetchStocks(currency: String, completion: @escaping ClientCompletion)
    
    func fetchStocks(completion: @escaping ClientCompletion)
    
    func getFavoriteStocks() -> [StockModelProtocol]
}

final class StockService: StockServiceProtocol {
    
    private let client: NetworkService
    private var stocksModels: [StockModelProtocol] = []
    
    // можно здесь создать проперти и для избранных
    init(client: NetworkService) {
        self.client = client
    }
    
    func fetchStocks(currency: String, count: Int, completion: @escaping ClientCompletion) {
        
        if stocksModels.isEmpty {
            print("isEmpty")
            let serviceCompletion = serviceCompletion(with: completion)
            
            client.execute(with: StocksRouter.stocks(currency: currency, count: count), completion: serviceCompletion)
        } else {
            print("isNotEmpty")
            completion(.success(stocksModels))
        }
        
    }
    
    func getFavoriteStocks() -> [StockModelProtocol] {
        stocksModels.filter {$0.isFavorite}
    }
    
    private func serviceCompletion(with completion: @escaping ClientCompletion ) -> ServiceCompletion {
        { [weak self] result in
            switch result {
            case .success(let stocks):
                self?.stocksModels = stocks.map{StockModel(stock: $0)}
                completion(.success(self?.stocksModels ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
    

extension StockServiceProtocol {
    // For stocks
    func fetchStocks(currency: String, completion: @escaping ClientCompletion) {
        fetchStocks(currency: currency, count: 100, completion: completion)
    }
    
    func fetchStocks(completion: @escaping ClientCompletion) {
        fetchStocks(currency: "usd", completion: completion)
    }
}
