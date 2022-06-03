//
//  FavoriteService.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 01.06.2022.
//

import Foundation

protocol FavoriteServiceProtocol {
    func save(id: String)
    func remove(id: String)
    func isFavorite(for id: String) -> Bool
}

