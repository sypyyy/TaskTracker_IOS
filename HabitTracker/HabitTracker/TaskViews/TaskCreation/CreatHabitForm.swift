//
//  TaskCreatForm.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/31.
//

import SwiftUI

struct CreatHabitForm: View {
    @StateObject var viewModel : HabitViewModel
    let masterViewModel = TaskMasterViewModel.shared
    @State var name: String = ""
    @State var detail: String = ""
    @State var habitType: String = "Checkbox"
    @State var cycle: String = "Daily"
    @Binding var targetNumber: Int
    @State var targetUnit: String = ""
    @Binding var targetHour: Int
    @Binding var targetMinute: Int
    @State var setTarget: Bool = true
    @Binding var indicatorColor: Color
    @Binding var showNumberPicker: Bool
    @Binding var showTimePicker: Bool
    @Binding var showAlert: Bool
    var body: some View {
        
        VStack{
        
            
            VStack {
                
                VStack{
                    leadingLongTitle(title: "Habit name")
                    inputField(title: "eg: Drink water.", text: $name).padding(.bottom)
                    leadingLongTitle(title: "Note")
                    inputField(title: "", text: $detail)
                        .padding(.bottom)
                    
                    CustomDivider()
                    
                    leadingLongTitle(title: "Track habit by")
                    let habitTypeButtonWidth: CGFloat = 90
                    let habitCycleButtonWidth: CGFloat = 90
                    HStack{
                        Button3D(title: "Checkbox", image: "checkmark.square", activeTitle: $habitType, tag: "Checkbox").frame(width: habitTypeButtonWidth)
                        Button3D(title: "Time", image: "alarm", activeTitle: $habitType, tag: "Time").frame(width: habitTypeButtonWidth)
                        Button3D(title: "Number", image: "123.rectangle", activeTitle: $habitType, tag: "Number").frame(width: habitTypeButtonWidth)
                        Spacer()
                    }.padding(.bottom)
                        .padding(.leading)
            
                    CustomDivider()
                    leadingLongTitle(title: "Cycle")
                    HStack{
                        Button3D(title: "Daily",image: "", activeTitle: $cycle, tag: "Daily").frame(width: habitCycleButtonWidth)
                        Button3D(title: "Weekly", image: "", activeTitle: $cycle, tag: "Weekly").frame(width: habitCycleButtonWidth)
                        Button3D(title: "Monthly", image: "", activeTitle: $cycle, tag: "Monthly").frame(width: habitCycleButtonWidth)
                        Spacer()
                    }.padding(.bottom)
                        .padding(.leading)
                }
                if habitType != "Checkbox" {
                    CustomDivider()
                    VStack{
                        HStack{
                            leadingTitle(title: "Set a target")
                            /*
                             Toggle("", isOn: $setTarget)
                             .toggleStyle(.switch).frame(maxWidth: 60).tint(indicatorColor).scaleEffect(0.8)
                             */
                            Spacer()
                        }
                        if setTarget {
                            HStack{
                                if(habitType == "Number") {
                                    
                                    Button("\(targetNumber)", action: {showNumberPicker = true}).buttonHorizontal().padding(.leading)
                                    inputFieldPrototype(title: "Unit", text: $targetUnit).frame(maxWidth: 100).autocapitalization(.none)
                                }
                                else {
                                    Button("\((targetHour * 60 + targetMinute).minutesToTime())", action: {showTimePicker = true}).buttonHorizontal().padding(.leading)
                                    /*
                                     
                                     */
                                    
                                }
                                switch(cycle) {
                                case "Daily": Text("/ day")
                                case "Weekly": Text("/ week")
                                case "Monthly": Text("/ month")
                                default: Text("day")
                                }
                                Spacer()
                            }
                        }
                        //Spacer()
                    }
                }
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
                let targetTime = (targetHour * 60 + targetMinute).minutesToTime()
                let habitModel = HabitModel(name: name, id: "", createdDate: Date(), type: HabitTracker.HabitType(rawValue: habitType) ?? .simple, numberTarget: Int16(targetNumber), timeTarget: targetTime,  detail: detail, cycle: HabitCycle(rawValue: cycle) ?? .daily, unit: targetUnit, priority: 0, project: "", executionTime: "")
                viewModel.saveHabit(habitModel: habitModel)
                masterViewModel.didReceiveChangeMessage(msg: .taskCreated)
            }
            .padding(.bottom, 30)
        }
    }
}

struct CreateHabitForm_Previews: PreviewProvider {
    static var previews: some View {
        CreatTaskForm(viewModel: HabitViewModel.shared, taskType: .habit)
    }
}
