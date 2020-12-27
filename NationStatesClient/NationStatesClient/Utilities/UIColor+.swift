//
//  UIColor+.swift
//  NationStatesClient
//
//  Created by Bart Kneepkens on 27/12/2020.
//

import UIKit

extension UIColor {
    convenience init?(red: Int, green: Int, blue: Int) {
        guard red >= 0 && red <= 255, green >= 0 && green <= 255, blue >= 0 && blue <= 255 else { return nil }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init?(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
