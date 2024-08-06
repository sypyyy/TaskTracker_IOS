//
//  YearPicker.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/7/31.
//

import SwiftUI

struct YearPicker: UIViewRepresentable {
    @Binding var selectedYear: Year

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: YearPicker
        let yearsRange = (1900...4000)
        init(parent: YearPicker) {
            self.parent = parent
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return yearsRange.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            let year = yearFrom(row: row)
            return "\(year)"
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let year = yearFrom(row: row)
            parent.selectedYear = Year(year: year)
        }

        func yearFrom(row: Int) -> Int {
            let years = Array(yearsRange)
            let index = row % years.count
            return years[index]
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIView(_ uiView: UIPickerView, context: Context) {
        let years = Array(context.coordinator.yearsRange)
        if let index = years.firstIndex(of: selectedYear.year) {
            uiView.selectRow(index, inComponent: 0, animated: false)
        }
    }
}


#Preview {
    YearPicker(selectedYear: .constant(Year(year: 2021)))
}
