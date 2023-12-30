//
//  HabitTarget.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/6/24.
//

import CoreData

extension PersistenceController {
    
    
    func getTargetSeries(habitID: String) -> [TargetCheckPoint] {
        if(!Thread.isMainThread) {
            print("Bad thread for coreData!!!!!!!!!!!! getTargetSeries")
        }
        let request: NSFetchRequest<TargetCheckPoint> = TargetCheckPoint.fetchRequest()
        var sortByTime = NSSortDescriptor(key:"date", ascending:true)
        request.sortDescriptors = [sortByTime]
        request.predicate = NSPredicate(format: "habitID == %@", "\(habitID)")
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
    
    internal func setTargetCheckPoint(habitID: String, date: Date, numberTarget: Int16 = -1, timeTarget: String = "") {
        if(!Thread.isMainThread) {
            print("Bad thread for coreData!!!!!!!!!!!! setTargetCheckPoint")
        }
        let viewContext = self.container.viewContext
        let newCheckPoint = TargetCheckPoint(context: viewContext)
        newCheckPoint.date = date
        newCheckPoint.habitID = habitID
        newCheckPoint.numberTarget = numberTarget
        newCheckPoint.timeTarget = timeTarget
        //saveChanges(viewContext: viewContext)
    }
}

