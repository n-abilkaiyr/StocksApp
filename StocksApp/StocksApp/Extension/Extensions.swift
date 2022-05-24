//
//  UIFont + Extension.swift
//  StocksApp
//
//  Created by Abilkaiyr Nurzhan on 24.05.2022.
//

import UIKit

// MARK: - NSObject + Extension
extension NSObject {
    static var typeName: String {
        String(describing: self)
    }
}

// MARK: - UIFont + Extension
extension UIFont {
    
    static func Regular(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size)!
    }
    
    static func Light(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Light", size: size)!
    }
    
    static func Bold(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Bold", size: size)!
    }
    
    static func Medium(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-Medium", size: size)!
    }
    
    static func SemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size)!
    }
}


// MARK: - UIColor + Extension
extension UIColor {
    static var grayCellColor: UIColor  { return UIColor(red: 240 / 255,
                                                        green: 244 / 255,
                                                        blue: 247 / 255,
                                                        alpha: 1) }
    static var whiteCellColor: UIColor { .white }
}


