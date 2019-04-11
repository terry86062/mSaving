//
//  UIColor - extension.swift
//  mSaving
//
//  Created by 黃偉勛 Terry on 2019/4/3.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

extension UIColor {

    static let mSGreen = UIColor(red: 57 / 255, green: 130 / 255, blue: 69 / 255, alpha: 1)

    static let mSLightGreen = UIColor(red: 101 / 255, green: 177 / 255, blue: 80 / 255, alpha: 1)

    static let mSYellow = UIColor(red: 252 / 255, green: 222 / 255, blue: 116 / 255, alpha: 1)

    // UIColor(red: 228 / 255, green: 190 / 255, blue: 64 / 255, alpha: 1) // yellow
    
    static func hexStringToUIColor(hex: String) -> UIColor {
        
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if cString.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
