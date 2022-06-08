//
//  SearchService.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 08.06.2022.
//

import Foundation

protocol SearchServiceProtocol {
    func getFilteredStocks(by text: String?) -> [StockModelProtocol]
}


class SearchService: SearchServiceProtocol {
    
    private let service: StockServiceProtocol
    
    
    init(service: StockServiceProtocol) {
       self.service = service
   }
    
    
    func getFilteredStocks(by text: String?) -> [StockModelProtocol] {
        guard let text = text,
              !text.isEmpty else {
            return service.getStocks()
        }
        return service.getStocks().filter {$0.symbol.lowercased().contains(text.lowercased())}
    }
        
}
