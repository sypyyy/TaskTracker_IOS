//
//  HabitExtension.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/7/6.
//

import Foundation

extension HabitModel {
    public func getProgressPercent() -> Double {
        switch self.type {
        case .simple:
            return (self.done ?? false) ? 1 : 0
        case .number:
            let progress = self.numberProgress ?? 0
            let target = self.numberTarget ?? Int16.max
            if progress == 0 {
                return 0.001
            }
            else {
                var res = Double(progress) / Double(target)
                res = res > 1 ? 1 : res
                return res
            }
        case .time:
            let progress = self.timeProgress ?? "0:00"
            let target = self.timeTarget ?? "23:59"
            var res = Double(progress.timeToMinutes()) / Double(target.timeToMinutes())
            res = res == 0.0 ? 0.001 : res
            res = res > 1.0 ? 1.0 : res
            return res
        }
    }
}
