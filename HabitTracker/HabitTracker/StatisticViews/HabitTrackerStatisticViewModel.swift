//
//  HabitTrackerViewModel+HabitRecording.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/7/1.
//

import Foundation
import CoreData

enum HabitStatisticShowType {
    case weekly, monthly, annually
}

class HabitTrackerStatisticViewModel : ObservableObject{
    static var shared = HabitTrackerStatisticViewModel()
    weak private var masterViewModel = HabitTrackerViewModel.shared
    private var persistenceModel : HabitController = HabitController.preview
    private var preferredDate: Date? = Date()
    public var statisticalChartType: HabitStatisticShowType = .weekly
    public var selectedInterval: (str: String, start: Date, end: Date) {
        var start: Date
        var end: Date
        var intervalStrRepresentation: String
        switch statisticalChartType {
        case .weekly:
            start = preferredDate?.startOfWeek() ?? Date()
            end = preferredDate?.endOfWeek() ?? Date()
            intervalStrRepresentation = "\(fmt5.string(from: start))~\(fmt5.string(from: end))"
        case .monthly:
            start = preferredDate?.startOfMonth() ?? Date()
            end = preferredDate?.endOfMonth() ?? Date()
            intervalStrRepresentation = "\(fmt3.string(from: start)) \(fmt8.string(from: start))"
        case .annually:
            start = preferredDate?.startOfYear() ?? Date()
            end = preferredDate?.endOfYear() ?? Date()
            intervalStrRepresentation = "\(fmt3.string(from: start))"
        }
        return (intervalStrRepresentation, start, end)
    }
    //MARK: Cache
}

extension HabitTrackerStatisticViewModel {
    public func getIntervalRecords(startDate: Date?, endDate: Date?, habitID: Int64) -> [HabitRecord] {
        return persistenceModel.getIntervalRecords(startDate: startDate ?? selectedInterval.start, endDate: endDate ?? selectedInterval.end, habitID: habitID)
    }
}
