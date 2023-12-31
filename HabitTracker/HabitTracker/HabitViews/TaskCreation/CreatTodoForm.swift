//
//  CreatTodoForm.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/31.
//

import SwiftUI


struct CreatTodoForm: View {
    @StateObject var viewModel : HabitViewModel
    @State var name: String = ""
    @State var detail: String = ""
    @State var habitType: String = "Checkbox"
    @State var cycle: String = "Daily"
    @State var targetNumber: Int = 0
    @State var targetUnit: String = ""
    @State var targetHour: Int = 0
    @State var targetMinute: Int = 0
    @State var setTarget: Bool = true
    @State var indicatorColor: Color = .pink
    @State var showNumberPicker: Bool = false
    @State var showTimePicker: Bool = false
    @State var showAlert: Bool = false
    @State var scheduleDate: Date = Date()
    var body: some View {
        VStack{
            VStack {
                VStack{
                    leadingLongTitle(title: "To-do")
                    inputField(title: "", text: $name).padding(.bottom)
                    leadingLongTitle(title: "Note")
                    inputField(title: "", text: $detail)
                        .padding(.bottom)
                    HStack(spacing: 0){
                        leadingTitle(title: "Date")
                         Toggle("", isOn: $setTarget)
                            .toggleStyle(.switch).frame(maxWidth: 50).tint(backgroundGradientStart).scaleEffect(0.8)
                        DatePicker(
                                 
                            selection: $scheduleDate,displayedComponents: [.date], label: {
                                
                            }
                        )
                        .contentShape(Rectangle())
                        .datePickerStyle(.compact).padding(.trailing, 6)
                        Spacer()
                        
                    }
                    
                    
                }
                if habitType != "Checkbox" {
                    VStack{
                        HStack{
                            leadingTitle(title: "Set a target")
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


struct CreateTodoForm_Previews: PreviewProvider {
    static var previews: some View {
        CreatTaskForm(viewModel: HabitViewModel.shared)
    }
}
