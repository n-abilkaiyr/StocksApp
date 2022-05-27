//
//  StocksService.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 27.05.2022.
//

import Foundation

// https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&per_page=100

enum StocksRouter: Router {
    case stocks(currency: String, count: Int)
   
    var baseUrl: String {
         "https://api.coingecko.com"
    }
    
    var path: String {
        switch self {
        case .stocks:
            return "/api/v3/coins/markets"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .stocks: return .get
            
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .stocks(currency: let currency, count: let count):
            return ["vs_currency" : currency, "per_page" : count]
            
        }
    }
    
}

protocol StockServiceProtocol {
    func fetchStocks(currency: String, count: Int, completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    
    func fetchStocks(currency: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void)
    
    func fetchStocks(completion: @escaping (Result<[Stock], NetworkError>) -> Void)
}

extension StockServiceProtocol {
    func fetchStocks(currency: String, completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        fetchStocks(currency: currency, count: 100, completion: completion)
    }
    
    func fetchStocks(completion: @escaping (Result<[Stock], NetworkError>) -> Void) {
        fetchStocks(currency: "usd", completion: completion)
    }
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
    
