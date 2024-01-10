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
    @State var hasScheduleDate = false
    @State var scheduleDate: Date = Date()
    @State var hasScheduleTime = false
    @State var scheduleTime: Date = Date()
    
    //need refactor
    @State var showNumberPicker: Bool = false
    @State var showTimePicker: Bool = false
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack{
            VStack {
                VStack{
                    leadingLongTitle(title: "To-do")
                    inputField(title: "", text: $name).padding(.bottom)
                    leadingLongTitle(title: "Note")
                    inputField(title: "", text: $detail)
                }
                .padding(.bottom, 24)
                //CustomDivider().padding(.vertical, 12)
                
                //CustomDivider()
                titleWithToggle(title: "Date", isOn: $hasScheduleDate)
                
                if hasScheduleDate {
                    customDatePicker(date: $scheduleDate, isHourAndMin: false)
                }
                
                //CustomDivider(isSecondary: true)
                
                titleWithToggle(title: "Time", isOn: $hasScheduleTime)
                if hasScheduleTime {
                    customDatePicker(date: $scheduleTime, isHourAndMin: true)
                }
                //CustomDivider().padding(.vertical, 12)
                
                titleWithToggle(title: "Expiration Date", isOn: $hasScheduleTime).padding(.top, 24)
                if hasScheduleTime {
                    customDatePicker(date: $scheduleTime, isHourAndMin: true)
                }
                
                //CustomDivider()
                
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
                
                
            }
            .padding(.bottom, 30)
        }
        .animation(.default, value: hasScheduleDate)
        .animation(.default, value: hasScheduleTime)
    }
}


struct CreateTodoForm_Previews: PreviewProvider {
    static var previews: some View {
        CreatTaskForm(viewModel: HabitViewModel.shared)
    }
}
