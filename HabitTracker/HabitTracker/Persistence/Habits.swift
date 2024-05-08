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
        let IdToBe = "\(fmt_timeStamp.string(from: Date()))<#$>\(UUID().uuidString)"
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


