//
//  Projects.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/4.
//

import CoreData

enum CreateGoalResult {
    case Success,Duplicate
}

extension PersistenceController  {
    func createGoal(dataModel: GoalModel) -> String {
        //let result = habitController(inMemory: true)
        //let viewContext = result.container.viewContext
        let viewContext = self.container.viewContext
        let newGoal = dataModel.convertToStorageModel(context: viewContext)
        let id = dataModel.calculateId()
        /*
        let isIdUnique = checkGoalIdIsUnique(IdToBe: id)
        if !isIdUnique {
            viewContext.delete(newGoal)
            return ""
        }
         */
        newGoal.id = id
        if let intervalModel = dataModel.intervalModel {
            let newInterval = intervalModel.convertToStorageModel(context: viewContext)
            newGoal.interval = newInterval
        }
        if let measurementModel = dataModel.measurementModel {
            let newMeasurement = measurementModel.convertToStorageModel(context: viewContext)
            newGoal.measurement = newMeasurement
        }
        saveChanges(viewContext: viewContext)
        return id
    }

    private func checkGoalIdIsUnique(IdToBe: String) -> Bool {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", "\(IdToBe)")
        do {
            let res = try container.viewContext.fetch(request)
            if res.count == 0 {
                return true
            }
        }
        catch {
            return false
        }
        return false
    }
    
    func getAllRootGoals() -> [Goal] {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "isRoot == true")
        //"start >= %@ && ((willExpire && expireDate < %@) || !willExpire)"
        do {
            let res = try container.viewContext.fetch(request)
            return res
        }
        catch {
            print("error fetching")
            return []
        }
    }
    
    func getAllGoals() -> [Goal] {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        do {
            let res = try container.viewContext.fetch(request)
            return res
        }
        catch {
            print("error fetching")
            return []
        }
    }
    
    func getGoalById(id: String) -> Goal? {
        do {
            let request: NSFetchRequest<Goal> = Goal.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            let results = try container.viewContext.fetch(request)
            return results.first
        }
        catch {
            print("error fetching")
            return nil
        }
    }
    
    func addGoalToParent(parentID: String, childID: String) {
        do {
            if let parent = getGoalById(id: parentID), let child = getGoalById(id: childID) {
                parent.addToChildGoals(child)
                saveChanges(viewContext: container.viewContext)
            } else {
                print("child or parent goal not found!")
            }
        }
        catch {
            print("error fetching")
            return
        }
    }
    
    func resetParentForGoal(goalId: String) {
        do {
            if let goal = getGoalById(id: goalId) {
                goal.parentGoal = nil
                saveChanges(viewContext: container.viewContext)
            } else {
                print("child or parent goal not found!")
            }
        }
        catch {
            print("error fetching")
            return
        }
    }
}


extension GoalModel {
    
    func convertToStorageModel(context: NSManagedObjectContext) -> Goal {
        let res = Goal.init(context: context)
        res.name = name
        res.isRoot = isRoot
        res.isFinished = isFinished
        return res
    }
}

extension GoalModel {
    func calculateId() -> String {
        return "\(fmt_timeStamp.string(from: Date()))<#$>\(UUID().uuidString)"
    }
}

extension GoalIntervalModel {
    func convertToStorageModel(context: NSManagedObjectContext) -> GoalIntervalInfo {
        let res = GoalIntervalInfo.init(context: context)
        
        switch self.interval {
        case .custom(let startDate, let endDate):
            res.intervalType = GoalIntervalType.custom.rawValue
            res.startDate = startDate
            res.endDate = endDate
        case .week(let week):
            res.intervalType = GoalIntervalType.week.rawValue
            res.startDate = week.startDate
            res.endDate = week.endDate
        case .month(let month):
            res.intervalType = GoalIntervalType.month.rawValue
            res.month = Int16(month.month)
            res.year = Int16(month.year)
        case .year(let year):
            res.intervalType = GoalIntervalType.year.rawValue
            res.year = Int16(year.year)
        }
        return res
    }
}

extension GoalMeasurementModel {
    func convertToStorageModel(context: NSManagedObjectContext) -> GoalMeasurement {
        let res = GoalMeasurement.init(context: context)
        res.startValue = self.startValue
        res.targetValue = self.targetValue
        res.allowDecimal = self.allowDecimal
        res.unit = self.unit
        return res
    }
}
