//
//  HabitTrackerViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/4/22.
//

import Foundation
import CoreData

@MainActor class habitTrackerViewModel : ObservableObject{
    private var overalModel : habitTrackerModel = habitTrackerModel()
    private var habitModel : habitController = habitController.preview
    private var showCreateHabitForm : Bool = false
    var showCreateForm : Bool {
        get{
            return showCreateHabitForm
        }
        set {
            showCreateHabitForm = newValue
            //print("settttt")
            objectWillChange.send()
        }
    }
    var test : Int {
        //print("restarted")
        return 1
    }
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
    func getHabits() -> [habitViewModel] {
        for habit in habitModel.getAllHabits().map(habitViewModel.init) {
            //print(habit.name ?? "")
        }
        return habitModel.getAllHabits().map(habitViewModel.init)
    }
    
    func saveHabit(name: String, detail: String, habitType: String, cycle: String, targetNumber: String, targetUnit: String,
                   targetHour: Int, targetMinute: Int) {
        habitModel.createHabit(name: name, detail: detail, habitType: habitType, cycle: cycle, targetNumber: targetNumber, targetUnit: targetUnit, targetHour: targetHour, targetMinute: targetMinute)
        showCreateForm = false
        objectWillChange.send()
        //print("saved a new habit")
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

struct habitViewModel {
    let habit : Habit
    var name : String {
        return habit.name ?? ""
    }
    var id : String {
        habit.habitID ?? ""
    }
    var createdDate : Date {
        habit.createdDate ?? Date()
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
