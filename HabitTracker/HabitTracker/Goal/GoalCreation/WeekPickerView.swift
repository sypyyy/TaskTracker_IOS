//
//  testPickerView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/7/25.
//

import SwiftUI
import UIKit
/*
struct CustomPickerView: UIViewRepresentable {
    var data: [String]
    @Binding var selectedRow: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.delegate = context.coordinator
        pickerView.dataSource = context.coordinator
        return pickerView
    }

    func updateUIView(_ uiView: UIPickerView, context: Context) {
        uiView.selectRow(selectedRow, inComponent: 0, animated: true)
    }

    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: CustomPickerView

        init(_ parent: CustomPickerView) {
            self.parent = parent
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.data.count
        }

        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            var label: UILabel
            if let view = view as? UILabel {
                label = view
            } else {
                label = UILabel()
            }

            label.text = parent.data[row]
            label.textAlignment = .center

            // Customize the font here
            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold, width: .standard)
            
            return label
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selectedRow = row
        }
    }
}
*/


fileprivate extension Year {
    func getFirstWeek(startOfWeek: Weekday) -> Week {
        var calendar = Calendar.current
        calendar.firstWeekday = startOfWeek.rawValue
        
        guard let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1)) else {
            //Most likely never gonna happen
            return Week(startDate: Date(), endDate: Date())
        }
        let firstWeek = calendar.dateInterval(of: .weekOfYear, for: startOfYear)!
        return Week(startDate: firstWeek.start, endDate: firstWeek.end)
    }
}

@MainActor
struct WeekPickerView: View {
    var settingViewModel = SettingsViewModel.shared
    @Binding var week: Week
    @State var currentYear: Year
    @State var isShowingYearPicker = false
    var weeks: [Week] {
        currentYear.getAllWeeksInside(startOfWeek: settingViewModel.startOfWeek)
    }
    var body: some View {
        VStack(spacing: 0) {
            //Text("\(week.localizedString)")
            HStack {
                Text("\(currentYear.year)")
                Spacer()
                Button(action: {
                    currentYear = Year(year: (currentYear.year - 1))
                    week = currentYear.getFirstWeek(startOfWeek: settingViewModel.startOfWeek)
                }, label: {
                    Image(systemName: "chevron.left")
                })
                Spacer().frame(width: 6)
                Button(action: {
                    currentYear = Year(year: (currentYear.year + 1))
                    week = currentYear.getFirstWeek(startOfWeek: settingViewModel.startOfWeek)
                }, label: {
                    Image(systemName: "chevron.right")
                })
                
            }.padding(.horizontal, 4)
            
            Picker("Week", selection: $week) {
                ForEach(weeks, id: \.localizedString) {week in
                    Text(week.localizedString).tag(week)
                }
            }.pickerStyle(.inline)
        }
    }
}

#Preview {
    WeekPickerView(week: .constant(Week.getCurrentWeek(startOfWeek: SettingsViewModel.shared.startOfWeek)), currentYear: Year(year: 2024))
}
