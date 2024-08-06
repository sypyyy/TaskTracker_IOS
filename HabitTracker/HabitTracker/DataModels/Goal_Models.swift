//
//  Goal_Models.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/6/22.
//

import Foundation

enum GoalRowInfo: Equatable {
    case goal(id: String)
}

//MARK: 项目/目标
class GoalModel: AnyTreeNode {
    weak var storageModel: Goal? = nil
    var measurementModel: GoalMeasurementModel? = nil
    var intervalModel: GoalIntervalModel? = nil
    var name: String
    var isRoot: Bool
    var isFinished: Bool
    var createDate: Date
    
    init(name: String, isFinished: Bool, id: String, isRoot: Bool, createDate: Date = Date()){
        self.name = name
        self.isFinished = isFinished
        self.createDate = createDate
        self.isRoot = isRoot
        super.init(id: id, children: [], isExpanded: false, parent: nil, level: 0, originalType: TreeNodeSubclassInfo.sideMenuRow(info: .Folder(id: id)), orderIdx: 0)
    }
    
    
    init(goal: Goal, traverseTasks: Bool = true) {
        self.storageModel = goal
        if let measurement = goal.measurement {
            self.measurementModel = GoalMeasurementModel(measurement: measurement)
        }
        if let interval = goal.interval {
            self.intervalModel = GoalIntervalModel(storageModel: interval)
        }
        self.isRoot = goal.isRoot
        self.createDate = goal.createDate ?? Date()
        self.name = goal.name ?? ""
        self.isFinished = goal.isFinished
        let childGoals: [GoalModel] = (goal.childGoals?.allObjects as? [Goal] ?? []).map({
            GoalModel(goal: $0)
        })
        var childrenNodes: [AnyTreeNode] = childGoals
        
        if(traverseTasks) {
            let childHabits = (goal.habits?.allObjects as? [Habit] ?? []).map({
                HabitModel(habit: $0)
            })
            let childTodos = (goal.todos?.allObjects as? [Todo] ?? []).map({
                TodoModel(todo: $0)
            })
            childrenNodes.append(contentsOf: childTodos)
            childrenNodes.append(contentsOf: childHabits)
        }
        super.init(id: goal.id ?? "", children: childrenNodes, isExpanded: false, parent: nil, level: 0, originalType: TreeNodeSubclassInfo.goalRow(info: .goal(id: goal.id ?? "")), orderIdx: 0)
    }
    
    override func getSearchKeyWord() -> String {
        name.lowercased()
    }
    
}

class GoalRecordModel {
    var date: Date
    var value: Float
    
    init(storageModel: GoalMeasurementRecord) {
        self.date = storageModel.date ?? Date()
        self.value = storageModel.value
    }
}

class GoalMeasurementModel {
    weak var storageModel: GoalMeasurement?
    var startValue: Float
    var targetValue: Float
    var allowDecimal: Bool
    var unit: String
    init(measurement: GoalMeasurement) {
        self.storageModel = measurement
        self.startValue = measurement.startValue
        self.targetValue = measurement.targetValue
        self.unit = measurement.unit ?? ""
        self.allowDecimal = measurement.allowDecimal
    }
    
    func getRecords(start: Date? = nil, end: Date? = nil) -> [GoalRecordModel] {
        let records = (storageModel?.records?.allObjects as? [GoalMeasurementRecord] ?? []).map({
            GoalRecordModel(storageModel: $0)
        })
        return records
    }
    
    init(startValue: Float, targetValue: Float, unit: String, allowDecimal: Bool) {
        self.startValue = startValue
        self.targetValue = targetValue
        self.unit = unit
        self.allowDecimal = allowDecimal
    }
}

class GoalIntervalModel {
    weak var storageModel: GoalIntervalInfo?
    var interval: GoalInterval
    init(storageModel: GoalIntervalInfo) {
        self.storageModel = storageModel
        let intervalType = GoalIntervalType(rawValue: storageModel.intervalType ?? "") ?? .custom
        switch intervalType {
        case .week:
            interval = .week(week: Week(startDate: storageModel.startDate ?? Date(), endDate: storageModel.endDate ?? Date()))
        case .month:
            interval = .month(month: Month(month: Int(storageModel.month), year: Int(storageModel.year)))
        case .year:
            interval = .year(year: Year(year: Int(storageModel.year)))
        case .custom:
            interval = .custom(startDate: storageModel.startDate ?? Date(), endDate: storageModel.endDate ?? Date())
        }
    }
    
    init(interval: GoalInterval) {
        self.interval = interval
    }
}
