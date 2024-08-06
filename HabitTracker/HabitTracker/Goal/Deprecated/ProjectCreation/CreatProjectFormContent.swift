//
//  CreatProjectFormContent.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/5.
//

import SwiftUI

@MainActor
struct CreatProjectFormContent: View {
    let persistenceModel = PersistenceController.preview
    var masterViewModel = MasterViewModel.shared
    @State var name: String = ""
    @State var detail: String = ""
    //Time
    @State var hasScheduleTime = false
    @State var scheduleTime: Date = Date()
    //Reminder
    @State var hasReminder = false
    @State var reminderTime = Date()
    //Priority
    @State var priority = 0
    
    //need refactor
    @State var showNumberPicker: Bool = false
    @State var showTimePicker: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack{
            VStack {
                VStack{
                    leadingLongTitle(title: "Project")
                    inputField(title: "", text: $name).padding(.bottom)
                }
                .padding(.bottom, 24)
                //CustomDivider().padding(.vertical, 12)
                
                //CustomDivider()
            
                
                
                
                //CustomDivider(isSecondary: true)
                
                //titleWithToggle(title: "Expiration Date", isOn: $willExpire)
            
                
                //CustomDivider().padding(.vertical, 12)
                
                leadingLongTitle(title: "Color")//.padding(.top, 24)
                
                
                leadingLongTitle(title: "Icon").padding(.top, 24)
                
                
                
                if hasReminder {
                    customDatePicker(date: $reminderTime, isHourAndMin: true)
                }
                
                //CustomDivider()
                HStack {
                    leadingTitle(title: "Priority")
                    Spacer()
                    let opacity = 0.2
                    let scaleRatio = 1.2
                    CustomSegmentedControl(optionLabels: [
                        {selected in
                            Image(systemName: "flag.fill").foregroundColor(.red).scaleEffect(selected ? scaleRatio : 1)
                        }, {selected in
                            Image(systemName: "flag.fill").foregroundColor(.yellow)
                                .scaleEffect(selected ? scaleRatio : 1)
                        }, {selected in
                            Image(systemName: "flag.fill").foregroundColor(.green)
                                .scaleEffect(selected ? scaleRatio : 1)
                        }, {selected in
                            Image(systemName: "flag.slash.fill").foregroundColor(.gray)
                                .scaleEffect(selected ? scaleRatio : 1)
                        }
                    ], slidingBlockColors: [.red.opacity(opacity), .yellow.opacity(opacity), .green.opacity(opacity),
                        .gray.opacity(opacity),]) { selected in
                            //high: 1, medium: 2, low: 3, none: 0
                        priority = (selected + 1) % 3
                        }.frame(width: 200)
                }.padding(.top, 24)
                    .padding(.trailing)
            }.padding(.bottom, 30)
                
            HStack{
                Spacer()
                Text("Save")
                Spacer()
            }
            .buttonHorizontal()
            .onTapGesture {
                print("tapped")
                if name == "" {
                    showAlert = true
                    return
                }
                let project = constructProjectModel()
                persistenceModel.createGoal(dataModel: project)
                //masterViewModel.didReceiveChangeMessage(msg: .taskCreated)
            }
            .padding(.bottom, 30)
        }
        .animation(.default, value: hasScheduleTime)
        .animation(.default, value: hasReminder)
    }
    
    private func constructProjectModel() -> GoalModel {
        let res = GoalModel(goal: Goal())
        return res
    }
}

struct CreatProjectFormContent_Previews: PreviewProvider {
    static var previews: some View {
        CreatProjectForm(viewModel: HabitViewModel.shared)
    }
}
