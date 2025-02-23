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
    func createTodo(dataModel: TodoModel) -> CreateTodoResult {
        //let result = habitController(inMemory: true)
        //let viewContext = result.container.viewContext
        let viewContext = self.container.viewContext
        let newTodo = dataModel.convertToStorageModel(context: viewContext)
        let id = dataModel.calculateId()
        let isIdUnique = checkTodoIdIsUnique(IdToBe: id)
        if !isIdUnique {
            viewContext.delete(newTodo)
            return .Duplicate
        }
        newTodo.id = id
        saveChanges(viewContext: viewContext)
        return .Success
    }
    
    func modifyTodo(dataModel: TodoModel) {
        if let todo = getTodoById(id: dataModel.id) {
            let viewContext = self.container.viewContext
            dataModel.updateStorageModel(todo: todo)
            saveChanges(viewContext: viewContext)
        }
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
        //"startDate >= %@ && ((willExpire && expireDate < %@) || !willExpire)"
        request.predicate = NSPredicate(format: "startDate >= %@ && startDate < %@", day.startOfDay() as CVarArg, day.endOfDay() as CVarArg)
        do {
            let res = try container.viewContext.fetch(request)
            return res
        }
        catch {
            print("error fetching")
            return []
        }
    }
    
    func getAllTodos() -> [Todo] {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
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
    
    func getTodoById(id: String) -> Todo? {
        let request: NSFetchRequest<Todo> = Todo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", "\(id)")
        do {
            let res = try container.viewContext.fetch(request)
            return res.first
        }
        catch {
            print("error fetching")
            return nil
        }
    }
    
    func setGoalForTodo(goalId: String, todoId: String) {
        if let todo = getTodoById(id: todoId) {
            let goal = getGoalById(id: goalId)
            let viewContext = self.container.viewContext
            todo.goal = goal
            saveChanges(viewContext: viewContext)
        }
    }
    
    func resetGoalForTodo(todoId: String) {
        if let todo = getTodoById(id: todoId) {
            let viewContext = self.container.viewContext
            todo.goal = nil
            saveChanges(viewContext: viewContext)
        }
        
    }
}


extension TodoModel {
    func convertToStorageModel(context: NSManagedObjectContext) -> Todo {
        let res = Todo.init(context: context)
        updateStorageModel(todo: res)
        return res
    }
    
    func updateStorageModel(todo: Todo) {
        todo.name = name
        todo.startDate = startDate
        todo.hasReminder = hasReminder
        todo.reminderDate = reminderDate
        todo.expireDate = expireDate
        todo.note = note
        todo.goal = goal?.storageModel
        todo.parentTaskId = parentTaskId
        todo.subTasks = subTaskString
        todo.done = done
        todo.priority = Int16(priority.rawValue)
        todo.executionTime = executionTime
    }
}

extension TodoModel {
    func calculateId() -> String {
        return "\(fmt_timeStamp.string(from: Date()))<#$>\(UUID().uuidString)"
    }
}
