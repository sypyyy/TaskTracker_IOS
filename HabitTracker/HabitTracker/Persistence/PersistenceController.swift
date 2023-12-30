//
//  HabitController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/11.
//

import CoreData


class PersistenceController {
    static let shared = PersistenceController()
    static var preview: PersistenceController = {
        var result = PersistenceController(inMemory: false)
        let viewContext = result.container.viewContext
        var habits = result.getAllHabits()
        
        
        for habit in habits {
            viewContext.delete(habit)
        }
        saveChanges(viewContext: viewContext)
       
        print("deleted")
        for i in 1...120 {
            if(i == 1) {
                do {try result.createHabit(name: "Drink water #\(i)", detail: "blablabla", habitType: .number, cycle: "Daily", targetNumber: 10, numberUnit: "cups", targetHour: 0, targetMinute: 0, setTarget: true)} catch {print("")}
            }
            if(i == 2) {
                do {try result.createHabit(name: "Drink water but weekly #\(i)", detail: "blablabla", habitType: .number, cycle: "Weekly", targetNumber: 10, numberUnit: "cups", targetHour: 0, targetMinute: 0, setTarget: true)} catch {print("")}
            }
            if(i == 3) {
                do {try result.createHabit(name: "Drink water but monthly #\(i)", detail: "blablabla", habitType: .number, cycle: "Monthly", targetNumber: 10, numberUnit: "cups", targetHour: 0, targetMinute: 0, setTarget: true)} catch {print("")}
            }

            if(i == 4) {
                do {try result.createHabit(name: "Study #\(i)", detail: "blablabla", habitType: .time, cycle: "Daily", targetNumber: 0, numberUnit: "cup", targetHour: 1, targetMinute: 30, setTarget: true)} catch {print("")}
            }
            if(i == 5) {
                do {try result.createHabit(name: "Study but weekly #\(i)", detail: "blablabla", habitType: .time, cycle: "Weekly", targetNumber: 0, numberUnit: "cup", targetHour: 1, targetMinute: 30, setTarget: true)} catch {print("")}
            }
            if(i == 6) {
                do {try result.createHabit(name: "Study but monthly #\(i)", detail: "blablabla", habitType: .time, cycle: "Monthly", targetNumber: 0, numberUnit: "cup", targetHour: 1, targetMinute: 30, setTarget: true)} catch {print("")}
            }
            if(i == 7) {
                do {try result.createHabit(name: "Eat breakfast #\(i)", detail: "blablabla", habitType: .simple, cycle: "Daily", targetNumber: 0, numberUnit: "", targetHour: 0, targetMinute: 0, setTarget: true)} catch {print("")}
            }
            if(i == 8) {
                do {try result.createHabit(name: "Eat breakfast but weekly #\(i)", detail: "blablabla", habitType: .simple, cycle: "Weekly", targetNumber: 0, numberUnit: "", targetHour: 0, targetMinute: 0, setTarget: true)} catch {print("")}
            }
            if(i == 9) {
                do {try result.createHabit(name: "Eat breakfast but monthly #\(i)", detail: "blablabla", habitType: .simple, cycle: "Monthly", targetNumber: 0, numberUnit: "", targetHour: 0, targetMinute: 0, setTarget: true)} catch {print("")}
            }
            
            else {
                do {try result.createHabit(name: "Eat breakfast but monthly #\(i)", detail: "blablabla", habitType: .simple, cycle: "Monthly", targetNumber: 0, numberUnit: "", targetHour: 0, targetMinute: 0, setTarget: true)} catch {print("")}
            }
            
            print("saved")
            //saveChanges(viewContext: viewContext)
        }
        
        
        /*
        let newItem2 = Habit(context: viewContext)
        newItem2.name = "Play basketball"
        newItem2.createdDate = Date()
        let newItem3 = Habit(context: viewContext)
        newItem3.name = "Do homework and presentation"
        newItem3.createdDate = Date()
         */
        saveChanges(viewContext: viewContext)
        return result
    }()
    
    internal var numberOfHabits: Int64 = 0
    
    
    
    //MARK: delete this in production!!!!
    static func saveChanges(viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
            print("*******************saved******************")
        } catch {
            //Replace this implementation with code to handle the error appropriately.
            //fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func saveChanges(viewContext: NSManagedObjectContext) {
        do {
            try viewContext.save()
            print("*******************saved******************")
    
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    //MARK: for test delete when done
    //private static var numberOfHabits: Int64 = 0
    /*
    func createHabit(name: String, detail: String, habitType: String, cycle: String, targetNumber: Int, targetUnit: String,
                     targetHour: Int, targetMinute: Int, setTarget: Bool) {
        let viewContext = self.container.viewContext
        let newHabit = Habit(context: viewContext)
        newHabit.type = habitType
        newHabit.name = name
        newHabit.cycle = cycle
        newHabit.index = numberOfHabits + 1
        newHabit.createdDate = Date()
        newHabit.ended = false
        newHabit.detail = detail
        newHabit.isTargetSet = setTarget
        newHabit.habitID = name + String(newHabit.index)
        saveChanges(viewContext: viewContext)
        if(habitType == "Time") {
            let newTimeHabit = TimeBasedHabit(context: viewContext)
            newTimeHabit.target = String(targetHour) + ":" + String(targetMinute)
            newTimeHabit.habit = newHabit
            
        }
        else if habitType == "Number" {
            let newNumberHabit = NumberBasedHabit(context: viewContext)
            newNumberHabit.target = Int64(exactly: targetNumber) ?? 1
            newNumberHabit.unit = targetUnit
            newNumberHabit.habit = newHabit
        }
        else {
            
        }
        saveChanges(viewContext: viewContext)
    }
     */
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        print("*******************************")
        container = NSPersistentCloudKitContainer(name: "HabitTrackerDataModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
