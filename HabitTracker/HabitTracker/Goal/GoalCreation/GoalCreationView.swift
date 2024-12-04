//
//  GoalCreationView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/7/22.
//

// 

import SwiftUI

struct GoalCreationView: View {
    @StateObject var viewModel = GoalCreationViewModel()
    var body: some View {
        ZStack{
            GradientBackgroundInForm()
            ScrollView {
                LazyVStack {
                    
                    FormSection {
                        HeaderRegular{
                            Text("Goal")
                        }
                        inputFieldPrototype(title: "", text: $viewModel.goalName)
                            //.shadow(color: Color.black.opacity(12), radius: 2, x: 0, y: 2) // Adjust these values
                    }
                    
                    FormSection {
                        GoalStartAndEndSectionView(viewModel: viewModel)
                    }
                    
                    FormSection {
                        HeaderWithToggle(header: {
                            Text("Measurement")
                        }, isOn: $viewModel.hasMeasurement)
                        if(viewModel.hasMeasurement) {
                            GoalMesurementSectionView(viewModel: viewModel)
                        }
                    }
                    
                    FormSection {
                        
                        ParentGoalChooseSectionView(viewModel: viewModel)
                    }
                }.onChangeCustom(of: viewModel.hasMeasurement) {
                    if viewModel.hasMeasurement {
                        withAnimation {
                            viewModel.isPresentingInlineIntervalPicker = false
                        }
                        
                    }
                }
            }.padding(.top, 60)
            VStack {
                GoalCreationNavView(viewModel: viewModel).frame(height: 60).background(.regularMaterial)
                Spacer()
            }
        }
    }
}

struct GoalCreationNavView: View {
    @State var disableInteractions = false
    @StateObject var viewModel: GoalCreationViewModel
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                disableInteractions = true
                viewModel.commitSave()
            }) {
                
                Text("Save")
                    .font(.headline)
                //.foregroundColor(.white)
                //Spacer()
                
            }
            .disabled(disableInteractions)
        }.padding(.horizontal)
    }
}

#Preview {
    GoalCreationView()
}
