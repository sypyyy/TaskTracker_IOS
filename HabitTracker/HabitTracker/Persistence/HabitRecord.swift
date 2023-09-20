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
        let request: NSFetchRequest<HabitRecord> = HabitRecord.fetchRequest()
        if let id = habitID {
            request.predicate = NSPredicate(format: "date == %@ && habitID == \(id)", date as CVarArg)
        } else {
            request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        }
        do {
            let res = try container.viewContext.fetch(request)
            //numberOfHabits = Int64(res.count)
            records += res
        }
        catch {
            print("error")
            return records
        }
        let startOfWeek = date.startOfWeek()
        //if date is already startOfWeek, then do not append date's records again.
        if startOfWeek != date {
            request.predicate = NSPredicate(format: "date == %@", startOfWeek as CVarArg)
            do {
                let res = try container.viewContext.fetch(request)
                //numberOfHabits = Int64(res.count)
                records += res
            }
            catch {
                print("error")
                return records
            }
        }
        let startOfMonth = date.startOfMonth()
        if startOfWeek != startOfMonth {
            request.predicate = NSPredicate(format: "date == %@", startOfMonth as CVarArg)
            do {
                let res = try container.viewContext.fetch(request)
                //numberOfHabits = Int64(res.count)
                records += res
            }
            catch {
                print("error")
                return records
            }
        }
        return records
    }
    
    func createAndUpdateRecord(date: Date, habitID: Int64, habitType: HabitType, numberProgress: Int16 = 0, timeProgress: String = "", done: Bool = false) {
        let originalRecords = getDayRecords(date: date, habitID: habitID)
        let context = container.viewContext
        for originalRecord in originalRecords {
            context.delete(originalRecord)
        }
        let newRecord = HabitRecord(context: context)
        newRecord.habitID = habitID
        newRecord.date = date
        newRecord.numberProgress = numberProgress
        newRecord.timeProgress = timeProgress
        newRecord.done = done
        saveChanges(viewContext: context)
    }
}
