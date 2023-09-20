//
//  HabitTrackerStatisticalDetailViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/15.
//

import Foundation
import CoreData
import SwiftUI

/*
enum HabitStatisticShowType: String {
    case weekly = "weekly", monthly = "monthly", annually = "yearly"
}
*/


//这个类为了确保线程安全尝试用非单例的方式实现
class HabitTrackerStatisticDetailViewModel : ObservableObject {
    
    init(habit: habitViewModel, markDate: Date, chartType: HabitStatisticShowType) {
        self.habit = habit
        self.markDate = markDate
        self.regularChartType = chartType
    }
    //var currentHabitID: Int64?
    var habit: habitViewModel?
    public var markDate: Date? = Date()
    public var regularChartType: HabitStatisticShowType {
        didSet {
            firedUpdate = false
            cachedRegularChartData = []
        }
    }
    
    weak private var masterViewModel = HabitTrackerViewModel.shared
    private var persistenceModel : HabitController = HabitController.preview
    public var regularChartSelectedInterval: (str: String, start: Date, end: Date) {
        var start: Date
        var end: Date
        var intervalStrRepresentation: String
        switch regularChartType {
        case .weekly:
            start = markDate?.startOfWeek() ?? Date()
            end = markDate?.endOfWeek() ?? Date()
            intervalStrRepresentation = "\(fmt5.string(from: start))~\(fmt5.string(from: end))"
        case .monthly:
            start = markDate?.startOfMonth().startOfWeek() ?? Date()
            end = markDate?.endOfMonth() ?? Date()
            intervalStrRepresentation = "\(fmt3.string(from: start)) \(fmt8.string(from: start))"
        case .annually:
            start = markDate?.startOfYear().startOfWeek() ?? Date()
            end = markDate?.endOfYear() ?? Date()
            //end = start.addByDay(1) ?? Date()
            intervalStrRepresentation = "\(fmt3.string(from: start))"
        }
        return (intervalStrRepresentation, start, end)
    }
    public var regularChartSelectedIntervalDateList: [Date] {
        let interval = regularChartSelectedInterval
        let start = interval.start
        let end = interval.end
        var ptr = start.addByHour(12)
        var res = [Date]()
        while ptr.compareTo(end) < 0 {
            res.append(ptr)
            ptr = ptr.addByDay(1)
        }
        return res
    }
    
    public var firedUpdate = false
    
    //MARK: Cache
    public var cachedRegularChartData: [(String, Int, Int)] = []
    
}

extension HabitTrackerStatisticDetailViewModel {
    public func getDataList() {
        let habit = self.habit ?? habitViewModel(habit: Habit())
        let masterModel = HabitTrackerViewModel.shared
        var res = [(Date, finished: Int, target: Int, isOut: Bool, isStopped: Bool)]()
        var tempInfo = (date: Date(), finished: 0, target: 0, isOut: false, isStopped: false)
        let targetSeries = masterModel.getTargetSeries(habitID: habit.id)
        let stopSeries = masterModel.getStopCheckPoints(habitID: habit.id)
        let recordSeries = self.getIntervalRecords(startDate: nil, endDate: nil, habitID: habit.id)
        var targetPointIdx = 0
        var stopPointIdx = 0
        var recordPointIdx = 0
        
        for date in self.regularChartSelectedIntervalDateList {
            appendIfNeeded(date: date)
        }
        
        self.cachedRegularChartData = res.enumerated().map{ idx, info in
            ("\(idx)", info.finished, info.target)
        }
        
        func appendIfNeeded(date: Date) {
            filterOutofInterval(date: date)
            //res.append((date, 0, false, false))
        }
        
        func filterOutofInterval(date: Date) {
            tempInfo = (date: Date(), finished: 0, target: 0, isOut: false, isStopped: false)
            switch self.regularChartType {
            case .annually:
                
                switch habit.cycle {
                case .daily:
                    if !date.isSameYear(self.markDate ?? Date()) {
                        tempInfo.isOut = true
                    }
                case .weekly:
                    if !date.isSameYear(self.markDate ?? Date()) {
                        tempInfo.isOut = true
                    }
                case .monthly:
                    if !date.isSameYear(self.markDate ?? Date()) {
                        tempInfo.isOut = true
                    }
                }
            case .monthly:
                if !date.isSameMonth(self.markDate ?? Date()) {
                    tempInfo.isOut = true
                }
            case .weekly:
                tempInfo.isOut = false
            }
            filterStopped(date: date)
        }
        
        func filterStopped(date: Date) {
            let isStopped = isStopped(date: date, idx: stopPointIdx)
            if isStopped {
                tempInfo.isStopped = true
            }
            calculateAndAppendData(date: date)
        }
        
        func calculateAndAppendData(date: Date) {
            
            switch habit.cycle {
            case .daily:
                let finished = getProgress(date: date)
                tempInfo.finished = finished
                let target = getTarget(date: date)
                tempInfo.target = target
                if self.regularChartType != .annually && res.last?.isOut == true {
                    res = []
                }
                res.append(tempInfo)
            case .weekly:
                if date.compareToByDay(date.startOfWeek()) == 0 {
                    let finished = getProgress(date: date)
                    tempInfo.finished = finished
                    let target = getTarget(date: date)
                    tempInfo.target = target
                } else {
                    tempInfo.finished = res.last?.finished ?? 0
                    tempInfo.target = res.last?.target ?? 0
                }
                if self.regularChartType != .annually && res.last?.isOut == true {
                    res = []
                }
                res.append(tempInfo)
            case .monthly:
                if date.compareToByDay(date.startOfMonth()) == 0 {
                    let finished = getProgress(date: date)
                    tempInfo.finished = finished
                    let target = getTarget(date: date)
                    tempInfo.target = target
                } else {
                    tempInfo.finished = res.last?.finished ?? 0
                    tempInfo.target = res.last?.target ?? 0
                }
                if self.regularChartType != .annually && res.last?.isOut == true {
                    res = []
                }
                res.append(tempInfo)
            }
        }
        
        //返回习惯在某一个日期是否已经停止或者是否开始
        func isStopped(date: Date, idx: Int) -> Bool {
            for i in idx..<stopSeries.count {
                if let nextDate = stopSeries[i].date {
                    if nextDate.compareToByDay(date) <= 0 {
                        stopPointIdx = i
                    } else {
                        break
                    }
                }
            }
            if date.compareToByDay(stopSeries[stopPointIdx].date ?? date) < 0 {
                return true
            }
            return stopSeries[stopPointIdx].type != StopPointType.go.rawValue
            
        }
        
        //返回在某一个日期的目标，如果是时间就转换成分钟形式的Int
        func getTarget(date: Date) -> Int {
            for i in targetPointIdx..<targetSeries.count {
                if let nextDate = targetSeries[i].date {
                    if nextDate.compareToByDay(date) <= 0 {
                        targetPointIdx = i
                    } else {
                        break
                    }
                }
            }
            switch habit.type {
            case .number:
                let res = targetSeries[targetPointIdx].numberTarget
                return Int(res)
            case .time:
                return targetSeries[targetPointIdx].timeTarget?.timeToMinutes() ?? Int.max
            default:
                return 1
            }
        }
        
        //返回在某一日期的记录，如果是时间就转换成分钟形式的Int
        func getProgress(date: Date) -> Int {
            let res = 0
            for i in recordPointIdx..<recordSeries.count {
                if let nextDate = recordSeries[i].date {
                    if nextDate.compareToByDay(date) < 0 {
                        recordPointIdx = i
                        continue
                    } else if nextDate.compareToByDay(date) == 0 {
                        recordPointIdx = i
                        switch habit.type {
                        case .number:
                            let res = recordSeries[i].numberProgress
                            return Int(res)
                        case .time:
                            return recordSeries[i].timeProgress?.timeToMinutes() ?? 0
                        case .simple:
                            return recordSeries[i].done ? 1 : 0
                        }
                    } else {
                        return res
                    }
                }
            }
            return 0
        }
    }
}

extension StatisticalView {
    private func getFillColor(info: ((Date, Double, isOut: Bool, isStopped: Bool))) -> Color {
        let rate = info.1
        if info.isOut {
            return .clear
        }
        else if info.isStopped {
            return .orange.lighter(by: 25)
        }
        else if rate >= 0 && rate <= 0.2 {
            return .gray.lighter(by: 40)
        }
        else if rate > 0.2 && rate <= 0.4 {
            return .green.lighter(by: 20)
        }
        else if rate > 0.4 && rate <= 0.6 {
            return .green.lighter(by: 10)
        }
        else if rate > 0.6 && rate <= 0.8 {
            return .green.lighter(by: 0)
        }
        else if rate > 0.8 {
            return .green.darker(by: 5)
        }
        return backgroundGradientStart.lighter(by: 30)
    }
}

extension HabitTrackerStatisticDetailViewModel {
    public func getIntervalRecords(startDate: Date?, endDate: Date?, habitID: Int64) -> [HabitRecord] {
        return persistenceModel.getIntervalRecords(startDate: startDate ?? regularChartSelectedInterval.start, endDate: endDate ?? regularChartSelectedInterval.end, habitID: habitID)
    }
}



