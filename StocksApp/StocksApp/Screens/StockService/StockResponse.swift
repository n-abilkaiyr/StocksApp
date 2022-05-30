//
//  StockResponse.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 29.05.2022.
//

import Foundation

struct Stock: Decodable {
    let id: String
    let name: String
    let symbol: String
    let image: String
    let currentPrice: Double
    let priceChange: Double
    let percentageChange: Double
    

    enum CodingKeys: String, CodingKey {
        case id, name, symbol, image
        case currentPrice = "current_price"
        case priceChange = "price_change_24h"
        case percentageChange = "price_change_percentage_24h"
    }
}


struct StockDetailResponse: Decodable {
    let prices: [[Double]]
    let totalVolumes: [[Double]]
    
    enum CodingKeys: String, CodingKey {
        case prices
        case totalVolumes = "total_volumes"
    }
}

