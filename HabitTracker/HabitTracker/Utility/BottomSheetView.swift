//
//  BottomSheetView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/13.
//

import SwiftUI

struct BottomSheetView<V: View>: View {
    @ViewBuilder var content: V
    var body: some View {
        VStack{
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Background"))
        .ignoresSafeArea(edges: .bottom)
    }
    
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView{
            VStack{
                DumView().contextMenu{
                    Text("sssnnsn")
                    Text("sssghhgh")
                }
            }
        }
    }
}


struct DumView: View {
    var body: some View {
        Text("dummy")
    }
    
    func contextMenu<MenuItems: View>(
    @ViewBuilder menuItems: () -> MenuItems
    ) -> some View {
        return menuItems()
    }
}


