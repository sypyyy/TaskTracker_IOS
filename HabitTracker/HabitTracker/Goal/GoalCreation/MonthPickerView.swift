//
//  testMonthPicker.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/7/25.
//

import SwiftUI

import UIKit


class YearMonthPickerViewController: UIViewController {

    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

       // if #available(iOS 17.4, *) {
        //    datePicker.datePickerMode = .yearAndMonth
       // } else {
            // Fallback on earlier versions
            datePicker.datePickerMode = .date
            datePicker.datePickerMode = .init(rawValue: 4269) ?? .date
       // }
        datePicker.preferredDatePickerStyle = .wheels

        view.addSubview(datePicker)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            datePicker.widthAnchor.constraint(equalTo: view.widthAnchor),
            datePicker.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}


struct YearMonthPickerView: UIViewControllerRepresentable {
    @Binding var selectedMonth: Month

    func makeUIViewController(context: Context) -> YearMonthPickerViewController {
        let pickerViewController = YearMonthPickerViewController()
        pickerViewController.datePicker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        return pickerViewController
    }

    func updateUIViewController(_ uiViewController: YearMonthPickerViewController, context: Context) {
        uiViewController.datePicker.date = selectedMonth.comeUpWithaDate()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: YearMonthPickerView

        init(_ parent: YearMonthPickerView) {
            self.parent = parent
        }

        @MainActor @objc func dateChanged(_ sender: UIDatePicker) {
            parent.selectedMonth = sender.date.getMonth()
        }
    }
}



struct MonthPicker: View {
    @Binding var selectedMonth: Month
   
    var body: some View {
        VStack {
            //Text("Selected Month: \(selectedMonth.localizedString())")
            YearMonthPickerView(selectedMonth: $selectedMonth)
                .frame(height: 200)
        }
    }
}

#Preview {
    ZStack {
        Color.red
        MonthPicker(selectedMonth: .constant(.init(month: 7, year: 2024)))
    }
}
