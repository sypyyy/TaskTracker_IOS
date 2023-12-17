//
//  ViewModifiers.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/16.
//

import SwiftUI

//iOS Version conflicts

struct OnChangeCustom<V: Equatable>: ViewModifier {
    let of: V
    let action: () -> Void

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.onChange(of: of, action)
        } else {
            // Fallback on earlier versions
            content.onChange(of: of, perform: { value in
                action()
            })
        }
    }
}

extension View {
    func onChangeCustom<V: Equatable>(of: V, _ action: @escaping () -> Void) -> some View {
        self.modifier(OnChangeCustom(of: of, action: action))
    }
}

// Set position in GLOBAL

struct GlobalPosition: ViewModifier {

    var point: CGPoint
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .position(x: proxy.size.width / 2 + (point.x - proxy.frame(in: CoordinateSpace.global).midX),
                          y: proxy.size.height / 2 + (point.y - proxy.frame(in: CoordinateSpace.global).midY))
        }
    }
}

extension View {
    func globalPosition (_ point: CGPoint) -> some View {
        self.modifier(GlobalPosition(point: point))
    }
}
