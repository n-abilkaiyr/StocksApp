//
//  StocksStorageService.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 03.06.2022.
//

import Foundation
protocol StocksStorageServiceProtocol {
    func save(stocks: [Stock])
    func fetch() -> [Stock]
    func remove()
}

final class StocksStorageService: StocksStorageServiceProtocol {
    private lazy var path: URL = {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("allStocks")
    }()
    
    func save(stocks: [Stock]) {
        updateRepo(with: stocks)
    }
    
    func remove() {
        updateRepo(with: [])
    }
    
    func fetch() -> [Stock] {
        do {
            let data = try Data(contentsOf: path)
            return try JSONDecoder().decode([Stock].self, from: data)
        } catch {
            print("FileManager ReadError - ", error.localizedDescription)
        }
        return []
    }
    
    private func updateRepo(with stocks: [Stock]) {
        do {
            let data = try JSONEncoder().encode(stocks)
            try data.write(to: path)
        } catch {
            print("FileManager WriteError - ", error.localizedDescription)
        }
    }
    
    
}
