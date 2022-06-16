//
//  UserDefaultsFavoritesService.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 03.06.2022.
//

import Foundation
final class FavoriteService: FavoriteServiceProtocol {
    private let key = "favorites"
    private lazy var favoriteIds: [String] = {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data,
              let ids = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        
        return ids
    }()
    
    func save(id: String) {
        favoriteIds.append(id)
        updateRepo()
    }
    
    func remove(id: String) {
        if let removeIndex = favoriteIds.firstIndex(where: {$0 == id}) {
            favoriteIds.remove(at: removeIndex)
            updateRepo()
        }
    }
    
    func isFavorite(for id: String) -> Bool {
        favoriteIds.contains(id)
    }
    
    private func updateRepo() {
        guard let data = try? JSONEncoder().encode(favoriteIds) else {
            return
        }
        UserDefaults.standard.set(data, forKey: key)
    }
}


