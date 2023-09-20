//
//  timeExtension.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/7/8.
//

import Foundation

extension String {
    //"1:30" -> 90
    public func timeToMinutes() -> Int {
        let t = self
        let timeArr = t.components(separatedBy: ":")
        let hour = Int(timeArr.first ?? "0")
        let minute = Int(timeArr.last ?? "0")
        return (minute ?? 0) + (hour ?? 0) * 60
    }
}


extension Int {
    //90 -> "1:30"
    public func minutesToTime() -> String {
        let m = self % 60
        let h = self / 60
        let mStr = m <= 9 ? "0\(m)" : "\(m)"
        let hStr = "\(h)"
        return "\(hStr):\(mStr)"
    }
}



