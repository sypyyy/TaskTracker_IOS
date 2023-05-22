//
//  HabitTrackerModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/4/22.
//

import Foundation
struct habitTrackerModel {
    //keep track of the date today
    var today : Date = Date()
    var startDate : Date {
        
        print("restarted here")
        return Calendar.current.date(byAdding: .day, value: -7, to: today)!
    }
    var habits : [String] {
        return ["Read books","Drink water","Do homework ee450 and 570"]
    }
    mutating func refreshDate() {
        today = Date()
    }
    
}
