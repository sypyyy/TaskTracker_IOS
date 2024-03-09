//
//  ViewExtensions.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/16.
//

import Foundation
import SwiftUI

extension View {
    func glow(color: Color = .orange, radius: CGFloat = 20) -> some View {
        self
            .shadow(color: color, radius: radius)
            //.shadow(color: color, radius: radius / 3)
            //.shadow(color: color, radius: radius / 3)
    }
    func innerShadow<S: Shape>(using shape: S, angle: Angle = .degrees(45), color: Color = .black, width: CGFloat = 3, blur: CGFloat = 1) -> some View {
        let finalX = CGFloat(cos(angle.radians - .pi / 2))
        let finalY = CGFloat(sin(angle.radians - .pi / 2))
        return self
            .overlay(
                shape
                    .stroke(color, lineWidth: width)
                    .offset(x: finalX * width * 0.6, y: finalY * width * 0.6)
                    .blur(radius: blur)
                    .mask(shape)
            )
    }
}

extension UIView {
    func addMaterialBackground(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurEffectView, at: 0)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
/*
extension UIColor {
    /**
     Create a ligher color
     */
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }
    
    /**
     Create a darker color
     */
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }
    
    /**
     Try to increase brightness or decrease saturation
     */

     func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
     var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
     if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
     if b < 1.0 {
     /**
      Below is the new part, which makes the code work with black as well as colors
      */
     let newB: CGFloat
     if b == 0.0 {
     newB = max(min(b + percentage/100, 1.0), 0.0)
     } else {
     newB = max(min(b + (percentage/100.0)*b, 1.0), 0,0)
     }
     return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
     } else {
     let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
     return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
     }
     }
     return self
     }
     }
     */



extension Button {
    func buttonHorizontal() -> some View {
        return self.padding()
            //.background(Color(UIColor(gradientStart1).darker(by: 0)))
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .shadow(color: Color("Shadow").opacity(0.3), radius: 2, x: 0, y: 0)
            .padding(.horizontal, 4.0)
            
    }
}
/*
extension HStack {
    func buttonHorizontal() -> some View {
        return self.padding()
            .background(Color(UIColor(gradientStart1).darker(by: 0)))
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .shadow(color: Color("Shadow").opacity(0.3), radius: 2, x: 0, y: 0)
            .padding(.horizontal, 4.0)
    }
}
*/

enum ButtonColor {
    case main, gray
}

struct CommonButtonProto<Content: View>: View {
    var content: () -> Content
    var body: some View {
        content()
    }
}

//常用按钮， main为主题颜色，gray为模糊白色
extension View {
    func buttonHorizontal(color: ButtonColor = .main) -> some View {
        var bgColor: Color
        var bgMaterial: Material
        switch color {
        case .main:
            bgColor = backgroundGradientStart
            bgMaterial = .ultraThinMaterial
        case .gray:
            bgColor = .clear
            bgMaterial = .thickMaterial
        }
        return self.padding()
                .background(bgColor)
                .background(bgMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 33, style: .continuous))
                .shadow(color: Color("Shadow").opacity(0.3), radius: 2, x: 0, y: 0)
                .padding(.horizontal, 4.0)
    }
}

extension View {
    func smallerButtonHorizontal() -> some View {
        return self//.padding(.horizontal, 4.0)
            .background(Color(UIColor(backgroundGradientStart).darker(by: 0)))
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .shadow(color: Color("Shadow").opacity(0.3), radius: 2, x: 0, y: 0)
            .padding(.horizontal, 4.0)
    }
}



