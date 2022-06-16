//
//  FileManagerFavoritesService.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 03.06.2022.
//

import Foundation

final class FavoritesLocalService: FavoriteServiceProtocol {
    private lazy var path: URL = {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent("favorites")
    }()
    
    private lazy var favoriteIds: [String] = {
        do {
            let data = try Data(contentsOf: path)
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("FileManager ReadError - ", error.localizedDescription)
            return []
        }
    }()
    
    func save(id: String) {
        favoriteIds.append(id)
        updateRepo(with: id)
    }
    
    func remove(id: String) {
        if let removeIndex = favoriteIds.firstIndex(where: {$0 == id}) {
            favoriteIds.remove(at: removeIndex)
            updateRepo(with: id)
        }
    }
    
    func isFavorite(for id: String) -> Bool {
        favoriteIds.contains(id)
    }
    
    private func updateRepo(with id: String) {
        do {
            let data = try JSONEncoder().encode(favoriteIds)
            try data.write(to: path)
            postId(id: id)
        } catch {
            print("FileManager WriteError - ", error.localizedDescription)
        }
    }
    
    private func postId(id: String) {
        NotificationCenter.default.post(name: Notification.Name.favorites, object: nil, userInfo: ["id": id])
    }
}
