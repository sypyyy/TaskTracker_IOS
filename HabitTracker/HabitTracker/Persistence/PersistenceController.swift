//
//  HabitController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/11.
//

import CoreData

@MainActor
class PersistenceController {
    //static let shared = PersistenceController()
    static var preview: PersistenceController = {
        var result = PersistenceController(inMemory: false)
        let viewContext = result.container.viewContext
        var habits = result.getAllHabits()
        var todos = result.getAllTodos()
        var projects = result.getAllGoals()
        var folders = result.getAllFolders()
        var lists = result.getAllLists()
        
        for habit in habits {
            viewContext.delete(habit)
        }
        
        for todo in todos {
            viewContext.delete(todo)
        }
        
        for project in projects {
            viewContext.delete(project)
        }
        
        for folder in folders {
            viewContext.delete(folder)
        }
        
        for list in lists {
            viewContext.delete(list)
        }
        
        saveChanges(viewContext: viewContext)
        
        for i in 1...5 {
            if(i == 1) {
                let testFolder = FolderModel(name: "Work", id: UUID().uuidString, children: [], isExpanded: false, parent: nil, level: 0, orderIdx: i)
                let parentID = result.createFolder(dataModel: testFolder)
                
                /*
                result.addFolderToParent(parentID: parentID, childID: childId)
                 */
            } else if(i == 2) {
                let testFolder = FolderModel(name: "Entertainment", id: UUID().uuidString, children: [], isExpanded: false, parent: nil, level: 0, orderIdx: i)
                result.createFolder(dataModel: testFolder)
            } else if(i == 3) {
                let testFolder = FolderModel(name: "Workout", id: UUID().uuidString, children: [], isExpanded: false, parent: nil, level: 0, orderIdx: i)
                result.createFolder(dataModel: testFolder)
            }
        }
        
        for i in 1...5 {
            if(i == 1) {
                let testTodo = TodoModel()
                testTodo.name = "Ba"
                testTodo.note = "dshjdhjsdhsejh后继乏人时候损人害己回复角色回复黄金时间恢复后是否会是如何发挥是如何发挥是封建社会冯绍峰会是如何发挥是人间繁华和杀人放火监护人杀鸡儆猴发损人害己粉红色减肥开始看就非常技术日渐繁荣时代就分开的借口"
                testTodo.priority = .high
                testTodo.executionTime = .from(area: .morning, startEnd: nil)
                result.createTodo(dataModel: testTodo)
            } else if(i == 2) {
                let testTodo = TodoModel()
                testTodo.name = "Wash Dished"
                testTodo.startDate = Date().addByDay(1)
                testTodo.priority = .high
                testTodo.executionTime = .from(area: .morning, startEnd: nil)
                result.createTodo(dataModel: testTodo)
            } else if(i == 3) {
                let testTodo = TodoModel()
                testTodo.name = "Go shopping"
                testTodo.startDate = Date().addByDay(-1)
                testTodo.priority = .high
                testTodo.executionTime = .from(area: .morning, startEnd: nil)
                result.createTodo(dataModel: testTodo)
            } else if(i == 4) {
                let testTodo = TodoModel()
                testTodo.name = "Go Fishing"
                testTodo.startDate = Date().addByDay(-1)
                testTodo.priority = .high
                testTodo.executionTime = .from(area: .morning, startEnd: nil)
                result.createTodo(dataModel: testTodo)
            } else if(i == 5) {
                let testTodo = TodoModel()
                testTodo.name = "Go Crazy"
                testTodo.startDate = Date().addByDay(-1)
                testTodo.priority = .high
                testTodo.executionTime = .from(area: .morning, startEnd: nil)
                result.createTodo(dataModel: testTodo)
            }
        }
        print("deleted")
        
        
        
        var testProject = GoalModel(name: "", isFinished: false, id: "", isRoot: true)
        for i in 1...5 {
            if(i == 1) {
                testProject.name = "Eat healthier"
                result.createGoal(dataModel: testProject)
            }
            else if(i == 2) {
                testProject.name = "Design App"
                let parentId = result.createGoal(dataModel: testProject)
                let testChildGoal = GoalModel(name: "Design icon", isFinished: false, id: "", isRoot: false)
                let childId = result.createGoal(dataModel: testChildGoal)
                result.addGoalToParent(parentID: parentId, childID: childId)
                let testChildGoal2 = GoalModel(name: "Design icon", isFinished: false, id: "", isRoot: false)
                let childId2 = result.createGoal(dataModel: testChildGoal)
                result.addGoalToParent(parentID: childId, childID: childId2)
                let testChildGoal3 = GoalModel(name: "Design icon", isFinished: false, id: "", isRoot: false)
                let childId3 = result.createGoal(dataModel: testChildGoal)
                result.addGoalToParent(parentID: childId2, childID: childId3)
                let testChildGoal4 = GoalModel(name: "Design icon", isFinished: false, id: "", isRoot: false)
                let childId4 = result.createGoal(dataModel: testChildGoal)
                result.addGoalToParent(parentID: childId3, childID: childId4)
            }
            else if(i == 3) {
                testProject.name = "Publish app"
                let parentId = result.createGoal(dataModel: testProject)

                // Level 1
                let testChildGoal1a = GoalModel(name: "Design icon", isFinished: false, id: "", isRoot: false)
                let testChildGoal1b = GoalModel(name: "Create splash screen", isFinished: false, id: "", isRoot: false)
                let childId1a = result.createGoal(dataModel: testChildGoal1a)
                let childId1b = result.createGoal(dataModel: testChildGoal1b)
                result.addGoalToParent(parentID: parentId, childID: childId1a)
                result.addGoalToParent(parentID: parentId, childID: childId1b)

                // Level 2 for "Design icon"
                let testChildGoal2a = GoalModel(name: "Create initial sketches", isFinished: false, id: "", isRoot: false)
                let testChildGoal2b = GoalModel(name: "Choose color scheme", isFinished: false, id: "", isRoot: false)
                let childId2a = result.createGoal(dataModel: testChildGoal2a)
                let childId2b = result.createGoal(dataModel: testChildGoal2b)
                result.addGoalToParent(parentID: childId1a, childID: childId2a)
                result.addGoalToParent(parentID: childId1a, childID: childId2b)

                // Level 3 for "Create initial sketches"
                let testChildGoal3a = GoalModel(name: "Sketch different styles", isFinished: false, id: "", isRoot: false)
                let testChildGoal3b = GoalModel(name: "Get feedback on sketches", isFinished: false, id: "", isRoot: false)
                let childId3a = result.createGoal(dataModel: testChildGoal3a)
                let childId3b = result.createGoal(dataModel: testChildGoal3b)
                result.addGoalToParent(parentID: childId2a, childID: childId3a)
                result.addGoalToParent(parentID: childId2a, childID: childId3b)

                // Level 2 for "Create splash screen"
                let testChildGoal2c = GoalModel(name: "Design layout", isFinished: false, id: "", isRoot: false)
                let testChildGoal2d = GoalModel(name: "Choose theme colors", isFinished: false, id: "", isRoot: false)
                let childId2c = result.createGoal(dataModel: testChildGoal2c)
                let childId2d = result.createGoal(dataModel: testChildGoal2d)
                result.addGoalToParent(parentID: childId1b, childID: childId2c)
                result.addGoalToParent(parentID: childId1b, childID: childId2d)

                // Level 3 for "Design layout"
                let testChildGoal3c = GoalModel(name: "Draw wireframe", isFinished: false, id: "", isRoot: false)
                let testChildGoal3d = GoalModel(name: "Get feedback on layout", isFinished: false, id: "", isRoot: false)
                let childId3c = result.createGoal(dataModel: testChildGoal3c)
                let childId3d = result.createGoal(dataModel: testChildGoal3d)
                result.addGoalToParent(parentID: childId2c, childID: childId3c)
                result.addGoalToParent(parentID: childId2c, childID: childId3d)
            }

            else if(i == 4) {
                testProject.name = "Travel"
                result.createGoal(dataModel: testProject)     
            }
            else if(i == 5) {
                testProject.name = "Exercise outdoors"
                result.createGoal(dataModel: testProject)        
            }
        }
        for i in 1...12 {
            if(i == 1) {
                let p = 0
                let habit = HabitModel(name: "Drink water #\(i)p:\(p)", id: "", createdDate: Date(), type: .number, numberTarget: 8, timeTarget:"", detail: "blablabla", cycle: .daily, unit: "cups", priority: Int16(p), executionTime: .from(area: .morning, startEnd: ("7:03","8:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 2) {
                let p = 2
                let habit = HabitModel(name: "Drink water but weekly #\(i)p:\(p)", id: "", createdDate: Date(), type: .number, numberTarget: 8, timeTarget:"",  detail: "blablabla", cycle: .weekly, unit: "cups", priority: Int16(p), executionTime: .from(area: .morning, startEnd: ("7:00","8:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 3) {
                let p = 1
                let habit = HabitModel(name: "Drink water but monthly #\(i)p:\(p)", id: "", createdDate: Date(), type: .number, numberTarget: 8, timeTarget:"",  detail: "blablabla", cycle: .monthly, unit: "cups", priority: Int16(p), executionTime: .from(area: .morning, startEnd: ("9:40","12:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }

            else if(i == 4) {
                let p = 3
                let habit = HabitModel(name: "Study #\(i)p:\(p)", id: "", createdDate: Date(), type: .time, numberTarget: 8, timeTarget:"3:30",  detail: "blablabla", cycle: .daily, unit: "", priority: Int16(p), executionTime: .from(area: .morning, startEnd: nil))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 5) {
                let p = 3
                let habit = HabitModel(name: "Study but weekly #\(i)p:\(p)", id: "", createdDate: Date(), type: .time, numberTarget: 8, timeTarget:"2:00",  detail: "blablabla", cycle: .weekly, unit: "", priority: Int16(p), executionTime: .from(area: .evening, startEnd: ("19:00","20:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 6) {
                let p = 1
                let habit = HabitModel(name: "Study but monthly #\(i)p:\(p)", id: "", createdDate: Date(), type: .time, numberTarget: 8, timeTarget:"1:00", detail: "blablabla", cycle: .monthly, unit: "", priority: Int16(p), executionTime: .from(area: .evening, startEnd: nil))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 7) {
                let p = 2
                let habit = HabitModel(name: "Eat breakfast #\(i)p:\(p)", id: "", createdDate: Date(), type: .simple, numberTarget: 8, timeTarget:"", detail: "blablabla", cycle: .daily, unit: "", priority: Int16(p), executionTime: .from(area: .afternoon, startEnd: ("17:00","18:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 8) {
                let p = 2
                let habit = HabitModel(name: "Eat breakfast but weekly #\(i)p:\(p)", id: "", createdDate: Date(), type: .simple, numberTarget: 8, timeTarget:"", detail: "blablabla", cycle: .weekly, unit: "", priority: Int16(p), executionTime: .from(area: .afternoon, startEnd: nil))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            else if(i == 9) {
                let p = 1
                let habit = HabitModel(name: "Eat breakfast but monthly #\(i)p:\(p)", id: "", createdDate: Date(), type: .simple, numberTarget: 8, timeTarget:"", detail: "blablabla", cycle: .monthly, unit: "", priority: Int16(p), executionTime: .from(area: .afternoon, startEnd: ("18:00","19:00")))
                do {try result.creatNewHabit(habit: habit)} catch {print("")}
            }
            
            else {
                let p = 3
                let habit = HabitModel(name: "Eat breakfast but monthly #\(i)p:\(p)", id: "", createdDate: Date(), type: .simple, numberTarget: 8, timeTarget:"", detail: "blablabla", cycle: .monthly, unit: "", priority: Int16(p), executionTime: .from(area: .allDay, startEnd: nil))
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

/*
extension PersistenceController {
    static func getIdWithTimeStamp()-> String {
        return "\(fmt_timeStamp.string(from: Date()))<#$>\(UUID().uuidString)"
    }
}
*/
