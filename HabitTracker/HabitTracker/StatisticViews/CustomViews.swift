//
//  CustomViews.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/11.
//

import SwiftUI

struct StatisticalCustomSegmentedControl: View {
    @State var preselectedIndex: Int = 0
    var options: [String]
    let color = Color.gray.opacity(0.4)
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.2))
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.4)) {
                                if (preselectedIndex == index) {
                                    return
                                }
                                preselectedIndex = index
                                var type: HabitStatisticShowType = .weekly
                                if preselectedIndex == 1 {
                                    type = .monthly
                                }
                                else if preselectedIndex == 2 {
                                    type = .annually
                                }
                                HabitTrackerStatisticViewModel.shared.digestChartCycle = type
                                HabitTrackerStatisticViewModel.shared.markDate = Date()
                                Task.detached(priority: .userInitiated) {
                                    await StatDigestImgCache.shared.invalidateAllCache()
                                    await MainActor.run {
                                        HabitTrackerStatisticViewModel.shared.objectWillChange.send()
                                    }
                                }
                            }
                        }
                    Rectangle()
                        .fill(backgroundGradientStart.opacity(index == preselectedIndex ? 0.4 : 0.0))
                        .overlay(
                            Text(options[index]).foregroundColor(.primary.opacity(index == preselectedIndex ? 0.7 : 0.2))
                        )
                }
            }
        }
        .foregroundColor(.primary.opacity(0.4))
        .fontWeight(.medium)
        .frame(height: 40)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct CustomViews_Previews: PreviewProvider {
    
    static var previews: some View {
        RootView(viewModel: HabitTrackerViewModel.shared)
    }
}
