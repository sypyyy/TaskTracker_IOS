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
        var todos = result.getAllTodos()
        var projects = result.getAllProjects()
        
        for habit in habits {
            viewContext.delete(habit)
        }
        
        for todo in todos {
            viewContext.delete(todo)
        }
        
        for project in projects {
            viewContext.delete(project)
        }
        
        saveChanges(viewContext: viewContext)
       
        print("deleted")
        let testTodo = TodoModel()
        testTodo.name = "Basketball with Michael"
        testTodo.priority = 1
        testTodo.executionTime = .from(area: .morning, startEnd: nil)
        
        result.createTodo(dataModel: testTodo)
        var testProject = ProjectModel()
        for i in 1...5 {
            if(i == 1) {
                testProject.name = "Eat healthier"
                result.createProject(dataModel: testProject)
            }
            else if(i == 2) {
                testProject.name = "Publish app"
                result.createProject(dataModel: testProject)
            }
            else if(i == 3) {
                testProject.name = "Read books"
                result.createProject(dataModel: testProject)    
            }

            else if(i == 4) {
                testProject.name = "Travel"
                result.createProject(dataModel: testProject)     
            }
            else if(i == 5) {
                testProject.name = "Exercise outdoors"
                result.createProject(dataModel: testProject)        
            }
        }
        for i in 1...12 {
            if(i == 1) {
                let p = 0
                let habit = HabitModel(name: "Drink water #\(i)p:\(p)", id: "", createdDate: Date(), type: .number, numberTarget: 8, timeTarget:"", detail: "blablabla", cycle: .daily, unit: "cups", priority: Int16(p), project: "", executionTime: .from(area: .morning, startEnd: ("7:03","8:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 2) {
                let p = 2
                let habit = HabitModel(name: "Drink water but weekly #\(i)p:\(p)", id: "", createdDate: Date(), type: .number, numberTarget: 8, timeTarget:"",  detail: "blablabla", cycle: .weekly, unit: "cups", priority: Int16(p), project: "", executionTime: .from(area: .morning, startEnd: ("7:00","8:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 3) {
                let p = 1
                let habit = HabitModel(name: "Drink water but monthly #\(i)p:\(p)", id: "", createdDate: Date(), type: .number, numberTarget: 8, timeTarget:"",  detail: "blablabla", cycle: .monthly, unit: "cups", priority: Int16(p), project: "", executionTime: .from(area: .morning, startEnd: ("9:40","12:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }

            else if(i == 4) {
                let p = 3
                let habit = HabitModel(name: "Study #\(i)p:\(p)", id: "", createdDate: Date(), type: .time, numberTarget: 8, timeTarget:"3:30",  detail: "blablabla", cycle: .daily, unit: "", priority: Int16(p), project: "", executionTime: .from(area: .morning, startEnd: nil))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 5) {
                let p = 3
                let habit = HabitModel(name: "Study but weekly #\(i)p:\(p)", id: "", createdDate: Date(), type: .time, numberTarget: 8, timeTarget:"2:00",  detail: "blablabla", cycle: .weekly, unit: "", priority: Int16(p), project: "", executionTime: .from(area: .evening, startEnd: ("19:00","20:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 6) {
                let p = 1
                let habit = HabitModel(name: "Study but monthly #\(i)p:\(p)", id: "", createdDate: Date(), type: .time, numberTarget: 8, timeTarget:"1:00", detail: "blablabla", cycle: .monthly, unit: "", priority: Int16(p), project: "", executionTime: .from(area: .evening, startEnd: nil))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 7) {
                let p = 2
                let habit = HabitModel(name: "Eat breakfast #\(i)p:\(p)", id: "", createdDate: Date(), type: .simple, numberTarget: 8, timeTarget:"", detail: "blablabla", cycle: .daily, unit: "", priority: Int16(p), project: "", executionTime: .from(area: .afternoon, startEnd: ("17:00","18:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 8) {
                let p = 2
                let habit = HabitModel(name: "Eat breakfast but weekly #\(i)p:\(p)", id: "", createdDate: Date(), type: .simple, numberTarget: 8, timeTarget:"", detail: "blablabla", cycle: .weekly, unit: "", priority: Int16(p), project: "", executionTime: .from(area: .afternoon, startEnd: nil))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 9) {
                let p = 1
                let habit = HabitModel(name: "Eat breakfast but monthly #\(i)p:\(p)", id: "", createdDate: Date(), type: .simple, numberTarget: 8, timeTarget:"", detail: "blablabla", cycle: .monthly, unit: "", priority: Int16(p), project: "", executionTime: .from(area: .afternoon, startEnd: ("18:00","19:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            
            else {
                let p = 3
                let habit = HabitModel(name: "Eat breakfast but monthly #\(i)p:\(p)", id: "", createdDate: Date(), type: .simple, numberTarget: 8, timeTarget:"", detail: "blablabla", cycle: .monthly, unit: "", priority: Int16(p), project: "", executionTime: .from(area: .allDay, startEnd: nil))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
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
