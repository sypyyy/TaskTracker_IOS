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


//add a material background with a silver lining on top

struct SilverLiningBackground: ViewModifier {
    static let cornerRadius = CGFloat(15)
    let material: Material

    func body(content: Content) -> some View {
        content
            .background(
                Color.clear.background(material).environment(\.colorScheme, .light))
            
            .clipShape(RoundedRectangle(cornerRadius: SilverLiningBackground.cornerRadius))
            //.shadow(color: Color("Shadow"), radius: 2, x: 0, y: 1)
            .overlay(
                RoundedRectangle(cornerRadius: SilverLiningBackground.cornerRadius).stroke(.white.opacity(0.6), lineWidth: 2).offset(y :0.5).blur(radius: 0).mask(RoundedRectangle(cornerRadius: SilverLiningBackground.cornerRadius))
            )
    }
}

extension View {
    func silverliningBackground(material: Material) -> some View {
        self.modifier(SilverLiningBackground(material: material))
    }
}


//add a background with for a message popup

struct MessageBackground: ViewModifier {
    static let cornerRadius = CGFloat(15)
    let messageType: MessageType
    
    var color: Color {
        switch messageType {
        case .error:
            return Color.red.lighter(by: 20).opacity(0.5)
        case .warning:
            return Color.yellow.lighter(by: 20).opacity(0.5)
        case .info:
            return Color.gray.lighter(by: 30).opacity(0.5)
        case .success:
            return Color.blue.lighter(by: 20).opacity(0.5)
        }
    }

    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                Color.clear.background(color)
            
            .clipShape(RoundedRectangle(cornerRadius: MessageBackground.cornerRadius))
            .border(Color.white.opacity(0.6), width: 2)
            //.shadow(color: Color("Shadow"), radius: 2, x: 0, y: 1)
                /*
            .overlay(
                RoundedRectangle(cornerRadius: MessageBackground.cornerRadius).stroke(.white.opacity(0.6), lineWidth: 2).mask(RoundedRectangle(cornerRadius: MessageBackground.cornerRadius))
            )
                 */
            )
    }
}

enum MessageType {
    case error
    case warning
    case info
    case success
}

extension View {
    func messageBackground(messageType: MessageType = .info) -> some View {
        self.modifier(MessageBackground(messageType: messageType))
    }
}


struct NavBarSystemImageButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color.primary.lighter(by: 42))
            .frame(width: 34)
            .frame(height: 34)
            .font(.system(size: 16, weight: .heavy, design: .rounded))
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

    }
}

extension View {
    func navBarSystemImageButtonModifier() -> some View {
        self.modifier(NavBarSystemImageButtonModifier())
    }
}


