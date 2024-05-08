//
//  List.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/4/14.
//

import CoreData

enum CreateListResult {
    case Success,Error
}

extension PersistenceController  {
    func createList(dataModel: ListModel) -> String {
        //let result = habitController(inMemory: true)
        //let viewContext = result.container.viewContext
        let viewContext = self.container.viewContext
        let newList = dataModel.convertToStorageModel(context: viewContext)
        saveChanges(viewContext: viewContext)
        return ""
    }
    
    func getAllRootLists() -> [TaskList] {
        let request: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "orderIdx", ascending: true)]
        request.predicate = NSPredicate(format: "level == %@", "0")
        do {
            let res = try container.viewContext.fetch(request)
            return res
        }
        catch {
            print("error fetching")
            return []
        }
    }
}


extension ListModel {
    func convertToStorageModel(context: NSManagedObjectContext) -> TaskList {
        let res = TaskList.init(context: context)
        res.name = name
        res.level = Int16(level)
        res.id = calculateId()
        res.orderIdx = Int16(orderIdx)
        return res
    }
}

extension ListModel {
    func calculateId() -> String {
        return "\(fmt_timeStamp.string(from: Date()))<#$>\(UUID().uuidString)"
    }
}
