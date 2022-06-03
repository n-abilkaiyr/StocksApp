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
    
}

final class StockService: StockServiceProtocol {
    private let client: NetworkService
     
    init(client: NetworkService) {
        self.client = client
    }
    
  
    func fetchStocks(currency: String, count: Int, completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        client.execute(with: StocksRouter.stocks(currency: currency, count: count), completion: completion)
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
