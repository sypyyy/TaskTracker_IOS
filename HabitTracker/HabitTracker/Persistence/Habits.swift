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
    func createHabit(name: String, detail: String, habitType: HabitType, cycle: String, targetNumber: Int, numberUnit: String,
                            targetHour: Int, targetMinute: Int, setTarget: Bool = true) throws {
        //let result = habitController(inMemory: true)
        //let viewContext = result.container.viewContext
        let viewContext = self.container.viewContext
        let newHabit = Habit(context: viewContext)
        let IdToBe = name
        let isNameUnique = checkHabitIdIsUnique(IdToBe: name)
        if !isNameUnique {
            throw PersistenceError.duplicateId
        }
        newHabit.type = habitType.rawValue
        newHabit.name = name
        newHabit.cycle = cycle
        newHabit.index = numberOfHabits + 1
        newHabit.createdDate = Date()
        newHabit.detail = detail
        newHabit.isTargetSet = setTarget
        newHabit.id = IdToBe
        newHabit.numberUnit = numberUnit
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
            setStopCheckPoint(habitID: IdToBe, date: Date(), stopPointType: .go)
        } else if cycle == "Weekly" {
            setStopCheckPoint(habitID: IdToBe, date: Date().startOfWeek(), stopPointType: .go)
        } else if cycle == "Monthly" {
            setStopCheckPoint(habitID: IdToBe, date: Date().startOfMonth(), stopPointType: .go)
        }
        saveChanges(viewContext: viewContext)
    }
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


