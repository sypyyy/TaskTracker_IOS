//
//  TestChartLine.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/8/3.
//

import SwiftUI
import Charts

struct MonthlyHoursOfSunshine {
    var city: String
    var date: Date
    var hoursOfSunshine: Double


    init(city: String, date: Date, hoursOfSunshine: Double) {
        let calendar = Calendar.autoupdatingCurrent
        self.city = city
        self.date = date
        self.hoursOfSunshine = hoursOfSunshine
    }
}
extension MonthlyHoursOfSunshine: Identifiable {
    var id: String {
        date.description
    }
}

/*
var data: [MonthlyHoursOfSunshine] = [
    MonthlyHoursOfSunshine(date: Date(), hoursOfSunshine: 74),
    MonthlyHoursOfSunshine(date: Date().addByDay(1), hoursOfSunshine: 99),
    MonthlyHoursOfSunshine(date: Date().addByDay(2), hoursOfSunshine: 62)
]
*/

var data1: [MonthlyHoursOfSunshine] = {
    var data: [MonthlyHoursOfSunshine] = []
    for i in 0..<365 {
        data.append(MonthlyHoursOfSunshine(city: "Seattle", date: Date().addByDay(i), hoursOfSunshine: Double.random(in: 0...100)))
    }
    
    /*
    for i in 0..<3 {
        data.append(MonthlyHoursOfSunshine(city: "Boston", date: Date().addByDay(i), hoursOfSunshine: Double.random(in: 0...100)))
    }
     */
    return data
}()

var data2: [MonthlyHoursOfSunshine] = {
    var data: [MonthlyHoursOfSunshine] = []
    for i in 0..<365 {
        data.append(MonthlyHoursOfSunshine(city: "Seattle", date: Date().addByDay(i), hoursOfSunshine: Double.random(in: 0...100)))
    }
    
    /*
    for i in 0..<3 {
        data.append(MonthlyHoursOfSunshine(city: "Boston", date: Date().addByDay(i), hoursOfSunshine: Double.random(in: 0...100)))
    }
     */
    return data
}()




#Preview(body: {
    Chart() {
        ForEach(data1) { item in
            LineMark(
                x: .value("Date", item.date),
                y: .value("Hours of Sunshine", item.hoursOfSunshine)
            )
            
            .foregroundStyle(LinearGradient(colors: [backgroundGradientStart, backgroundGradientEnd], startPoint: .leading, endPoint: .trailing))
            
        }
        
        LineMark(
            x: .value("Date", Date()),
            y: .value("Hours of Sunshine", 50),
            series: .value("", 1)
        )
        .foregroundStyle(LinearGradient(colors: [.black, .black], startPoint: .leading, endPoint: .trailing))
        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
        LineMark(
            x: .value("Date", Date().addByDay(50)),
            y: .value("Hours of Sunshine", 50),
            series: .value("", 1)
        )
        LineMark(
            x: .value("Date", Date().addByDay(50)),
            y: .value("Hours of Sunshine", 80),
            series: .value("", 1)
        )
        LineMark(
            x: .value("Date", Date().addByDay(80)),
            y: .value("Hours of Sunshine", 80),
            series: .value("", 1)
        )
        
        /*
        LineMark(
            x: .value("Month", $0.date),
            y: .value("Hours of Sunshine", $0.hoursOfSunshine)
        )
        .foregroundStyle(by: .value("Segment Color", $0.hoursOfSunshine > 50 ? "High Sunshine" : "Low Sunshine"))
         */
        //.lineStyle(.init())
    }.padding(.vertical, 250)
        .padding(.horizontal, 12)
})
