//
//  StockModel.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 29.05.2022.
//

import UIKit

protocol StockModelProtocol {
    var id: String { get }
    var name: String { get }
    var iconURL: String { get }
    var symbol: String { get }
    var price: String { get }
    var change: String { get }
    var changeColor: UIColor { get }
    var isFavorite: Bool { get  }
    
    func setFavorite()
}


final class StockModel: StockModelProtocol {
    
    private let stock: Stock
    private let favoritesService: FavoriteServiceProtocol
    
    init(stock: Stock) {
        self.stock = stock
        self.favoritesService = Assembly.assembler.favoritesService
        isFavorite = favoritesService.isFavorite(for: id)
    }
    
    
    var id: String {
        stock.id
    }
    
    var name: String {
        stock.name
    }
    
    var iconURL: String {
        stock.image
    }
    
    var symbol: String {
        stock.symbol
    }
    
    var price: String {
        "\(Double( round(stock.currentPrice * 100) / 100))"
    }
    
    var change: String {
        var priceChange = stock.priceChange
        var resultText = ""
        
        if priceChange > 0 {
            resultText.append("+")
        } else if priceChange < 0 {
            resultText.append("-")
            priceChange *= -1
        }
        
        resultText.append("$")
        resultText.append("\(Double( round(priceChange * 100) / 100)) ")
        resultText.append(" (\(Double(round(stock.percentageChange * 100) / 100))%)")
        
        return resultText
    }
    
    var changeColor: UIColor {
        stock.priceChange >= 0 ? UIColor.StockCell.percenGreenColor : UIColor.StockCell.percenRedColor
    }
    
    var isFavorite: Bool = false
    
    func setFavorite() {
        isFavorite.toggle()
        
        isFavorite
        ? favoritesService.save(id: id)
        : favoritesService.remove(id: id)
    }
}



