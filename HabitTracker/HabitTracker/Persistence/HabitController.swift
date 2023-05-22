//
//  HabitController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/11.
//

import CoreData

struct habitController {
    static let shared = habitController()
    static var preview: habitController = {
        let result = habitController(inMemory: false)
        let viewContext = result.container.viewContext
        for i in 1...100 {
            let newItem1 = Habit(context: viewContext)
            newItem1.name = "Drink water\(i)"
            newItem1.createdDate = Date()
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
    //delete this in production!!!!
    static func saveChanges(viewContext: NSManagedObjectContext) {
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
    private var numberOfHabits: Int64 = 0
    
    func createHabit(name: String, detail: String, habitType: String, cycle: String, targetNumber: String, targetUnit: String,
                     targetHour: Int, targetMinute: Int) {
        let viewContext = self.container.viewContext
        let newHabit = Habit(context: viewContext)
        newHabit.name = name
        newHabit.cycle = cycle
        newHabit.index = numberOfHabits + 1
        newHabit.createdDate = Date()
        newHabit.ended = false
        newHabit.detail = detail
        newHabit.habitID = name + String(newHabit.index)
        saveChanges(viewContext: viewContext)
        if(habitType == "Time") {
            let newTimeHabit = TimeBasedHabit(context: viewContext)
            newTimeHabit.target = String(targetHour) + ":" + String(targetMinute)
            newTimeHabit.habit = newHabit
            
        }
        else {
            let newNumberHabit = NumberBasedHabit(context: viewContext)
            newNumberHabit.target = Int64(targetNumber)!
            newNumberHabit.unit = targetUnit
            newNumberHabit.habit = newHabit
        }
        saveChanges(viewContext: viewContext)
    }
    
    
    mutating func getAllHabits() -> [Habit] {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        do {
            let res = try container.viewContext.fetch(request)
            numberOfHabits = Int64(res.count)
            return res
        }
        catch {
            return []
        }
    }
    
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
