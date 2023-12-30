//
//  InitView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/6.
//

import SwiftUI

struct InitView: View {
    @State var shown = false
    var body: some View {
        VStack {
            DateSwipeBar().offset(x: 0, y: shown ? 0 : 20)
                .opacity(shown ? 1.0 : 0.3)
            TaskListView(masterViewModel: TaskMasterViewModel.shared).offset(x: 0, y: shown ? 0 : 50)
                .opacity(shown ? 1.0 : 0.3)
        }.onAppear {
            shown = true
        }
        .animation(.default, value: shown)
    }
}

struct InitView_Previews: PreviewProvider {
    static var previews: some View {
        InitView()
    }
}
