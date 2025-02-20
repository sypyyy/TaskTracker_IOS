//
//  DateAndTimeSelectionView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/5/31.
//

import SwiftUI
import EventKit

enum TaskTimeType {
    case dateAndTime, timeSpans
}

enum TaskDateType {
    case singleDay, multipleDays
}

enum ActivePicker_DateTimeTab {
    case date, time, reminder, none
}

@MainActor
struct DateAndTimeSelectionView: View {
    let persistenceModel = PersistenceController.preview
    var masterViewModel = MasterViewModel.shared
    @State var activeTimeType = TaskTimeType.dateAndTime
    

    //Multiple days
    @State var activeDateType = TaskDateType.singleDay
    @State var startDate: Date = Date()
    @State var expirationDate: Date = Date()
    
    var body: some View {
        ZStack {
            GradientBackgroundInForm()
            ScrollView{
                VStack {
                    Spacer().frame(height: 15)
                    /*
                    CustomSegmentedControl(preselectedIndex: activeDateType == .multipleDays ? 1 : 0, optionLabels: [
                        {selected in
                            HStack {
                                Image(systemName: "clock")
                                Text("Date and Time")
                            }
                            
                        },
                        {selected in
                            HStack {
                                Image(systemName: "calendar.day.timeline.left")
                                Text("Time periods")
                            }
                            
                        },
                    ], onSelect: {idx in
                        withAnimation {
                            activeTimeType = idx == 0 ? .dateAndTime : .timeSpans
                        }
                    })
                    .frame(maxWidth: 330)
                    */
                    if(activeTimeType == .dateAndTime) {
                        DateAndTimeTabView()
                    } else {
                        FormSection {
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
                        }
                    }
                    
                    
                }.padding(.bottom, 30)
                   
                Spacer()
            }
            //.background(.white.darker(by: 4))
            
        }
    }
}


struct TimePeriodTabView: View {
    var body: some View {
        VStack {
            
        }
    }
}

struct DateAndTimeTabView: View {
    //Picker to show
    @State var activePicker = ActivePicker_DateTimeTab.date
    func toggleActivePicker(toggle: ActivePicker_DateTimeTab) {
        if activePicker == toggle {
            activePicker = .none
        } else {
            activePicker = toggle
        }
    }
    //Date
    @State var hasDate = true
    @State var date: Date = Date()
    
    //Time
    @State var timeOn = false
    @State var scheduleTime: Date = Date()
    var body: some View {
        Group {
            
            
            FormSection {
                HeaderWithToggle(header: {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Date")
                    }
                }, isOn: $hasDate)
                if hasDate {
                    
                    
                    Group {
                        
                            HStack {
                                
                                CustomButton(action: {
                                    toggleActivePicker(toggle: .date)
                                }, content: {
                                    Text(fmt_date_select_localized.string(from: date))
                                })
                                
                                Spacer()
                                
                            }
                            //.padding(.vertical, 8)
                            
                            //.padding(.leading, 12)
                            if activePicker == .date {
                                CustomDivider()
                                DatePicker(
                                    selection: $date,displayedComponents: [.date], label: {
                                        
                                    }
                                )
                                
                                //.contentShape(Rectangle())
                                .datePickerStyle(.graphical)
                                .transition(.asymmetric(insertion: .opacity, removal: .identity))
                            }
                            
                            
                        
                    }
                    
                }
            }
            
            //Time Section
            FormSection{
                HeaderWithToggle(header: {
                    HStack {
                        Image(systemName: "clock")
                        Text("Time")
                    }
                }, isOn: $timeOn)
                if(timeOn) {
                    HStack {
                        
                        CustomButton(action: {
                            toggleActivePicker(toggle: .time)
                        }, content: {
                            Text(fmt_time_select_localized.string(from: date))
                        })
                        
                        Spacer()
                        
                    }
                    if activePicker == .time {
                        CustomDivider()
                        DatePicker(
                            selection: $date,displayedComponents: [.hourAndMinute], label: {
                                
                            }
                        )
                        .datePickerStyle(.wheel)
                        .frame(maxWidth: 270)
                        //.background(.red)
                    }
                    
                }
            }
            
            FormSection {
                Text("test").onTapGesture {
                    accessReminders()
                    
                }
            }
        }
        .animation(.default, value: timeOn)
        .animation(.default, value: hasDate)
        .animation(.default, value: activePicker)
        .onChangeCustom(of: timeOn, {
            if timeOn {
                activePicker = .time
            }
        })
        .onChangeCustom(of: hasDate, {
            if hasDate {
                activePicker = .date
            }
        })
    }
}

func accessReminders() {
    let eventStore = EKEventStore()
    let status = EKEventStore.authorizationStatus(for: .reminder)
    print("Status: \(status.rawValue)")
    if #available(iOS 17.0, *) {
        eventStore.requestFullAccessToReminders() { granted, error in
            if granted && error == nil {
                let reminder = EKReminder(eventStore: eventStore)
                reminder.title = "Your Reminder Title"
                reminder.calendar = eventStore.defaultCalendarForNewReminders()
                
                // Set the due date
                let dueDate = Date()
                reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
                
                // Set recurrence rule
                let recurrenceRule = EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)
                reminder.addRecurrenceRule(recurrenceRule)
                
                do {
                    try eventStore.save(reminder, commit: true)
                    print("Reminder saved")
                } catch {
                    print("Error saving reminder: \(error.localizedDescription)")
                }
            } else {
                print("Access denied or error: \(String(describing: error))")
            }
        }
    } else {
        
        eventStore.requestAccess(to: .reminder) { granted, error in
            if granted && error == nil {
                let reminder = EKReminder(eventStore: eventStore)
                reminder.title = "Your Reminder Title"
                reminder.calendar = eventStore.defaultCalendarForNewReminders()
                
                // Set the due date
                let dueDate = Date()
                reminder.dueDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
                
                // Set recurrence rule
                let recurrenceRule = EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)
                reminder.addRecurrenceRule(recurrenceRule)
                
                do {
                    try eventStore.save(reminder, commit: true)
                    print("Reminder saved")
                } catch {
                    print("Error saving reminder: \(error.localizedDescription)")
                }
            } else {
                print("Access denied or error: \(error?.localizedDescription ?? "Unknown error")")
            }
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
