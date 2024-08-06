//
//  GoalIntervalSelectionView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/7/24.
//

import SwiftUI

struct GoalStartAndEndSectionView: View {
    @StateObject var viewModel: GoalCreationViewModel
    var body: some View {
        HeaderWithToggle(header: {
            Text("Start and End")
        }, isOn: $viewModel.hasStartAndEndTime)
        if(viewModel.hasStartAndEndTime) {
            IntervalTypePickingView(viewModel: viewModel)
            IntervalInfoView(viewModel: viewModel)
            
            switch viewModel.intervalType {
            case .week:
                if viewModel.isPresentingInlineIntervalPicker {
                    CustomDivider()
                    WeekPickerView(week: $viewModel.week, currentYear: viewModel.week.endDate.getYear())
                }
            case .month:
                if viewModel.isPresentingInlineIntervalPicker {
                    CustomDivider()
                    MonthPicker(selectedMonth: $viewModel.month)
                }
            case .year:
                if viewModel.isPresentingInlineIntervalPicker {
                    CustomDivider()
                   YearPicker(selectedYear: $viewModel.year)
                }
            case .custom:
                EmptyView()
            }
            
            /*
            DisclosureGroup("Month", isExpanded: .constant(true)) {
                            Text("Option 1")
                            Text("Option 2")
                            // Add more month options here
                        }
             */
          
        }
    }
}


struct IntervalTypePickingView: View {
    @StateObject var viewModel: GoalCreationViewModel
    var body: some View {
        HStack{
            HeaderRegular{
                Text("Interval").fontWeight(.semibold)
            }
            Spacer()
            Menu {
                Button(action: {
                    viewModel.intervalType = .week
                }) {
                    Text("Week")
                    if(viewModel.intervalType == .week) {
                        Image(systemName: "checkmark")
                    }
                }
                Button(action: {
                    viewModel.intervalType = .month
                }) {
                    Text("Month")
                    if(viewModel.intervalType == .month) {
                        Image(systemName: "checkmark")
                    }
                }
                Button(action: {
                    viewModel.intervalType = .year
                }) {
                    Text("Year")
                    if(viewModel.intervalType == .year) {
                        Image(systemName: "checkmark")
                    }
                }
                Button(action: {
                    viewModel.intervalType = .custom
                }) {
                    Text("Custom")
                    if(viewModel.intervalType == .custom) {
                        Image(systemName: "checkmark")
                    }
                }
            } label: {
                HStack {
                    Label("\(viewModel.intervalType.rawValue)", image: "")
                    VStack {
                        Image(systemName: "chevron.up.chevron.down")
                    }
                    
                }
                
            }
            
           
        }
    }
}

struct IntervalInfoView: View {
    @StateObject var viewModel: GoalCreationViewModel
    var body: some View {
        HStack {
            switch viewModel.interval {
            case .week(let week):
                HStack {
                    CustomButton(action: {
                        withAnimation {
                            viewModel.isPresentingInlineIntervalPicker.toggle()
                        }
                    }, content: {
                        Text("\(week.localizedString)")
                    })
                    
                    Spacer()
                }
            case .month(let month):
                HStack {
                    CustomButton(action: {
                        withAnimation {
                            viewModel.isPresentingInlineIntervalPicker.toggle()
                        }
                    }, content: {
                        Text("\(month.localizedString)")
                    })
                    Spacer()
                }
            case .year(let year):
                HStack {
                    CustomButton(action: {
                        withAnimation {
                            viewModel.isPresentingInlineIntervalPicker.toggle()
                        }
                    }, content: {
                        Text("\(year.localizedString)")
                    })
                    Spacer()
                }
                
            case .custom(let startDate, let endDate):
                VStack {
                    DatePicker(
                        selection: $viewModel.startDate,displayedComponents: [.date], label: {
                            HeaderRegular{
                                Text("From").fontWeight(.semibold)
                            }
                            
                        }
                    )
                    //.contentShape(Rectangle())
                    .datePickerStyle(.compact)
                    
                    DatePicker(
                        selection: $viewModel.endDate,displayedComponents: [.date], label: {
                            HeaderRegular{
                                Text("To").fontWeight(.semibold)
                            }
                            
                        }
                    )
                    //.contentShape(Rectangle())
                    .datePickerStyle(.compact)
                }
            }
        
        }
    }
}



#Preview {
    GoalCreationView()
}
