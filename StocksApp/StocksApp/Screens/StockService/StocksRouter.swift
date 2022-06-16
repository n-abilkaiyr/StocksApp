//
//  StocksRouter.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 29.05.2022.
//

import Foundation

enum StocksRouter: Router {
    case stocks(currency: String, count: Int)
    case charts(id: String, currency: String, days: Int, isDaily: Bool)
   
    var baseUrl: String {
         "https://api.coingecko.com"
    }
    
    var path: String {
        switch self {
        case .stocks:
            return "/api/v3/coins/markets"
        case let .charts(id, _, _, _):
            return "/api/v3/coins/\(id)/market_chart"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .stocks, .charts: return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .stocks(currency: let currency, count: let count):
            return [ "vs_currency" : currency,
                    "per_page" : count ]
        
        case let .charts(_, currency, days, isDaily):
            return [ "vs_currency" : currency,
                     "days" : days,
                     "interval": isDaily ? "daily" : "" ]
        }
    }
    
}
