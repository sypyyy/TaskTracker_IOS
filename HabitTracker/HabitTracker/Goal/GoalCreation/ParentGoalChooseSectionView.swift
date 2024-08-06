//
//  ParentGoalChooseSectionView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/8/1.
//

import SwiftUI

struct ParentGoalChooseSectionView: View {
    @StateObject var viewModel: GoalCreationViewModel
    var body: some View {
        HeaderRegular(header: {
            HStack {
                Text("Parent Goal")
                Spacer()
                Button {
                    viewModel.isPresentingParentGoalPicker = true
                } label: {
                    HStack(spacing: 2){
                        Text("\(viewModel.parentGoal?.name ?? "None")")
                        Image(systemName: "chevron.right")
                    }.foregroundColor(.secondary.lighter(by: 14))
                }
            }
        })
        .sheet(isPresented: $viewModel.isPresentingParentGoalPicker, content: {
            TaskGoalPickingSheetView(preselectedGoal: nil, mode: .callBack({ goal in
                /*
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    viewModel.isPresentingParentGoalPicker = false
                }
                 */
                viewModel.parentGoal = goal
            }))
        })
    }
}

#Preview {
    GoalCreationView()
}
