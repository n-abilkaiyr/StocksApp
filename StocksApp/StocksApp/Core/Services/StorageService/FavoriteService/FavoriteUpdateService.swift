//
//  FavoriteUpdateService.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 03.06.2022.
//

import Foundation

@objc protocol FavoriteUpdateServiceProtocol {
    func setFavorite(notification: Notification)
}


extension FavoriteUpdateServiceProtocol {
    func startFavoriteNotificationObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(setFavorite), name: Notification.Name.favorites, object: nil)
    }
}


extension Notification.Name {
    static let favorites = Notification.Name("Update.Favorite.Stocks")
}

extension Notification {
    var stockId: String? {
        guard let userInfo = userInfo,
              let id = userInfo["id"] as? String else  {
                  return nil
              }
        
        return id
    }
}
