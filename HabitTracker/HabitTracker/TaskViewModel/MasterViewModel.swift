//
//  HabitTrackerViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/4/22.
//

import Foundation
import CoreData
import SwiftUI

enum ChangeMessage {
    case dateSelected, taskStateChanged, taskCreated, sortChanged(TaskTableSortBy), taskSelected
    case taskGoalSet
    case startOfWeekChanged
    case goalCRUD
}

@MainActor
protocol ChangeListener {
    var listenerId: String { get }
    func didUpdate(msg: ChangeMessage)
}

enum AppTabShowType: Int {
    case goals = 0, habits = 1, checkIn = 2, statistical = 3, setting = 4
}

enum TaskTabFilterMode {
    case inbox, schedule, habit, goals, labels
}

@MainActor
class MasterViewModel: ObservableObject{
    @MainActor
    static var shared = MasterViewModel()
    private var overalModel : habitTrackerModel = habitTrackerModel()
    private var persistenceModel : PersistenceController = PersistenceController.preview
    //MARK: Child ViewModels
    private var habitViewModel: HabitViewModel {
        HabitViewModel.shared
    }
    private var todoViewModel: TodoViewModel {
        TodoViewModel.shared
    }
    
    //MARK: Registered Listeners
    private var listeners =  [ChangeListener]()
    
    private var showCreateHabitForm : Bool = false
    
    public var tabIndex: AppTabShowType = .habits
    
    public var currentTaskFilterMode: TaskTabFilterMode = .schedule
    
    public var selectedDate: Date = Date()
    
    //这个可能可以删除了
    public var tappedTaskId: String?
    
    
    
    @MainActor func selectTask(taskId: String) {
        if tappedTaskId == taskId {
            tappedTaskId = nil
        } else {
            tappedTaskId = taskId
        }
        self.objectWillChange.send()
        
        self.didReceiveChangeMessage(msg: .taskSelected)
        
    }
    
    //MARK: sort by
    public var sortBy = TaskTableSortBy.time
    
    @MainActor func sortBy(by: TaskTableSortBy) {
        sortBy = by
        self.didReceiveChangeMessage(msg: .sortChanged(by))
        objectWillChange.send()
    }
    
    ///模糊主视图
    public var blurEverything = false {
        didSet {
            objectWillChange.send()
        }
    }
    ///是否有数据改变
    public var statDataChanged = false {
        didSet {
            if statDataChanged {
                HabitTrackerStatisticViewModel.shared.respondToDataChange()
            }
        }
    }

    var showCreateForm : Bool {
        get {
            return showCreateHabitForm
        }
        set {
            showCreateHabitForm = newValue
            objectWillChange.send()
        }
    }
}


//更新有关的Listener
extension MasterViewModel {
    public func didReceiveChangeMessage(msg: ChangeMessage) {
        updateListeners(msg: msg)
    }
    public func registerListener(listener: ChangeListener) {
        listeners.append(listener)
    }
    
    public func removeListener(targetId: String) {
        listeners.removeAll { listener in
            listener.listenerId == targetId
        }
    }
    
    private func updateListeners(msg: ChangeMessage) {
        for listener in listeners {
            listener.didUpdate(msg: msg)
        }
    }
}

//日期相关的操作
extension MasterViewModel {
    
    //这三个函数需要改成从habit controller拿数据
    func getTodayDate() -> Date {
        return overalModel.today
    }
    func getStartDate() -> Date {
        overalModel.startDate
    }
    func refreshDate() {
        overalModel.refreshDate()
        objectWillChange.send()
    }
    
    func selectDate(date: Date) {
        selectedDate = date
        habitViewModel.selectDate(date: date)
        todoViewModel.selectDate(date: date)
        didReceiveChangeMessage(msg: .dateSelected)
        //No need to send objectWillChange because child view models will do that.
    }
}


//Get task related info
extension MasterViewModel {
    func getDayTasks(date: Date? = nil) -> [TaskModel] {
        var res = [TaskModel]()
        res = habitViewModel.getOngoingHabitViewModels() + todoViewModel.getDaySpecificTodos(date: date ?? selectedDate)
        return res
    }
}

/*

//获取打卡信息相关的
extension TaskMasterViewModel {
    
    //获取所有当前选中日期的打卡记录 （cached）
    func getDayRecords() -> [String: HabitRecord] {
        var records: [HabitRecord]
        var res = [String: HabitRecord]()
        if var cachedRecords = recordsOfSelectedDate {
            records = cachedRecords
        } else {
            records = persistenceModel.getDayRecords(date: selectedDate, habitID: nil)
            recordsOfSelectedDate = records
        }
        for record in recordsOfSelectedDate ?? [] {
            if let id = record.habitID {
                res[id] = record
            }
        }
        return res
    }
    
    func getTargetSeries(habitID: String) -> [TargetCheckPoint] {
        //syppp test
        let res = persistenceModel.getTargetSeries(habitID: habitID)
        return res
    }
    
    func getStopCheckPoints(habitID: String) -> [StopCheckPoint] {
        /*
        if let points = self.stopCheckPoints[habitID] {
            return points
        }
         */
        let res = persistenceModel.getStopCheckPoints(habitID: habitID)
        //stopCheckPoints[habitID] = res
        return res
    }
    
    func getAllHabits() -> [Habit] {
        if var all = allHabits {
            return all
        }
        let res = persistenceModel.getAllHabits()
        allHabits = res
        return res
    }
    
    func getOngoingHabitsPrimitive() -> [Habit] {
        let allHabits = getAllHabits()
        var res = [Habit]()
        for habit in allHabits {
            let stopPoints = persistenceModel.getStopCheckPoints(habitID: habit.id ?? "")
            var latestPoint: StopCheckPoint?
            for point in stopPoints {
                if let date = point.date, date.compareToByDay(selectedDate) == 1 {
                    break
                }
                latestPoint = point
            }
            if let point = latestPoint {
                if point.type == StopPointType.go.rawValue {
                    res.append(habit)
                }
            }
        }
        return res
    }
    
    func getOngoingHabitViewModels() -> [HabitModel] {
        var habits: [HabitModel] = getOngoingHabitsPrimitive().map(HabitModel.init)
        let records = getDayRecords()
        for habit in habits {
            let targets = getTargetSeries(habitID: habit.id)
            var latestTarget: TargetCheckPoint?
            for target in targets {
                if let targetSetDate = target.date {
                    if targetSetDate.compareToByDay(selectedDate) == 1 {
                        break
                    }
                    latestTarget = target
                }
            }
            switch habit.type {
            case .number:
                habit.numberTarget = latestTarget?.numberTarget
                if habit.cycle == .daily && records[habit.id]?.date?.compareToByDay(selectedDate) != 0 {
                    habit.numberProgress = 0
                    break
                }
                habit.numberProgress = records[habit.id]?.numberProgress
            case .time:
                habit.timeTarget = latestTarget?.timeTarget
                if habit.cycle == .daily && records[habit.id]?.date?.compareToByDay(selectedDate) != 0 {
                    habit.timeProgress = "0:00"
                    break
                }
                habit.timeProgress = records[habit.id]?.timeProgress
            case .simple:
                if habit.cycle == .daily && records[habit.id]?.date?.compareToByDay(selectedDate) != 0 {
                    habit.done = false
                    break
                }
                habit.done = records[habit.id]?.done
                print("\(records[habit.id])")
            }
        }
        
        return habits
    }
}

//创建新习惯
extension TaskMasterViewModel {
    
    func saveHabit(name: String, detail: String, habitType: HabitType, cycle: String, targetNumber: Int, targetUnit: String,
                   targetHour: Int, targetMinute: Int, setTarget: Bool) {
        do {try persistenceModel.createHabit(name: name, detail: detail, habitType: habitType, cycle: cycle, targetNumber: targetNumber, numberUnit: targetUnit, targetHour: targetHour, targetMinute: targetMinute, setTarget: setTarget)}catch {
            print("Duplicate Names!")
        }
        showCreateForm = false
        allHabits = nil
        objectWillChange.send()
        //print("saved a new habit")
        statDataChanged = true
    }

    /**
     
     @State var name: String = ""
     @State var detail: String = ""
     @State var habitType: String = "Time"
     @State var cycle: String = "Daily"
     @State var targetNumber: String = ""
     @State var targetUnit: String = ""
     @State var targetHour: Int = 1
     @State var targetMinute: Int = 31
     @State var dummy : String = ""
     
     
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: NSNotification.Name.NSCalendarDayChanged, object: nil)
        overalModel.refreshDate()
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        overalModel.refreshDate()
        print("date refreshed")
        objectWillChange.send()
    }
     */
    
}


extension TaskMasterViewModel {
    
    //制造一个新的打卡记录，日期使用当前选择的日期，同时检查并且删除之前存在的记录。
    func createRecord(habitID: String, habitType: HabitType, habitCycle: HabitCycle, numberProgress: Int16 = 0, timeProgress: String = "", done: Bool = false) {
        recordsOfSelectedDate = nil
        persistenceModel.createAndUpdateRecord(date: selectedDate, habitID: habitID, habitType: habitType, habitCycle: habitCycle, numberProgress: numberProgress, timeProgress: timeProgress, done: done)
        objectWillChange.send()
        statDataChanged = true
    }
}

*/
