//
//  ColorUtils.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/7/12.
//

import Foundation
import UIKit
import SwiftUI


//let backgroundGradientStart = Color(red: 242.0 / 255, green: 173.0 / 255, blue: 182.0 / 255)
//let backgroundGradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
/*
 orange
 let backgroundGradientStart = Color(hex: 0xFFBA93)
 let backgroundGradientEnd =  Color(hex: 0xFFC75F)
 
 blue
 let backgroundGradientStart = Color(hex: 0x4568dc).lighter(by: 30)
 let backgroundGradientEnd = Color(hex: 0x4568dc).lighter(by: 30)
 
 blue
 let backgroundGradientStart = Color(hex: 0xC0DEFF)
 let backgroundGradientEnd =  Color(hex: 0xB8E8FC)
 
 pink
 let backgroundGradientStart = Color(hex: 0xba5370).lighter(by: 25)
 let backgroundGradientEnd = Color(hex: 0xf4e2d8)
 
 //let backgroundGradientStart = Color(hex: 0xba5370).lighter(by: 30)
 //let backgroundGradientEnd = Color(hex: 0xf4e2d8)
 
 purple pink
 let backgroundGradientStart = Color(hex: 0xddd6f3)
 let backgroundGradientEnd = Color(hex: 0xfaaca8)
 
 purple blue
 let backgroundGradientStart = Color(hex: 0xddd6f3)
 let backgroundGradientEnd = Color(hex: 0xC0DEFF)
 
 purple orange
 let backgroundGradientStart = Color(hex: 0xddd6f3)
 let backgroundGradientEnd = Color(hex: 0xFFBA93)
 
 */

/*
 dark:
 
 let backgroundGradientStart = Color(hex: 0x4568dc)
 let backgroundGradientEnd = Color(hex: 0x4568dc)
 
 let backgroundGradientStart = Color(hex: 0x2193b0)
 let backgroundGradientEnd = Color(hex: 0x6dd5ed)
 */

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return UIColor()
        }
    }
}

extension Color {
    func lighter(by percentage: CGFloat = 30.0) -> Color {
        return Color(UIColor(self).lighter(by: percentage))
    }
    
    func darker(by percentage: CGFloat = 30.0) -> Color {
        return Color(UIColor(self).darker(by: percentage))
    }
}


extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
