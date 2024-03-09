//
//  Habits.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/6/24.
//

import CoreData

enum PersistenceError: Error {
    case duplicateId
}


extension PersistenceController {
    
    func creatNewHabit(habit: HabitModel) throws {
        let viewContext = self.container.viewContext
        let IdToBe = "\(habit.name)<#$>\(TaskType.habit.rawValue)"
        let isNameUnique = checkHabitIdIsUnique(IdToBe: IdToBe)
        if !isNameUnique {
            throw PersistenceError.duplicateId
        }
        let newHabit = habit.convertToStorageModel(context: viewContext)
        newHabit.id = IdToBe
        saveChanges(viewContext: viewContext)
        creatTargetAndStopPointForNewHabit(habit: habit, IdToBe: IdToBe, context: viewContext)
    }
    
    private func creatTargetAndStopPointForNewHabit(habit: HabitModel, IdToBe: String, context: NSManagedObjectContext) {
        var startDate = Date()
        let cycle = habit.cycle
        if cycle == .weekly {
            startDate = startDate.startOfWeek()
        } else if cycle == .monthly {
            startDate = startDate.startOfMonth()
        }
        switch habit.type {
        case .number:
            let target: Int16 = Int16(habit.numberTarget ?? 0)
            setTargetCheckPoint(habitID: IdToBe, date: startDate, numberTarget: target)
        case .time:
            let target = habit.timeTarget
            setTargetCheckPoint(habitID: IdToBe, date: startDate, timeTarget: target ?? "00:00")
        default:
            break
        }
        //setStopCheckPoint(habitID: id, date: Date(), stopPointType: .go)
        if cycle == .daily {
            setStopCheckPoint(habitID: IdToBe, date: startDate, stopPointType: .go)
        } else if cycle == .weekly {
            setStopCheckPoint(habitID: IdToBe, date: startDate, stopPointType: .go)
        } else if cycle == .monthly {
            setStopCheckPoint(habitID: IdToBe, date: startDate, stopPointType: .go)
        }
        saveChanges(viewContext: context)
    }
    /*
    
    func createHabit(name: String, detail: String, habitType: HabitType, cycle: String, targetNumber: Int, numberUnit: String, targetHour: Int, targetMinute: Int, setTarget: Bool = true, project: String, priority: Int16, executionTime: String) throws {
        //let result = habitController(inMemory: true)
        //let viewContext = result.container.viewContext
        let viewContext = self.container.viewContext
        let newHabit = Habit(context: viewContext)
        let IdToBe = "\(name)<#$>\(TaskType.habit.rawValue)"
        let isNameUnique = checkHabitIdIsUnique(IdToBe: IdToBe)
        if !isNameUnique {
            throw PersistenceError.duplicateId
        }
        newHabit.type = habitType.rawValue
        newHabit.name = name
        newHabit.cycle = cycle
        newHabit.createdDate = Date()
        newHabit.detail = detail
        newHabit.isTargetSet = setTarget
        newHabit.id = IdToBe
        newHabit.numberUnit = numberUnit
        newHabit.priority = priority
        newHabit.project = project
        newHabit.executionTime = executionTime
        saveChanges(viewContext: viewContext)
        var startDate = Date()
        if cycle == "Weekly" {
            startDate = startDate.startOfWeek()
        } else if cycle == "Monthly" {
            startDate = startDate.startOfMonth()
        }
        switch habitType {
        case .number:
            var target: Int16 = -1
            if setTarget {
                target = Int16(targetNumber)
                setTargetCheckPoint(habitID: IdToBe, date: startDate, numberTarget: target)
            }
        case .time:
            var target = ""
            if setTarget {
                target = (targetHour * 60 + targetMinute).minutesToTime()
                setTargetCheckPoint(habitID: IdToBe, date: startDate, timeTarget: target)
            }
        default:
            break
        }
        //setStopCheckPoint(habitID: id, date: Date(), stopPointType: .go)
        if cycle == "Daily" {
            setStopCheckPoint(habitID: IdToBe, date: startDate, stopPointType: .go)
        } else if cycle == "Weekly" {
            setStopCheckPoint(habitID: IdToBe, date: startDate, stopPointType: .go) 
        } else if cycle == "Monthly" {
            setStopCheckPoint(habitID: IdToBe, date: startDate, stopPointType: .go)
        }
        saveChanges(viewContext: viewContext)
    }
    */
    /*
    private func getUniqueHabitID() -> Int64 {
        while true {
            let id = Int64.random(in: Int64.min...Int64.max)
            let request: NSFetchRequest<Habit> = Habit.fetchRequest()
            request.predicate = NSPredicate(format: "habitID == %@", "\(id)")
            do {
                let res = try container.viewContext.fetch(request)
                if res.count == 0 {
                    return id
                }
            }
            catch {
                continue
            }
        }
    }
     */
    private func checkHabitIdIsUnique(IdToBe: String) -> Bool {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
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
    
    func getAllHabits() -> [Habit] {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        do {
            let res = try container.viewContext.fetch(request)
            numberOfHabits = Int64(res.count)
            return res
        }
        catch {
            print("error")
            return []
        }
    }
}

extension HabitModel {
    func convertToStorageModel(context: NSManagedObjectContext) -> Habit {
        let newHabit = Habit(context: context)
        newHabit.type = self.type.rawValue
        newHabit.name = name
        newHabit.cycle = self.cycle.rawValue
        newHabit.createdDate = Date()
        newHabit.detail = detail
        newHabit.isTargetSet = true
        newHabit.numberUnit = unit
        newHabit.priority = priority
        newHabit.project = project
        newHabit.executionTime = executionTime
        return newHabit
    }
}


