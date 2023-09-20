//
//  Record.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/7/4.
//

import Foundation
import CoreData

extension HabitController {
    
    //get all the records of that day and also of the start of the week and month of that day
    func getDayRecords(date: Date, habitID: Int64?) -> [HabitRecord] {
        var records = [HabitRecord]()
        records += getSpecificDayRecords(date: date, habitID: habitID, cycle: .daily)
        let startOfWeek = date.startOfWeek().addByHour(12)
        let startOfMonth = date.startOfMonth().addByHour(12)
        //if date is already startOfWeek, then do not append date's records again.
        records += getSpecificDayRecords(date: startOfWeek, habitID: habitID, cycle: .weekly)
        records += getSpecificDayRecords(date: startOfMonth, habitID: habitID, cycle: .monthly)
        return records
    }
    
    func getSpecificDayRecords(date: Date, habitID: Int64?, cycle: HabitCycle) -> [HabitRecord] {
        let request: NSFetchRequest<HabitRecord> = HabitRecord.fetchRequest()
        if let id = habitID {
            request.predicate = NSPredicate(format: "date >= %@ && date < %@ && habitID == \(id) && cycle == %@", date.startOfDay() as CVarArg, date.endOfDay() as CVarArg, cycle.rawValue as CVarArg)
        } else {
            request.predicate = NSPredicate(format: "date >= %@ && date < %@ && cycle == %@", date.startOfDay() as CVarArg, date.endOfDay() as CVarArg, cycle.rawValue as CVarArg)
        }
        do {
            let res = try container.viewContext.fetch(request)
            //numberOfHabits = Int64(res.count)
            return res
        }
        catch {
            print("error")
            return []
        }
    }
    
    func getIntervalRecords(startDate: Date, endDate: Date, habitID: Int64? = nil) -> [HabitRecord] {
        var records = [HabitRecord]()
        let startOfWeek = startDate.startOfWeek()
        let request: NSFetchRequest<HabitRecord> = HabitRecord.fetchRequest()
        if let id = habitID {
            request.predicate = NSPredicate(format: "date >= %@ && date < %@ && habitID == \(id)", startOfWeek as CVarArg, endDate as CVarArg)
        } else {
            request.predicate = NSPredicate(format: "date >= %@ && date < %@", startOfWeek as CVarArg, endDate as CVarArg)
        }
        do {
            let res = try container.viewContext.fetch(request)
            records += res
        }
        catch {
            print("error")
            return records
        }
        return records
    }
    
    func createAndUpdateRecord(date: Date, habitID: Int64, habitType: HabitType, habitCycle: HabitCycle, numberProgress: Int16 = 0, timeProgress: String = "", done: Bool = false) {
        var dateToDelete: Date
        switch habitCycle {
        case .daily:
            dateToDelete = date
        case .weekly:
            dateToDelete = date.startOfWeek()
        case .monthly:
            dateToDelete = date.startOfMonth()
        }
        let originalRecords = getSpecificDayRecords(date: dateToDelete, habitID: habitID, cycle: habitCycle)
        let context = container.viewContext
        for originalRecord in originalRecords {
            context.delete(originalRecord)
        }
        let newRecord = HabitRecord(context: context)
        newRecord.habitID = habitID
        switch habitCycle {
        case .daily:
            newRecord.date = date
            newRecord.cycle = "Daily"
        case .weekly:
            newRecord.date = date.startOfWeek()
            newRecord.cycle = "Weekly"
        case .monthly:
            newRecord.date = date.startOfMonth()
            newRecord.cycle = "Monthly"
        }
        newRecord.numberProgress = numberProgress
        newRecord.timeProgress = timeProgress
        newRecord.done = done
        saveChanges(viewContext: context)

        
        
    }
}
