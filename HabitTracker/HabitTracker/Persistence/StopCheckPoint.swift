//
//  Record.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/6/18.
//

import CoreData

enum StopPointType: Int16 {
    case stop = 0
    case go = 1
}

extension PersistenceController {
    
    internal func getStopCheckPoints(habitID: String) -> [StopCheckPoint] {
        if(!Thread.isMainThread) {
            print("Bad thread for coreData!!!!!!!!!!!! getStopCheckPoints")
        }
        let request: NSFetchRequest<StopCheckPoint> = StopCheckPoint.fetchRequest()
        var sortByTime = NSSortDescriptor(key:"date", ascending:true)
        request.sortDescriptors = [sortByTime]
        request.predicate = NSPredicate(format: "habitID == %@", "\(habitID)")
        do {
            let checkpoints = try container.viewContext.fetch(request)
            return checkpoints
        }
        catch {
            print("error")
            return []
        }
    }
    
    internal func setStopCheckPoint(habitID: String, date: Date, stopPointType: StopPointType) {
        if(!Thread.isMainThread) {
            print("Bad thread for coreData!!!!!!!!!!!! setStopCheckPoint")
        }
        let viewContext = self.container.viewContext
        let newStopPoint = StopCheckPoint(context: viewContext)
        newStopPoint.date = date
        newStopPoint.habitID = habitID
        newStopPoint.type = stopPointType.rawValue
        //saveChanges(viewContext: viewContext)
    }
}


