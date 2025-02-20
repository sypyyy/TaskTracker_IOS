//
//  DataModels.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/24.
//

import Foundation
import CoreData

//Exg. "Morning/10:00~12:00"
typealias ExecutionTime = String

enum AmbiguousExecutionTime: String {
    case morning = "Morning", afternoon = "Afternoon", evening = "Evening", allDay = "AllDay"
    
    var sortOrder: Int {
            switch self {
            case .morning:
                return 1
            case .afternoon:
                return 2
            case .evening:
                return 3
            case .allDay:
                return 4
            }
        }
}

extension ExecutionTime {
    func getTimeArea() -> AmbiguousExecutionTime {
        if let timeAreaString = self.split(separator: "/").first {
            if let res = AmbiguousExecutionTime.init(rawValue: String(timeAreaString)) {
                return res
            }
        }
        return .allDay
    }
    
    func getDisplayStartString() -> String {
        if let timeAreaString = self.split(separator: "/").last, timeAreaString.contains("~"){
            let pair = timeAreaString.split(separator: "~")
            if pair.count == 2 {
                return (String(pair[0]))
            }
        }
        return getTimeArea().rawValue
    }
        
    func getStartEndTime() -> (String, String)? {
        if let timeAreaString = self.split(separator: "/").last, timeAreaString.contains("~") {
        let pair = timeAreaString.split(separator: "~")
            if pair.count == 2 {
                return (String(pair[0]), String(pair[1]))
            }
        }
        return nil
    }
    
    static func from(area: AmbiguousExecutionTime, startEnd: (String, String)?) -> String {
        var res = area.rawValue + "/"
        if let startEnd = startEnd {
            res += (startEnd.0 + "~" + startEnd.1)
        }
        return res
    }
}

enum TaskType: String {
    case habit = "Habit"
    case todo = "Todo"
}

class TaskModel: AnyTreeNode {
    var taskId: String
    let taskType: TaskType
    let mPriority: Int
    let mExecutionTime: ExecutionTime
    let goal: GoalModel?
    init(taskId: String, taskType: TaskType, priority: Int, executionTime: String = "", goal: GoalModel?) {
        self.goal = goal
        self.taskId = taskId
        self.taskType = taskType
        self.mPriority = priority
        self.mExecutionTime = executionTime
        var levelAsTreeNode = 0
        if let goal = goal {
            levelAsTreeNode = goal.level + 1
        }
        super.init(id: taskId, children: [], isExpanded: false, parent: nil, level: levelAsTreeNode, originalType: taskType == .habit ? TreeNodeSubclassInfo.habit : .todo, orderIdx: 0)
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

    var createdDate : Date
    
    var priority: Int16 = 0
    
    var executionTime: String = ""
    
    var type: HabitType
    
    var detail : String
    
    var cycle: HabitCycle
    
    var unit: String
    
    var numberTarget: Int16?
    
    var timeTarget: String? = "0:00"
    
    var numberProgress: Int16?
    
    var timeProgress: String?
    
    var done: Bool?
    
    init(habit: Habit) {
        self.name = habit.name ?? ""
        self.createdDate = habit.createdDate ?? Date()
        self.type = HabitType(rawValue: habit.type ?? "Simple") ?? .simple
        self.detail = habit.detail ?? ""
        self.cycle = HabitCycle(rawValue: habit.cycle ?? "Daily") ?? .daily
        self.unit = habit.numberUnit ?? ""
        self.executionTime = habit.executionTime ?? ""
        self.priority = habit.priority
        var goalModel: GoalModel? = nil
        if let goal = habit.goal {
            goalModel = GoalModel(goal: goal, traverseTasks: false)
        }
        super.init(taskId: (habit.id ?? ""), taskType: .habit, priority: Int(habit.priority), executionTime: habit.executionTime ?? "", goal: goalModel)
    }
    
    //Empty placeHolder init
    init() {
        self.name = ""
        self.createdDate = Date()
        self.type = .simple
        self.detail = ""
        self.cycle = .daily
        self.unit = ""
        super.init(taskId: "", taskType: .habit, priority: Int(priority), executionTime: executionTime, goal: nil)
    }
    
    //init every field
    init(name: String, id: String, createdDate: Date, type: HabitType, numberTarget: Int16, timeTarget: String, detail: String, cycle: HabitCycle, unit: String, priority: Int16, executionTime: ExecutionTime) {
        self.name = name
        self.createdDate = createdDate
        self.type = type
        self.numberTarget = numberTarget
        self.timeTarget = timeTarget
        self.detail = detail
        self.cycle = cycle
        self.unit = unit
        self.priority = priority
        self.executionTime = executionTime
        super.init(taskId: id, taskType: .habit, priority: Int(priority), executionTime: executionTime, goal: nil)
    }
}


class TodoModel: TaskModel{
    static func getInitialTodoModel() -> TodoModel {
        return TodoModel()
    }
    var name: String
    var note : String
    var priority: TodoPriority
    
    var executionTime: String
    var startDate: Date
    var isTimeSpecific: Bool
    var scheduleTime: String {
        //gets the hour and minute from startDate and return the "xx:xx" format
        fmt12.string(from: startDate)
    }
    
    var hasReminder: Bool
    var reminderDate: Date
    var reminderTime: String {
        ""
    }
    
    var expireDate: Date = Date()
    
    
    //如果为空就是“”
    var parentTaskId: String
    
    var hasParent: Bool {
        parentTaskId != ""
    }
    var subTasks: [TodoModel] = []
    
    //如果为空就是“”
    var subTaskString: String
    
    var hasSubTasks: Bool {
        !subTasks.isEmpty
    }
    
    var done: Bool
    var completeDate: Date = Date()
    
    init(todo: Todo) {
        self.name = todo.name ?? ""
        self.isTimeSpecific = todo.isTimeSpecific
        self.startDate = todo.startDate ?? Date()
        
        self.hasReminder = todo.hasReminder
        self.reminderDate = todo.reminderDate ?? Date()
        self.expireDate = todo.expireDate ?? Date()
        self.note = todo.note ?? ""
        self.subTasks = TodoModel.getTaskModels(s: todo.subTasks ?? "")
        self.subTaskString = todo.subTasks ?? ""
        self.done = todo.done
        self.parentTaskId = todo.parentTaskId ?? ""
        self.priority = TodoPriority(rawValue: Int(todo.priority)) ?? .none
        self.executionTime = todo.executionTime ?? ""
        var goalModel: GoalModel? = nil
        if let goal = todo.goal {
            goalModel = GoalModel(goal: goal, traverseTasks: false)
        }
        super.init(taskId: (todo.id ?? ""), taskType: .todo, priority: priority.rawValue, executionTime: executionTime, goal: goalModel)
        
    }
    
    static func getTaskModels(s: String) -> [TodoModel] {
        []
    }
    
    //Empty placeHolder init
    init() {
        self.name = ""
        self.isTimeSpecific = true
        self.startDate = Date()
        self.hasReminder = false
        self.reminderDate = Date()
        self.expireDate = Date()
        self.note = ""
        self.subTasks = []
        self.subTaskString = ""
        self.done = false
        self.completeDate = Date()
        self.parentTaskId = ""
        self.priority = .none
        self.executionTime = ""
        super.init(taskId: "", taskType: .todo, priority: priority.rawValue, executionTime: executionTime, goal: nil)
    }
    
}


