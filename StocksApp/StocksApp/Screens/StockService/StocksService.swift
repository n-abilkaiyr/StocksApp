//
//  StocksService.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 27.05.2022.
//

import Foundation


protocol StockServiceProtocol {
    func fetchStocks(currency: String, count: Int, completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    
    func fetchStocks(currency: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    
    func fetchStocks(completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    func setStocks(stocks: [Stock])
    
}

final class StockService: StockServiceProtocol {
      
    private let client: NetworkService
    private var stocks: [Stock] = []
    private var stocksModels: [StockModelProtocol] {
        stocks.map {StockModel(stock: $0)}
    }
    
    
    init(client: NetworkService) {
        self.client = client
    }
    
  //mojno obernut' v novuiu funciu
    func fetchStocks(currency: String, count: Int, completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        print("Stocks: ", stocks)
        if stocks.isEmpty {
            client.execute(with: StocksRouter.stocks(currency: currency, count: count), completion: completion)
        } else {
            completion(.success(stocks))
        }
    }
    // 
    func setStocks(stocks: [Stock]) {
        self.stocks = stocks
    }
}
    

extension StockServiceProtocol {
    // For stocks
    func fetchStocks(currency: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        fetchStocks(currency: currency, count: 100, completion: completion)
    }
    
    func fetchStocks(completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        fetchStocks(currency: "usd", completion: completion)
    }
}
