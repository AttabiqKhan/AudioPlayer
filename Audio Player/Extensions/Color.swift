//
//  Color.swift
//  Audio Player
//
//  Created by Attabiq Khan on 21/10/2024.
//

import Foundation
import UIKit

extension UIColor {
    
    // Slightly dim white for subtle text or icons (255, 255, 255, 0.5)
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
    // Deep Black - Background (0, 0, 0)
    @nonobjc class var backgroundDark: UIColor {
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
    }
    
    // Charcoal Gray - Primary Background (18, 18, 18)
    @nonobjc class var backgroundPrimary: UIColor {
        return UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    }
    
    // Neon Green - Accent color (30, 215, 96) for highlights
    @nonobjc class var accentNeonGreen: UIColor {
        return UIColor(red: 30/255, green: 215/255, blue: 96/255, alpha: 1.0)
    }
    
    // Vibrant Teal - Gradient Start (0, 210, 255)
    @nonobjc class var gradientStart: UIColor {
        return UIColor(red: 0/255, green: 210/255, blue: 255/255, alpha: 1.0)
    }
    
    // Soft Purple - Gradient End (108, 92, 231)
    @nonobjc class var gradientEnd: UIColor {
        return UIColor(red: 108/255, green: 92/255, blue: 231/255, alpha: 1.0)
    }
    
    // Muted Gray - Secondary Text (144, 164, 174)
    @nonobjc class var textSecondaryGray: UIColor {
        return UIColor(red: 144/255, green: 164/255, blue: 174/255, alpha: 1.0)
    }
    
    // Off-White - Primary Text Color (238, 238, 238)
    @nonobjc class var textPrimaryOffWhite: UIColor {
        return UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
    }
    
    // Deep Blue-Green - Button Color (26, 26, 51)
    @nonobjc class var buttonColor: UIColor {
        return UIColor(red: 26/255, green: 26/255, blue: 51/255, alpha: 1.0)
    }
}
