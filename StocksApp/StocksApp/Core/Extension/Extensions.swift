//
//  UIFont + Extension.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 24.05.2022.
//

import UIKit
import Kingfisher

// MARK: - NSObject + Extension
extension NSObject {
    static var typeName: String {
        String(describing: self)
    }
}

// MARK: - UIFont extension
extension UIFont {
    static func regular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Montserrat-Regular", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .regular)
        }
        return font
    }
    
    static func light(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Montserrat-Light", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .light)
        }
        return font
    }
    
    static func bold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Montserrat-Bold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .bold)
        }
        return font
    }
    
    static func medium(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Montserrat-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .medium)
        }
        return font
    }
    
    static func semiBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "Montserrat-SemiBold", size: size) else {
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        return font
        
    }
}

// MARK: - UIColor
extension UIColor {
    static let favoriteButtonColor = UIColor(red: 1,
                                             green: 202 / 255,
                                             blue: 28 / 255,
                                             alpha: 1)
    
    static let periodButtonBackgroundColor = UIColor(red: 240 / 255,
                                                     green: 244 / 255,
                                                     blue: 247 / 255,
                                                     alpha: 1)
    
    static let chartTopColor =  UIColor(red: 0.863, green: 0.863, blue: 0.863, alpha: 1)
    static let chartBottomColor = UIColor(red: 0.921, green: 0.921, blue: 0.921, alpha: 0)
}



// MARK: - UIImageView
extension UIImageView {
    func setImage(from source: String?, placeholder: UIImage?) {
        guard let urlString = source,
              let url = URL(string: urlString) else { return }
        kf.indicatorType = .activity
        kf.setImage(with: url, placeholder: placeholder )
    }
}
