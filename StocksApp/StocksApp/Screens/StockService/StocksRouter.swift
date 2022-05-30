//
//  StocksRouter.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 29.05.2022.
//

import Foundation
// https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&per_page=100

enum StocksRouter: Router {
    case stocks(currency: String, count: Int)
    case stockDetail(id: String, currency: String, days: Int, interval: String)
   
    var baseUrl: String {
         "https://api.coingecko.com"
    }
    
    var path: String {
        switch self {
        case .stocks:
            return "/api/v3/coins/markets"
        case let .stockDetail(id: id, currency: _, days: _, interval: _):
            return "/api/v3/coins/\(id)/market_chart"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .stocks, .stockDetail: return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .stocks(currency: let currency, count: let count):
            return [ "vs_currency" : currency,
                    "per_page" : count ]
        
        case let .stockDetail(_, currency, days, interval):
            return [ "vs_currency" : currency,
                     "days" : days,
                     "interval": interval ]
        }
    }
    
}
