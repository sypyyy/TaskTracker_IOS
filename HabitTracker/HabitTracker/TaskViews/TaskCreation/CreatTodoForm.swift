//
//  CreatTodoForm.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/31.
//

import SwiftUI


struct CreatTodoForm: View {
    let persistenceModel = PersistenceController.shared
    var masterViewModel = TaskMasterViewModel.shared
    @State var name: String = ""
    @State var detail: String = ""
    //Schedule
    @State var hasStartDate = true
    @State var startDate: Date = Date()
    //Expire
    @State var willExpire = false
    @State var expirationDate: Date = Date()
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
                    leadingLongTitle(title: "To-do")
                    inputField(title: "", text: $name).padding(.bottom)
                    leadingLongTitle(title: "Note")
                    inputField(title: "", text: $detail)
                }
                .padding(.bottom, 24)
                //CustomDivider().padding(.vertical, 12)
                
                //CustomDivider()
                leadingLongTitle(title: "Start Date")
                
                if hasStartDate {
                    customDatePicker(date: $startDate, isHourAndMin: false)
                }
                
                //CustomDivider(isSecondary: true)
                
                titleWithToggle(title: "Expiration Date", isOn: $willExpire)
                if willExpire {
                    customDatePicker(date: $expirationDate, isHourAndMin: false)
                }
                
                //CustomDivider().padding(.vertical, 12)
                
                titleWithToggle(title: "Time", isOn: $hasScheduleTime).padding(.top, 24)
                if hasScheduleTime {
                    customDatePicker(date: $scheduleTime, isHourAndMin: true)
                }
                
                titleWithToggle(title: "Remind me", isOn: $hasReminder)
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
                let todo = constructTodoModel()
                persistenceModel.createTodo(dataModel: constructTodoModel())
                masterViewModel.didReceiveChangeMessage(msg: .taskCreated)
            }
            .padding(.bottom, 30)
        }
        .animation(.default, value: willExpire)
        .animation(.default, value: hasScheduleTime)
        .animation(.default, value: hasReminder)
    }
    
    private func constructTodoModel() -> TodoModel {
        let todo = TodoModel()
        todo.name = name
        todo.note = detail
        todo.priority = priority
        todo.startDate = Date.combineDates(date: startDate, time: scheduleTime)
        todo.isTimeSpecific = hasScheduleTime
        todo.hasReminder = hasReminder
        todo.reminderDate = reminderTime
        
        todo.willExpire = willExpire
        todo.expireDate = expirationDate
        
        todo.parentTaskId = ""
        todo.subTasks = []
        todo.subTaskString = ""
        todo.done = false
        return todo
    }
}


struct CreateTodoForm_Previews: PreviewProvider {
    static var previews: some View {
        CreatTaskForm(viewModel: HabitViewModel.shared)
    }
}
