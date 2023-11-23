//
//  HabitTrackerViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/4/22.
//

import Foundation
import CoreData
import SwiftUI

enum HabitTabShowType: Int {
    case initial = 0, checkIn = 1, statistical = 2, setting = 3
}

class HabitTrackerViewModel : ObservableObject{
   
    static var shared = HabitTrackerViewModel()
    //sypppppp
    private var overalModel : habitTrackerModel = habitTrackerModel()
    private var persistenceModel : HabitController = HabitController.preview
    private var showCreateHabitForm : Bool = false
    
    public var tabIndex: HabitTabShowType = .initial
    public var selectedDate: Date = Date()
    
    public var nowShowing: HabitTabShowType = .initial
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
    
    //Cache
    //MARK: 注意有变动及时清缓存！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    private var stopCheckPoints = [Int64: [StopCheckPoint]]()
    private var allHabits: [Habit]?
    private var targetSeries = [Int64: [TargetCheckPoint]]()
    private var recordsOfSelectedDate: [HabitRecord]?
    
    
    
    var showCreateForm : Bool {
        get {
            return showCreateHabitForm
        }
        set {
            showCreateHabitForm = newValue
            objectWillChange.send()
        }
    }
    
    var test : Int {
        //print("restarted")
        return 1
    }
}

//日期相关的操作
extension HabitTrackerViewModel {
    
    //这三个函数需要改成从habit controller拿数据
    func getTodayDate() -> Date {
        //print("tttttt")
        return overalModel.today
    }
    func getStartDate() -> Date {
        overalModel.startDate
    }
    func refreshDate() {
        overalModel.refreshDate()
        //print("date refreshed")
        objectWillChange.send()
    }
    
    func selectDate(date: Date) {
        selectedDate = date
        recordsOfSelectedDate = nil
        objectWillChange.send()
        print("syppppppppp")
    }
}

//获取打卡信息相关的
extension HabitTrackerViewModel {
    
    //获取所有当前选中日期的打卡记录 （cached）
    func getDayRecords() -> [Int64: HabitRecord] {
        var records: [HabitRecord]
        var res = [Int64: HabitRecord]()
        if var cachedRecords = recordsOfSelectedDate {
            records = cachedRecords
        } else {
            records = persistenceModel.getDayRecords(date: selectedDate, habitID: nil)
            recordsOfSelectedDate = records
        }
        for record in recordsOfSelectedDate ?? [] {
            res[record.habitID] = record
        }
        return res
    }
    
    func getTargetSeries(habitID: Int64) -> [TargetCheckPoint] {
        //syppp test
        //let res = persistenceModel.getTargetSeries(habitID: habitID)
        //return res
        return []
    }
    
    func getStopCheckPoints(habitID: Int64) -> [StopCheckPoint] {
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
            let stopPoints = persistenceModel.getStopCheckPoints(habitID: habit.habitID)
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
    
    func getOngoingHabitViewModels() -> [habitViewModel] {
        var habits: [habitViewModel] = getOngoingHabitsPrimitive().map(habitViewModel.init)
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
                print("fnskjjfs")
            }
        }
        
        return habits
    }
}

//创建新习惯
extension HabitTrackerViewModel {
    
    func saveHabit(name: String, detail: String, habitType: HabitType, cycle: String, targetNumber: Int, targetUnit: String,
                   targetHour: Int, targetMinute: Int, setTarget: Bool) {
        persistenceModel.createHabit(name: name, detail: detail, habitType: habitType, cycle: cycle, targetNumber: targetNumber, numberUnit: targetUnit, targetHour: targetHour, targetMinute: targetMinute, setTarget: setTarget)
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


extension HabitTrackerViewModel {
    
    //制造一个新的打卡记录，日期使用当前选择的日期，同时检查并且删除之前存在的记录。
    func createRecord(habitID: Int64, habitType: HabitType, habitCycle: HabitCycle, numberProgress: Int16 = 0, timeProgress: String = "", done: Bool = false) {
        recordsOfSelectedDate = nil
        persistenceModel.createAndUpdateRecord(date: selectedDate, habitID: habitID, habitType: habitType, habitCycle: habitCycle, numberProgress: numberProgress, timeProgress: timeProgress, done: done)
        objectWillChange.send()
        statDataChanged = true
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

class habitViewModel {
    let habit : Habit
    
    var name : String {
        return habit.name ?? ""
    }
    
    var id : Int64 {
        habit.habitID
    }
    
    var createdDate : Date {
        habit.createdDate ?? Date()
    }
    
    var type: HabitType {
        HabitType(rawValue: habit.type ?? "Simple") ?? .simple
    }
    
    var detail : String {
        habit.detail ?? ""
    }
    
    var cycle: HabitCycle {
        HabitCycle(rawValue: habit.cycle ?? "Daily") ?? .daily
    }
    
    var unit: String {
        habit.numberUnit ?? ""
    }
    
    var numberTarget: Int16?
    
    var timeTarget: String?
    
    var numberProgress: Int16?
    
    var timeProgress: String?
    
    var done: Bool?
    
    init(habit: Habit) {
        self.habit = habit
    }
    
}

/*
 struct timeBasedHabitViewModel {
 let timeTarget : String
 var current : String {
 return habit.name ?? ""
 }
 var id : String {
 habit.habitID ?? ""
 }
 }
 */
