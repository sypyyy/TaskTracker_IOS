//
//  DateAndTimeSelectionView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/5/31.
//

import SwiftUI

enum TaskTimeType {
    case timePoint, timeSpans
}

enum TaskDateType {
    case singleDay, multipleDays
}

struct DateAndTimeSelectionView: View {
    let persistenceModel = PersistenceController.shared
    var masterViewModel = TaskMasterViewModel.shared
    @State var name: String = ""
    @State var detail: String = ""
    //Date
    @State var hasDate = true
    @State var date: Date = Date()
    @State var showExpandedDatePicker = true
    //Multiple days
    @State var activeDateType = TaskDateType.singleDay
    @State var startDate: Date = Date()
    @State var expirationDate: Date = Date()
    //Time
    @State var activeTimeType = TaskTimeType.timePoint
    
    @State var timeOn = false
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
        ZStack {
            Color.white
            LinearGradient(colors: [backgroundGradientStart, backgroundGradientEnd], startPoint: .top, endPoint: .bottom)
                .opacity(0.3)
                .ignoresSafeArea()
            ScrollView{
                VStack {
                    FormSection {
                        titleWithToggle(title: "Date", isOn: $hasDate)
                        if hasDate {
                            CustomSegmentedControl(preselectedIndex: activeDateType == .multipleDays ? 1 : 0, optionLabels: [
                                {selected in
                                    HStack {
                                        Text("Single Day")
                                    }
                                },
                                {selected in
                                    HStack {
                                        
                                        Text("Multiple Days")
                                    }
                                },
                            ], onSelect: {idx in
                                withAnimation {
                                    if idx == 0 {
                                        activeDateType = .singleDay
                                    } else {
                                        activeDateType = .multipleDays
                                    }
                                }
                                
                            })
                            
                            Group {
                                if activeDateType == .singleDay {
                                    
                                    
                                    if showExpandedDatePicker {
                                        
                                        HStack {
                                            Image(systemName: "calendar")
                                            Spacer()
                                            Button(action: {
                                                showExpandedDatePicker = false
                                            }, label: {
                                                Text(fmt_date_select_localized.string(from: date))
                                            })
                                            
                                        }
                                        .padding(.vertical, 8)
                                        
                                        //.padding(.leading, 12)
                                        CustomDivider()
                                        DatePicker(
                                            selection: $date,displayedComponents: [.date], label: {
                                                
                                            }
                                        )
                                        
                                        //.contentShape(Rectangle())
                                        .datePickerStyle(.graphical)
                                        .transition(.asymmetric(insertion: .opacity, removal: .identity))
                                    } else {
                                        DatePicker(
                                            selection: $date,displayedComponents: [.date], label: {
                                                Image(systemName: "calendar")
                                            }
                                        )
                                        .transition(.asymmetric(insertion: .opacity, removal: .identity))
                                    }
                                }
                            }
                            
                            
                            Group {
                                if activeDateType == .multipleDays {
                                    DatePicker(
                                        selection: $startDate,displayedComponents: [.date], label: {
                                            Text("Start Date")
                                        }
                                    )
                                    DatePicker(
                                        selection: $expirationDate,displayedComponents: [.date], label: {
                                            Text("End Date")
                                        }
                                    )
                                }
                            } .transition(.asymmetric(insertion: .opacity, removal: .identity))
                        }
                    }
                    
                    //Time Section
                    FormSection{
                        titleWithToggle(title: "Time", isOn: $timeOn)
                            .onChangeCustom(of: timeOn) {
                                showExpandedDatePicker = false
                            }
                        if timeOn {
                            CustomSegmentedControl(preselectedIndex: activeDateType == .multipleDays ? 1 : 0, optionLabels: [
                                {selected in
                                    Text("Specific time")
                                },
                                {selected in
                                    Text("Time period")
                                },
                            ], onSelect: {idx in
                                withAnimation {
                                    activeTimeType = idx == 0 ? .timePoint : .timeSpans
                                }
                            })
                            
                            if activeTimeType == .timePoint {
                                DatePicker(
                                    selection: $date,displayedComponents: [.hourAndMinute], label: {
                                        Image(systemName: "clock")
                                    }
                                )
                                //.contentShape(Rectangle())
                                
                            }
 
                        }
                        
                        
                    }
                    
                    
                    
                }.padding(.bottom, 30)
                Spacer()
            }
            //.background(.white.darker(by: 4))
            .animation(.default, value: timeOn)
            .animation(.default, value: hasReminder)
            .animation(.default, value: hasDate)
            .animation(.smooth, value: activeDateType)
            .animation(.default, value: showExpandedDatePicker)
            //.ignoresSafeArea(.keyboard)
            //.background(.red)
        }
    }
}

struct CustomDatePickerStyle: DatePickerStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            //configuration.label
            //Spacer()
            DatePicker("", selection: configuration.$selection, displayedComponents: .date)
                .datePickerStyle(.compact) // Customize as needed
                .labelsHidden()
        }
        
    }
}


struct DateAndTimeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DateAndTimeSelectionView()
    }
}
