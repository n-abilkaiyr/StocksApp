//
//  ChartService.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 03.06.2022.
//

import Foundation

protocol ChartServiceProtocol {
    func fetchCharts(id: String, currency: String, days: Int, isDaily: Bool, completion: @escaping (Result<Charts, NetworkError>) -> Void)
    
    func fetchCharts(id: String, completion: @escaping (Result<Charts, NetworkError>) -> Void )
}

final class ChartService: ChartServiceProtocol {
    private let client: NetworkService
    
    init(client: NetworkService) {
        self.client = client
    }
    
    func fetchCharts(id: String, currency: String, days: Int, isDaily: Bool, completion: @escaping (Result<Charts, NetworkError>) -> Void) {
        client.execute(with: StocksRouter.charts(id: id, currency: currency, days: days, isDaily: isDaily), completion: completion)
    }
    
    
}

extension ChartServiceProtocol {
    func fetchCharts(id: String, completion: @escaping (Result<Charts, NetworkError>) -> Void) {
        fetchCharts(id: id, currency: "usd", days: 364, isDaily: true, completion: completion)
    }
}
