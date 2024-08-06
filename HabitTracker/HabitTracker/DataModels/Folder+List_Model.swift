//
//  FolderModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/4/7.
//

import Foundation
import CoreData

//MARK: 项目/目标
class FolderModel: AnyTreeNode {
    var name: String
    
    init(folder: Folder, parent: AnyTreeNode? = nil) {
        self.name = folder.name ?? ""
        let childLists: [ListModel] = (folder.taskList?.allObjects as? [TaskList] ?? []).map({
            ListModel(list: $0)
        })
        let childFoldersAndLists: [AnyTreeNode] = childLists
        super.init(id: folder.id ?? "", children: childFoldersAndLists, isExpanded: false, parent: parent, level: Int(folder.level), originalType: TreeNodeSubclassInfo.sideMenuRow(info: .Folder(id: folder.id ?? "")), orderIdx: Int(folder.orderIdx))
    }
    
    init(name: String, id: String, children: [AnyTreeNode], isExpanded: Bool, parent: AnyTreeNode? = nil, level: Int, orderIdx: Int){
        self.name = name
        super.init(id: id, children: children, isExpanded: isExpanded, parent: parent, level: level, originalType: TreeNodeSubclassInfo.sideMenuRow(info: .Folder(id: id)), orderIdx: orderIdx)
    }
}

//MARK: 项目/目标
class ListModel: AnyTreeNode {
    var name: String
    var habits: [Habit] = []
    var todos: [Todo] = []
    
    init(list: TaskList, parent: AnyTreeNode? = nil) {
        self.name = list.name ?? ""
        habits = list.habits?.allObjects as? [Habit] ?? []
        todos = list.todos?.allObjects as? [Todo] ?? []
        super.init(id: list.id ?? "", children: [], isExpanded: false, parent: parent, level: Int(list.level), originalType: TreeNodeSubclassInfo.sideMenuRow(info: .List(id: list.id ?? "")), orderIdx: Int(list.orderIdx))
    }
}


