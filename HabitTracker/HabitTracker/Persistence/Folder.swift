//
//  Folder.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/4/7.
//

import CoreData



extension PersistenceController  {
    func createFolder(dataModel: FolderModel) -> String {
        //let result = habitController(inMemory: true)
        //let viewContext = result.container.viewContext
        let viewContext = self.container.viewContext
        let newFolder = dataModel.convertToStorageModel(context: viewContext)
        saveChanges(viewContext: viewContext)
        return newFolder.id ?? ""
    }
    
    func getAllRootFolders() -> [Folder] {
        let request: NSFetchRequest<Folder> = Folder.fetchRequest()
        //"start >= %@ && ((willExpire && expireDate < %@) || !willExpire)"
        request.sortDescriptors = [NSSortDescriptor(key: "orderIdx", ascending: true)]
        request.predicate = NSPredicate(format: "level == %@", "0")
        do {
            let res = try container.viewContext.fetch(request)
            return res
        }
        catch {
            print("error fetching")
            return []
        }
    }
    
    func addFolderToParent(parentID: String, childID: String) {
        do {
            let request: NSFetchRequest<Folder> = Folder.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", parentID)
            let parents = try container.viewContext.fetch(request)
            if parents.count == 0 {
                return
            }
            let parent = parents[0]
            let requestForChild: NSFetchRequest<Folder> = Folder.fetchRequest()
            requestForChild.predicate = NSPredicate(format: "id == %@", childID)
            do {
                let children = try container.viewContext.fetch(requestForChild)
                if children.count == 0 {
                    return
                }
                let child = children[0]
                parent.addToChildFolders(child)
                saveChanges(viewContext: container.viewContext)
            }
            catch {
                print("error fetching")
                return
            }
        }
        catch {
            print("error fetching")
            return
        }
    }
}


extension FolderModel {
    func convertToStorageModel(context: NSManagedObjectContext) -> Folder {
        let res = Folder.init(context: context)
        res.name = name
        res.level = Int16(level)
        res.id = calculateId()
        res.orderIdx = Int16(orderIdx)
        return res
    }
}

extension FolderModel {
    func calculateId() -> String {
        return "\(fmt_timeStamp.string(from: Date()))<#$>\(UUID().uuidString)"
    }
}
