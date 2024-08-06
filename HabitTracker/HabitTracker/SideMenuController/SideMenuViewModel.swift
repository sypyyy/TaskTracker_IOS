//
//  SideMenuViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/6/17.
//

import SwiftUI

class SideMenuViewModel: ObservableObject, TreeBasedTableViewController {
    var dummyRootNode: AnyTreeNode = AnyTreeNode()
    @MainActor
    static let shared = SideMenuViewModel()
    @Published var isShowing = false
    var activeRowInfo: SideMenuRowInfo = .defaultRow(.today)
    var activeRowId: String?
    
    let persistenceController = PersistenceController.preview

    private var leadingConstraint: NSLayoutConstraint!
    private var shadowColor: UIColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.2)
    
    private var tableData: SideMenuTableViewDatas = SideMenuTableViewDatas()
    
    internal var nodeArray: [AnyTreeNode] = [] {
        didSet {
            print("nodeArrayCount: \(nodeArray.count)")
        }
    }
    
    @MainActor
    init() {
        loadDataAndUpdate()
    }
    
    @MainActor
    private func loadDataAndUpdate() {
        dummyRootNode.removeAllChildren()
        nodeArray = []
        //Put default rows in (Today, inbox blablabla)
        defaultSideMenuRows.forEach {node in
            dummyRootNode.addChild(node)
        }
        //Put folders in
        let rootFolders = persistenceController.getAllRootFolders()
        let rootLists = persistenceController.getAllRootLists()
        dummyRootNode.addChildren(rootFolders.map{ folder in
            FolderModel(folder: folder, parent: dummyRootNode)
        } + rootLists.map{ list in
            ListModel(list: list, parent: dummyRootNode)
        })
        updateNodeArray()
        /*
        for node in dummyRootNode.children {
            traverse(node: node)
        }
        objectWillChange.send()
        func traverse(node: AnyTreeNode) {
            nodeArray.append(node)
            if(node.isExpanded) {
                node.children.forEach{ child in
                    traverse(node: child)
                }
            }
        }
         */
    }
}

extension SideMenuViewModel {
    
    @MainActor
    private func updateNodeArray() {
        let oldNodeArr = nodeArray
        print("oldNodeArr: \(oldNodeArr.last?.id)")
        let newNodeArr = self.getNewNodeArray()
        print("newNodeArr: \(newNodeArr.last?.id)")
        nodeArray = newNodeArr
        objectWillChange.send()
    }
    
    @MainActor
    func expandOrCollapseFolder(nodeId: String) {
        guard let folder = nodeArray.first(where: {
            $0.id == nodeId
        }) as? FolderModel else {
            return
        }
        folder.isExpanded = !folder.isExpanded
        updateNodeArray()
    }
}



extension SideMenuViewModel {
    func selectRow(row: SideMenuRowInfo) {
        nodeArray.enumerated().forEach { (idx, node) in
            switch node.subTypeInfo {
            case .sideMenuRow(let info):
                if info == row {
                    activeRowId = node.id
                }
            default:
                break
            }
        }
    }
    
    func didTapRow(nodeId: String) {
        activeRowId = nodeId
        objectWillChange.send()
    }
}


