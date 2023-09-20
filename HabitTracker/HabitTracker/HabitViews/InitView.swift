//
//  InitView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/6.
//

import SwiftUI

struct InitView: View {
    var body: some View {
        VStack {
            DateSwipeBar()//.id(UUID())
            TaskListView(viewModel: HabitTrackerViewModel.shared)
        }
    }
}

struct InitView_Previews: PreviewProvider {
    static var previews: some View {
        InitView()
    }
}
