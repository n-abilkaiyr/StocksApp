//
//  ChartsModel.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 11.06.2022.
//

import Foundation

//protocol ChartsModelProtocol {
//    var period: Period
//}

struct ChartsModel {
    struct Period {
        let name: String
        let prices: [Double]
    }
    
    let periods: [Period]
    
    static func build(from response: Charts) -> ChartsModel {
        let lastDateIndex = response.prices.count - 1
        let weekPeriod = createWeekPeriod()
        let monthPeriod = createMonthPeriod()
        let sixMonthPeriod = createSixMonthPeriod()
        let oneYearPeriod = createOneYearPeriod()
        
        func createWeekPeriod() -> Period {
            let firstIndex = response.prices.count - 7
            let prices = Array( response.prices[firstIndex...lastDateIndex])
                .map{ roundPrice(price: $0.price) }
            return Period(name: "W", prices: prices)
        }
        
        func createMonthPeriod() -> Period {
            let firstIndex = response.prices.count - 30
            let prices = Array( response.prices[firstIndex...lastDateIndex])
                .map{ roundPrice(price: $0.price) }
            return Period(name: "M", prices: prices)
        }
        
        
        func createSixMonthPeriod() -> Period {
            let firstIndex = response.prices.count - 180
            let prices = Array( response.prices[firstIndex...lastDateIndex])
                .map{ roundPrice(price: $0.price) }
            return Period(name: "6M", prices: prices)
        }
        
        func createOneYearPeriod() -> Period {
            let prices = response.prices.map{ roundPrice(price: $0.price) }
            return Period(name: "1Y", prices: prices)
        }
        
        func roundPrice(price: Double) -> Double {
            Double(round(price * 100) / 100)
        }
        
        // MARK: - Временно
//        func getAverage(prices: [Double]) -> Double {
//            let sum = prices.reduce(0,+)
//            let length = Double(prices.count)
//            return sum / length
//        }
        
        return ChartsModel(periods: [weekPeriod, monthPeriod, sixMonthPeriod, oneYearPeriod])
    }
}

// MARK: - Временно
//extension Array {
//    func chunked(into size: Int) -> [[Element]] {
//          return stride(from: 0, to: count, by: size).map {
//              Array(self[$0 ..< Swift.min($0 + size, count)])
//          }
//      }
//}
