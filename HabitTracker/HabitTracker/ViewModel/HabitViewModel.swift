//
//  TaskMasterViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/27.
//

import Foundation

@MainActor
class HabitViewModel: ObservableObject {
    static var shared = HabitViewModel()
    private var parentModel = MasterViewModel.shared
    private var persistenceModel : PersistenceController = PersistenceController.preview
    
    private var selectedDate: Date = Date()
    
    //Cache
    //MARK: 注意有变动及时清缓存！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    private var stopCheckPoints = [Int64: [StopCheckPoint]]()
    private var allHabits: [Habit]?
    private var targetSeries = [Int64: [TargetCheckPoint]]()
    private var recordsOfSelectedDate: [HabitRecord]?
}

//日期相关的操作
extension HabitViewModel {
    
    func selectDate(date: Date) {
        selectedDate = date
        recordsOfSelectedDate = nil
        //objectWillChange.send()
    }
}

//获取打卡信息相关的
extension HabitViewModel {
    
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
                //This check is because record also return dates of start of month and week.
                if habit.cycle == .daily && records[habit.id]?.date?.compareToByDay(selectedDate) != 0 {
                    habit.numberProgress = 0
                    break
                }
                habit.numberProgress = records[habit.id]?.numberProgress ?? 0
                habit.done = habit.numberProgress == habit.numberTarget
            case .time:
                habit.timeTarget = latestTarget?.timeTarget
                if habit.cycle == .daily && records[habit.id]?.date?.compareToByDay(selectedDate) != 0 {
                    habit.timeProgress = "0:00"
                    break
                }
                habit.timeProgress = records[habit.id]?.timeProgress  ?? "0:00"
                habit.done = habit.timeProgress?.timeToMinutes() == habit.timeTarget?.timeToMinutes()
            case .simple:
                if habit.cycle == .daily && records[habit.id]?.date?.compareToByDay(selectedDate) != 0 {
                    habit.done = false
                    break
                }
                habit.done = records[habit.id]?.done ?? false
                
            }
            print("\(records[habit.id])")
        }
        
        return habits
    }
}

//创建新习惯
extension HabitViewModel {
    
    func saveHabit(habitModel: HabitModel) {
        do {try persistenceModel.creatNewHabit(habit: habitModel)}catch {
            print("Duplicate Names!")
        }
        parentModel.showCreateForm = false
        allHabits = nil
        objectWillChange.send()
        //print("saved a new habit")
        parentModel.statDataChanged = true
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


extension HabitViewModel {
    
    //制造一个新的打卡记录，日期使用当前选择的日期，同时检查并且删除之前存在的记录。
    func createRecord(habitID: String, habitType: HabitType, habitCycle: HabitCycle, numberProgress: Int16 = 0, timeProgress: String = "", done: Bool = false) {
        recordsOfSelectedDate = nil
        persistenceModel.createAndUpdateRecord(date: selectedDate, habitID: habitID, habitType: habitType, habitCycle: habitCycle, numberProgress: numberProgress, timeProgress: timeProgress, done: done)
        objectWillChange.send()
        parentModel.didReceiveChangeMessage(msg: .taskStateChanged)
        parentModel.statDataChanged = true
    }
}

