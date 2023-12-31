//
//  DataModels.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/24.
//

import Foundation
import CoreData

enum TaskType: String {
    case habit = "Habit"
    case todo = "Todo"
}

class TaskModel {
    var taskId: String
    let taskType: TaskType
    
    init(taskId: String, taskType: TaskType) {
        self.taskId = taskId
        self.taskType = taskType
    }
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
    
    var id : String {
        didSet {
            taskId = id
        }
    }
    
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
        super.init(taskId: id, taskType: .habit)
    }
    
    //Empty placeHolder init
    init() {
        self.name = ""
        self.id = ""
        self.createdDate = Date()
        self.type = .simple
        self.detail = ""
        self.cycle = .daily
        self.unit = ""
        super.init(taskId: id, taskType: .habit)
    }
    
}

class TodoModel: TaskModel{
    var name: String
    var id: String {
        didSet {
            taskId = id
        }
    }
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
    var subTasks: [TodoModel] = []
    
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
        self.subTasks = TodoModel.getTaskModels(s: todo.subTasks ?? "")
        self.subTaskString = todo.subTasks ?? ""
        self.done = todo.done
        self.parentTaskId = todo.parentTaskId ?? ""
        self.priority = Int(todo.priority)
        super.init(taskId: id, taskType: .todo)
    }
    
    static func getTaskModels(s: String) -> [TodoModel] {
        []
    }
    
    //Empty placeHolder init
    init() {
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
        super.init(taskId: id, taskType: .todo)
    }
    
}

