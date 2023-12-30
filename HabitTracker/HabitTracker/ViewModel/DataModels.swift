//
//  DataModels.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/24.
//

import Foundation
import CoreData

class TaskModel {
    
}

enum HabitType: String {
    case number = "Number"
    case time = "Time"
    case simple = "Simple"
}

enum HabitCycle: String {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

class HabitModel: TaskModel {
    var name : String
    
    var id : String
    
    var createdDate : Date
    
    var type: HabitType
    
    var detail : String
    
    var cycle: HabitCycle
    
    var unit: String
    
    var numberTarget: Int16?
    
    var timeTarget: String?
    
    var numberProgress: Int16?
    
    var timeProgress: String?
    
    var done: Bool?
    
    init(habit: Habit) {
        self.name = habit.name ?? ""
        self.id = habit.id ?? ""
        self.createdDate = habit.createdDate ?? Date()
        self.type = HabitType(rawValue: habit.type ?? "Simple") ?? .simple
        self.detail = habit.detail ?? ""
        self.cycle = HabitCycle(rawValue: habit.cycle ?? "Daily") ?? .daily
        self.unit = habit.numberUnit ?? ""
    }
    
}

class ToDoModel: TaskModel{
    var name: String
    var id: String
    var priority: Int
    
    var scheduleDate: Date
    var isTimeSpecific: Bool
    var scheduleTime: String {
        ""
    }
    
    var hasReminder: Bool
    var reminderDate: Date = Date()
    var reminderTime: String {
        ""
    }
    
    var willExpire: Bool
    var expireDate: Date = Date()
    
    var note : String
    
    var parentTaskId: String
    
    var hasParent: Bool {
        parentTaskId != ""
    }
    var subTasks: [ToDoModel] = []
    
    var subTaskString: String
    
    var hasSubTasks: Bool {
        !subTasks.isEmpty
    }
    
    var done: Bool
    var completeDate: Date = Date()
    
    init(todo: Todo) {
        self.name = todo.name ?? ""
        self.id = todo.id ?? ""
        
        self.isTimeSpecific = todo.isTimeSpecific
        self.scheduleDate = todo.scheduleDate ?? Date()
        
        self.hasReminder = todo.hasReminder
        if(hasReminder) {
            self.reminderDate = todo.reminderDate ?? Date()
        }
        self.willExpire = todo.willExpire
        if(willExpire) {
            self.expireDate = todo.expireDate ?? Date()
        }
        self.note = todo.note ?? ""
        self.subTasks = ToDoModel.getTaskModels(s: todo.subTasks ?? "")
        self.subTaskString = todo.subTasks ?? ""
        self.done = todo.done
        self.parentTaskId = todo.parentTaskId ?? ""
        self.priority = Int(todo.priority)
    }
    
    static func getTaskModels(s: String) -> [ToDoModel] {
        []
    }
    
    override init() {
        self.name = ""
        self.id = ""
        self.isTimeSpecific = true
        self.scheduleDate = Date()
        self.hasReminder = false
        self.reminderDate = Date()
        self.willExpire = false
        self.expireDate = Date()
        self.note = ""
        self.subTasks = []
        self.subTaskString = ""
        self.done = false
        self.completeDate = Date()
        self.parentTaskId = ""
        self.priority = 0
    }
}

