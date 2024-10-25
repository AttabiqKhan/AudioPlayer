//
//  Color.swift
//  Audio Player
//
//  Created by Attabiq Khan on 21/10/2024.
//

import Foundation
import UIKit

extension UIColor {
    
    @nonobjc class var dimWhite: UIColor {
        return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
    }
    // Deep blue-gray (46, 64, 87)
    @nonobjc class var primary: UIColor {
        return UIColor(red: 46/255, green: 64/255, blue: 87/255, alpha: 1.0)
    }
    // Muted blue (124, 152, 179)
    @nonobjc class var secondary: UIColor {
        return UIColor(red: 124/255, green: 152/255, blue: 179/255, alpha: 1.0)
    }
    // Bright blue (72, 172, 240)
    @nonobjc class var accent: UIColor {
        return UIColor(red: 72/255, green: 172/255, blue: 240/255, alpha: 1.0)
    }
    // Light gray-blue (246, 247, 249)
    @nonobjc class var background: UIColor {
        return UIColor(red: 246/255, green: 247/255, blue: 249/255, alpha: 1.0)
    }
    // Deep blue-gray (46, 64, 87)
    @nonobjc class var textPrimary: UIColor {
        return UIColor(red: 46/255, green: 64/255, blue: 87/255, alpha: 1.0)
    }
    // Muted blue (124, 152, 179)
    @nonobjc class var textSecondary: UIColor {
        return UIColor(red: 124/255, green: 152/255, blue: 179/255, alpha: 1.0)
    }
    @nonobjc class var midGradient: UIColor {
        return UIColor(red: 185/255, green: 200/255, blue: 214/255, alpha: 1.0)
    }
}
