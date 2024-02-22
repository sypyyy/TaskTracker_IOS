//
//  InitView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/6.
//

import SwiftUI

struct InitView: View {
    @State var shown = true
    var body: some View {
        VStack(spacing: 0) {
            DateSwipeBar().offset(x: 0, y: shown ? 0 : 20)
                .opacity(shown ? 1.0 : 0.3)
            TaskListView().offset(x: 0, y: shown ? 0 : 50)
                .opacity(shown ? 1.0 : 0.3)
            Spacer().frame(height: TAB_BAR_HEIGHT)
        }.onAppear {   
            //For now let's don't use this animation
            //shown = true
        }
        .ignoresSafeArea(edges: .bottom)
        .animation(.default, value: shown)
    }
}

struct InitView_Previews: PreviewProvider {
    static var previews: some View {
        InitView()
    }
}
