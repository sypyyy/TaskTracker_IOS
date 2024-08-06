//
//  GoalCreationViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/7/22.
//

import Foundation
import SwiftUI

//These strings are storage related, do not modify by will
enum GoalIntervalType: String {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    case custom = "Custom"
}

enum GoalInterval {
    case week(week: Week)
    case month(month: Month)
    case year(year: Year)
    case custom(startDate: Date, endDate: Date)
}

enum GoalCreationMode {
    case create
    case edit(goal: GoalModel)
}

@MainActor
class GoalCreationViewModel: ObservableObject {
    
    let settingsViewModel = SettingsViewModel.shared
    static let shared = GoalCreationViewModel()
    let persistenceModel = PersistenceController.preview
    
    var mode: GoalCreationMode = .create
    let edittingGoal: GoalModel? = nil
    
    init(mode: GoalCreationMode = .create, goal: GoalModel? = nil) {
        self.mode = mode
        if let goal = goal {
            /*
            self.edittingGoal = goal
            self.goalName = goal.name
            self.hasStartAndEndTime = goal.hasStartAndEndTime
            self.intervalType = goal.intervalType
            self.week = goal.week
            self.month = goal.month
            self.year = goal.year
            self.startDate = goal.startDate
            self.endDate = goal.endDate
            self.hasMeasurement = goal.hasMeasurement
            self.hasParentGoal = goal.hasParentGoal
             */
        }
    }
    
    // MARK: - Goal name
    @Published var goalName: String = ""
    
    // MARK: - Interval
    @Published var hasStartAndEndTime: Bool = false
    @Published var intervalType: GoalIntervalType = .custom
    //Weekly interval
    @Published var week: Week = Week.getCurrentWeek(startOfWeek: SettingsViewModel.shared.startOfWeek)
    //Monthly interval
    @Published var month: Month = Month.currentMonth
    //Yearly interval
    @Published var year: Year = Year.currentYear
    //Custom interval
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    var interval: GoalInterval {
        switch intervalType {
        case .week:
            return .week(week: week)
        case .month:
            return .month(month: month)
        case .year:
            return .year(year: year)
        case .custom:
            return .custom(startDate: startDate, endDate: endDate)
        }
    }
    @Published var isPresentingInlineIntervalPicker = false
    
    
    // MARK: - Measurement
    @Published var hasMeasurement: Bool = false
    @Published var startValueString = ""
    @Published var targetValueString = ""
    @Published var unit = ""
    @Published var allowDecimal: Bool = false
    var measurementValid: Bool {
        if(allowDecimal) {
            return startAndTargetFloat != nil
        } else {
            return startAndTargetInt != nil
        }
    }
    var startAndTargetFloat: (start: Float, target: Float)? {
        guard let startValue = Float(startValueString), let targetValue = Float(targetValueString) else {
            return nil
        }
        return (startValue, targetValue)
    }
    
    var startAndTargetInt: (start: Int, target: Int)? {
        guard let startValue = Int(startValueString), let targetValue = Int(targetValueString) else {
            return nil
        }
        return (startValue, targetValue)
    }
    
    // MARK: - Parent
    @Published var parentGoal: GoalModel? = nil
    @Published var isPresentingParentGoalPicker = false
}

extension GoalCreationViewModel {
    func commitSave() {
        switch self.mode {
        case .create:
            let level = 0
            let goalModel = GoalModel(name: self.goalName, isFinished: false, id: "", isRoot: parentGoal == nil)
            if(self.hasStartAndEndTime) {
                goalModel.intervalModel = GoalIntervalModel(interval: self.interval)
            }
            if(self.measurementValid) {
                let startValue: Float
                let targetValue: Float
                if allowDecimal {
                    startValue = startAndTargetFloat?.start ?? 0
                    targetValue = startAndTargetFloat?.target ?? 0
                } else {
                    startValue = Float(startAndTargetInt?.start ?? 0)
                    targetValue = Float(startAndTargetInt?.target ?? 0)
                }
                goalModel.measurementModel = GoalMeasurementModel(startValue: startValue, targetValue: targetValue, unit: self.unit, allowDecimal: self.allowDecimal)
            }
            if let parent = self.parentGoal {
                goalModel.level = parent.level + 1
            } else {
                goalModel.level = 0
            }
            let newGoalId = persistenceModel.createGoal(dataModel: goalModel)
            if let parent = self.parentGoal {
                persistenceModel.addGoalToParent(parentID: parent.id, childID: newGoalId)
            }
            MasterViewModel.shared.didReceiveChangeMessage(msg: .goalCRUD)
        default:
            break
        }
    }
}
