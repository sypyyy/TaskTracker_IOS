//
//  Projects.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/4.
//

import CoreData

enum CreateProjectResult {
    case Success,Duplicate
}

extension PersistenceController  {
    func createProject(dataModel: ProjectModel) -> CreateProjectResult {
        //let result = habitController(inMemory: true)
        //let viewContext = result.container.viewContext
        let viewContext = self.container.viewContext
        let newProject = dataModel.convertToStorageModel(context: viewContext)
        let id = dataModel.calculateId()
        let isIdUnique = checkProjectIdIsUnique(IdToBe: id)
        if !isIdUnique {
            viewContext.delete(newProject)
            return .Duplicate
        }
        newProject.id = id
        saveChanges(viewContext: viewContext)
        return .Success
    }

    private func checkProjectIdIsUnique(IdToBe: String) -> Bool {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", "\(IdToBe)")
        do {
            let res = try container.viewContext.fetch(request)
            if res.count == 0 {
                return true
            }
        }
        catch {
            return false
        }
        return false
    }
    
    func getAllProjects() -> [Project] {
        let request: NSFetchRequest<Project> = Project.fetchRequest()
        //"start >= %@ && ((willExpire && expireDate < %@) || !willExpire)"
        do {
            let res = try container.viewContext.fetch(request)
            return res
        }
        catch {
            print("error fetching")
            return []
        }
    }
}


extension ProjectModel {
    func convertToStorageModel(context: NSManagedObjectContext) -> Project {
        let res = Project.init(context: context)
        res.name = name
        res.startDate = startDate
        res.endDate = endDate
        res.isPaused = isPaused
        res.isFinished = isFinished
        return res
    }
}

extension ProjectModel {
    func calculateId() -> String {
        //Calculate id based on the name and startDate
        var formatter: DateFormatter {
            let fmt = DateFormatter()
            fmt.dateFormat = "yyyy/MM/dd/HH:mm"
            return fmt
        }
        let id = "\(self.name)<#$>\(formatter.string(from: self.startDate))<#$>Project"
        return id
    }
}
