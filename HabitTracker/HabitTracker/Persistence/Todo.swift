//
//  Todo.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/24.
//

import Foundation
import CoreData

enum CreateTodoResult {
    case Success,Duplicate
}

extension PersistenceController  {
    func createTodo(dataModel: ToDoModel) -> CreateTodoResult {
        //let result = habitController(inMemory: true)
        //let viewContext = result.container.viewContext
        let viewContext = self.container.viewContext
        let newTodo = dataModel.convertToStorageModel(context: viewContext)
        let id = dataModel.id
        let isIdUnique = checkTodoIdIsUnique(IdToBe: id)
        if !isIdUnique {
            viewContext.delete(newTodo)
            return .Duplicate
        }
        saveChanges(viewContext: viewContext)
        return .Success
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
    private func checkTodoIdIsUnique(IdToBe: String) -> Bool {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
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
    
    func getTodoOfDay(day: Date) -> [Todo] {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "scheduledDate >= %@ && ((willExpire && expireDate < %@) || !willExpire)", day.startOfDay() as CVarArg, day.endOfDay() as CVarArg)
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


extension ToDoModel {
    func convertToStorageModel(context: NSManagedObjectContext) -> Todo {
        var formatter: DateFormatter {
            let fmt = DateFormatter()
            fmt.dateFormat = isTimeSpecific ? "yyyy/MM/dd/HH:mm" : "yyyy/MM/dd"
            return fmt
        }
        let res = Todo.init(context: context)
        res.name = name
        
        //Calculate id based on the name and scheduledDate
        let id = "\(name)<#$>\(formatter.string(from: scheduleDate))"
        res.id = id
        self.id = id
        
        res.scheduleDate = scheduleDate
        res.priority = Int16(priority)
        res.hasReminder = hasReminder
        res.reminderDate = reminderDate
        res.willExpire = willExpire
        res.expireDate = expireDate
        res.note = note
        res.parentTaskId = parentTaskId
        res.subTasks = subTaskString
        res.done = done
        return res
    }
}
