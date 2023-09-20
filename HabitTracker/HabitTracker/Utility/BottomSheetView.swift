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
        //.ignoresSafeArea(edges: .bottom)
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(content:{
            VStack{
                DumView()
            }
        })
    }
}


struct DumView: View {
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


