//
//  HabitTrackerViewModel+HabitRecording.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/7/1.
//

import Foundation
import CoreData
import SwiftUI

enum HabitStatisticShowType: String {
    case weekly = "weekly", monthly = "monthly", annually = "yearly"
}

class HabitTrackerStatisticViewModel : ObservableObject{
    static var shared = HabitTrackerStatisticViewModel()
    weak private var masterViewModel = TaskMasterViewModel.shared
    private var persistenceModel : PersistenceController = PersistenceController.preview
    public var markDate: Date? = Date()
    public var digestChartCycle: HabitStatisticShowType = .weekly {
        didSet {
            firedUpdate = false
        }
    }
    public var selectedInterval: (str: String, start: Date, end: Date) {
        var start: Date
        var end: Date
        var intervalStrRepresentation: String
        switch digestChartCycle {
        case .weekly:
            start = markDate?.startOfWeek() ?? Date()
            end = markDate?.endOfWeek() ?? Date()
            let prensentedStart = start.addByHour(12)
            let prensentedEnd = end.addByHour(-12)
            intervalStrRepresentation = "\(fmt5.string(from: prensentedStart))~\(fmt5.string(from: prensentedEnd))"
        case .monthly:
            start = markDate?.startOfMonth().startOfWeek() ?? Date()
            end = markDate?.endOfMonth() ?? Date()
            let prensentedStart = (markDate?.startOfMonth() ?? Date()).addByHour(12)
            intervalStrRepresentation = "\(fmt3.string(from: prensentedStart)) \(fmt8.string(from: prensentedStart))"
        case .annually:
            start = markDate?.startOfYear().startOfWeek() ?? Date()
            end = markDate?.endOfYear() ?? Date()
            let prensentedStart = (markDate?.startOfYear() ?? Date()).addByHour(12)
            //end = start.addByDay(1) ?? Date()
            intervalStrRepresentation = "\(fmt3.string(from: prensentedStart))"
        }
        
        return (intervalStrRepresentation, start, end)
    }
    public var selectedIntervalDateList: [Date] {
        let interval = selectedInterval
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

    public var cachedData: [Int64: [(Int, Color)]] = [:]
    
}

extension HabitTrackerStatisticViewModel {
    public func getIntervalRecords(startDate: Date?, endDate: Date?, habitID: String) -> [HabitRecord] {
        return persistenceModel.getIntervalRecords(startDate: startDate ?? selectedInterval.start, endDate: endDate ?? selectedInterval.end, habitID: habitID)
    }
}

extension HabitTrackerStatisticViewModel {
    func respondToDataChange() {
        firedUpdate = false
        TaskMasterViewModel.shared.statDataChanged = false
        //cachedData = [:]
    }
}
