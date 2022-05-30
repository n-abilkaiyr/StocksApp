//
//  StocksService.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 27.05.2022.
//

import Foundation


protocol StockServiceProtocol {
    // For stocks
    func fetchStocks(currency: String, count: Int, completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    
    func fetchStocks(currency: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    
    func fetchStocks(completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    
    // For stock detail
    func fetchStockDetails(id: String, currency: String, days: Int, interval: String, completion: @escaping (Result<StockDetailResponse, NetworkError>) -> Void)
    
    
    func fetchStockDetails(id: String, currency: String, days: Int, completion: @escaping (Result<StockDetailResponse, NetworkError>) -> Void)
    
    func fetchStockDetails(id: String, currency: String, completion: @escaping (Result<StockDetailResponse, NetworkError>) -> Void)
    
    func fetchStockDetails(id: String, completion: @escaping (Result<StockDetailResponse, NetworkError>) -> Void)
}

final class StockService: StockServiceProtocol {
    private let client: NetworkService
     
    init(client: NetworkService) {
        self.client = client
    }
    
  
    func fetchStocks(currency: String, count: Int, completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        client.execute(with: StocksRouter.stocks(currency: currency, count: count), completion: completion)
        }
    
    func fetchStockDetails(id: String, currency: String, days: Int, interval: String, completion: @escaping (Result<StockDetailResponse, NetworkError>) -> Void) {
        client.execute(with: StocksRouter.stockDetail(id: id, currency: currency, days: days, interval: interval), completion: completion)
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
    
    
    // For stock detail
    func fetchStockDetails(id: String, currency: String, days: Int, completion: @escaping (Result<StockDetailResponse, NetworkError>) -> Void) {
        fetchStockDetails(id: id, currency: currency, days: days, interval: "daily", completion: completion)
    }
    
    func fetchStockDetails(id: String, currency: String, completion: @escaping (Result<StockDetailResponse, NetworkError>) -> Void) {
        fetchStockDetails(id: id, currency: currency, days: 60, completion: completion)
    }
    
    func fetchStockDetails(id: String, completion: @escaping (Result<StockDetailResponse, NetworkError>) -> Void) {
        fetchStockDetails(id: id, currency: "usd", completion: completion)
    }
}
