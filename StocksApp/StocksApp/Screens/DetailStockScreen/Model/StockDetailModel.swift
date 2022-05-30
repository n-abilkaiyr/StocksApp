//
//  StockDetailModel.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 30.05.2022.
//

import Foundation

protocol StockDetailModelProtocol {
    var prices: [[Double]] { get }
}


final class StockDetailModel: StockDetailModelProtocol {
    
    private let stockDetailResponse: StockDetailResponse
    
    init(stockDetailResponse: StockDetailResponse ) {
        self.stockDetailResponse = stockDetailResponse
    }
    
    var prices: [[Double]] {
        stockDetailResponse.prices
    }

}
