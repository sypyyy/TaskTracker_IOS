//
//  TreeBasedTableViewControllerProtocol.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/4/14.
//

import Foundation
import UIKit

protocol TreeBasedTableViewController {
    @MainActor
    var dummyRootNode: AnyTreeNode { get set }
    var nodeArray: [AnyTreeNode] { get set }
}

extension TreeBasedTableViewController {
    @MainActor func getRowsToChange(oldModelArray: [AnyTreeNode], newModelArray: [AnyTreeNode]) -> TreeTableChanges {
        var oldId2Idx_Mapping = [String: Int]()
        var newId2Idx_Mapping = [String: Int]()
        let res = TreeTableChanges()
        
        oldModelArray.enumerated().forEach { idx, node in
            oldId2Idx_Mapping[node.id] = idx
        }
        
        newModelArray.enumerated().forEach { idx, node in
            newId2Idx_Mapping[node.id] = idx
        }
        
        oldId2Idx_Mapping.enumerated().forEach { entry in
            let id = entry.element.key
            let idx = entry.element.value
            if newId2Idx_Mapping[id] == nil {
                res.rowsToDelete.append(IndexPath(row: idx, section: 0))
            }
        }
        newId2Idx_Mapping.enumerated().forEach({entry in
            let id = entry.element.key
            let idx = entry.element.value
            if(oldId2Idx_Mapping[id] == nil) {
                res.rowsToInsert.append(IndexPath(row: idx, section: 0))
            } else if let oldIdx = oldId2Idx_Mapping[id], oldIdx != idx {
                res.rowsToMove.append((IndexPath(row: oldIdx, section: 0), IndexPath(row: idx, section: 0)))
            }
        })
        return res
    }
    
    @MainActor func getNewNodeArray(expandedStatesToRestore: [String:Bool]? = nil) -> [AnyTreeNode] {
        var newModelArray = [AnyTreeNode]()
        func traverseChildren(node: AnyTreeNode) {
            node.level = (node.parent?.level ?? 0) + 1
            newModelArray.append(node)
            if let expandedStatesToRestore = expandedStatesToRestore {
                node.isExpanded = expandedStatesToRestore[node.id] ?? false
            }
            if node.isExpanded {
                node.children.forEach { child in
                    traverseChildren(node: child)
                }
            }
        }
        
        self.dummyRootNode.children.forEach { node in
            traverseChildren(node: node)
        }
        return newModelArray
    }
    
    @MainActor func revealPathToNode(nodeId: String) -> [AnyTreeNode] {
        var res = [AnyTreeNode]()
        func traverseChildren(node: AnyTreeNode) -> Bool {
            if node.id == nodeId {
                res.append(node)
                return true
            }
            
            for child in node.children {
                if traverseChildren(node: child) {
                    node.isExpanded = true
                    res.append(node)
                    return true
                } else {
                    node.isExpanded = false
                }
            }
            
            return false
        }
        self.dummyRootNode.children.forEach { node in
            if traverseChildren(node: node) {
                return
            }
        }
        return res.reversed()
    }
    
    //MARK: Usage: inside performBatchUpdate, first call getNewNodeArray, set nodeArray to the new array, then call this function
    @MainActor func updateTable(tableView: UITableView, oldModelArray: [AnyTreeNode], newModelArray: [AnyTreeNode]) {
        let changes = getRowsToChange(oldModelArray: oldModelArray, newModelArray: newModelArray)
        tableView.deleteRows(at: changes.rowsToDelete, with: .fade)
        for rowToMove in changes.rowsToMove {
            tableView.moveRow(at: rowToMove.0, to: rowToMove.1)
        }
        tableView.insertRows(at: changes.rowsToInsert, with: .fade)
    }
}


class TreeTableChanges {
    var rowsToInsert: [IndexPath] = []
    var rowsToDelete: [IndexPath] = []
    //before, after
    var rowsToMove: [(IndexPath, IndexPath)] = []
    var rowsToReload: [IndexPath] = []
}
