//
//  AlertWrapperView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/7/20.
//

import SwiftUI

import SwiftUI



struct AlertWrapperView<V: View>: View {
    @Binding var show: Bool
    @ViewBuilder var content: V
    
    var body: some View {
        VStack{
            if show {
                AlertView {
                    content
                }
            }
        }
        .animation(.easeIn(duration: show ? 0 : 0.7), value: show)
        if(disappear()) {}
    }
    
    func disappear() -> Bool {
        if show {
            
            DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(1500))) {
                show = false
            }
        }
        return false
    }
}


struct AlertView<V: View>: View {
    @State var shrinked = true
    @ViewBuilder var content: V
    var body: some View {
        VStack {
            content
        }.frame(width: 200)
            .padding()
            .background(.regularMaterial)
            .cornerRadius(15.0, corners: .allCorners)
            .scaleEffect(!shrinked ? 1 : 0.3)
            //.animation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.4), value: shrinked)
            .animation(.easeOut(duration: 0.1), value: shrinked)
        if(disappear()) {}
    }
    func disappear() -> Bool {
        if shrinked {
            DispatchQueue.main.async {
                shrinked = false
            }
        }
        return false
    }
}


extension AlertWrapperView: Equatable {
    static func == (lhs: AlertWrapperView<V>, rhs: AlertWrapperView<V>) -> Bool {
        return false
    }
}

struct AlertWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(content:{
            VStack{
                Dum1View()
            }
        })
    }
}


struct Dum1View: View {
    var body: some View {
        GeometryReader{ metric in
            ScrollView {
                Text("dummy").border(.red)
            }.border(.red)
            
               
        } .border(.red)
        
    }
    
    func contextMenu<MenuItems: View>(
    @ViewBuilder menuItems: () -> MenuItems
    ) -> some View {
        return menuItems()
    }
}


