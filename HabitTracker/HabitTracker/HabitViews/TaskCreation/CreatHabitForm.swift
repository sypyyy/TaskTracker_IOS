//
//  TaskCreatForm.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/31.
//

import SwiftUI

struct CreatHabitForm: View {
    @StateObject var viewModel : HabitViewModel
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
                    leadingLongTitle(title: "Track habit by")
                    
                    HStack{
                        Button3D(title: "Checkbox", image: "checkmark.square", activeTitle: $habitType).padding(.leading)
                        Button3D(title: "Time", image: "alarm", activeTitle: $habitType)
                        Button3D(title: "Number", image: "123.rectangle", activeTitle: $habitType)
                        Spacer()
                    }.padding(.bottom)
                    leadingLongTitle(title: "Cycle")
                    HStack{
                        Button3D(title: "Daily",image: "", activeTitle: $cycle).padding(.leading)
                        Button3D(title: "Weekly", image: "", activeTitle: $cycle)
                        Button3D(title: "Monthly", image: "", activeTitle: $cycle)
                        Spacer()
                    }.padding(.bottom)
                }
                if habitType != "Checkbox" {
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
                viewModel.saveHabit(name: name, detail: detail, habitType: HabitTracker.HabitType(rawValue: habitType) ?? .simple, cycle: cycle, targetNumber: targetNumber, targetUnit: targetUnit, targetHour: targetHour, targetMinute: targetMinute, setTarget: setTarget)
            }
            .padding(.bottom, 30)
        }
    }
}
