//
//  GoalMesurementSectionViews.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/8/1.
//

import SwiftUI

struct GoalMesurementSectionView: View {
    @StateObject var viewModel: GoalCreationViewModel
    var body: some View {
        VStack {
            HStack(spacing: 12) {
                inputFieldPrototype(title: "Initial Value", text: $viewModel.startValueString)
                inputFieldPrototype(title: "Target Value", text: $viewModel.targetValueString)
            }
            
            inputFieldPrototype(title: "Unit", text: $viewModel.unit)//.frame(maxWidth: 120)
                
            HStack {
                inputFieldPrototype(title: "Plus or Minus Value", text: $viewModel.goalName)
                Image(systemName: "questionmark.circle")
            }
            
            
        }
    }
}

#Preview {
    GoalCreationView()
}
