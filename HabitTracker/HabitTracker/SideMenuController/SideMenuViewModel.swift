//
//  SideMenuViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/6/17.
//

import SwiftUI
/*
class SideMenuViewModel: ObservableObject, TreeBasedTableViewController {
    var dummyRootNode: AnyTreeNode = AnyTreeNode()
    static let shared = SideMenuViewModel()
    @Published var isShowing = false
    var activeRowInfo: SideMenuRowInfo = .defaultRow(.today)
    var activeRowId: String?
    
    let persistenceController = PersistenceController.shared

    private var leadingConstraint: NSLayoutConstraint!
    private var shadowColor: UIColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.2)
    
    private var tableData: SideMenuTableViewDatas = SideMenuTableViewDatas()
    
    internal var nodeArray: [AnyTreeNode] = []
    
    @MainActor
    private func loadData() {
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
        for node in dummyRootNode.children {
            traverse(node: node)
        }
        func traverse(node: AnyTreeNode) {
            nodeArray.append(node)
            if(node.isExpanded) {
                node.children.forEach{ child in
                    traverse(node: child)
                }
            }
        }
    }

    @objc private func tapped() {
        hide()
    }
    
    func translateLeft(by: CGFloat) {
        if(leadingConstraint.constant - by > 0) {
            leadingConstraint.constant = 0
            return
        }
        leadingConstraint.constant -= by
    }
    
    func onSwipeEnded() {
        if(leadingConstraint.constant < -100) {
            self.hide()
        } else {
            show()
        }
        
    }
}

extension SideMenuViewModel {
    
    private func updateTableView() {
        let oldNodeArr = nodeArray
        let newNodeArr = self.getNewNodeArray()
        nodeArray = newNodeArr
    }
    
    func expandOrCollapseFolder(nodeId: String) {
        guard let folder = nodeArray.first(where: {
            $0.id == nodeId
        }) as? FolderModel else {
            return
        }
        folder.isExpanded = !folder.isExpanded
    }
}



extension SideMenuViewModel {
    func selectRow(row: SideMenuRowInfo) {
        nodeArray.enumerated().forEach { (idx, node) in
            switch node.subTypeInfo {
            case .sideMenuRow(let info):
                if info == row {
                    activeRowId = node.id
                    (tableView.cellForRow(at: IndexPath(row: idx, section: 0)) as? SideMenuItemCell)?.highlight()
                } else {
                    (tableView.cellForRow(at: IndexPath(row: idx, section: 0)) as? SideMenuItemCell)?.unHighlight()
                }
            default:
                break
            }
        }
    }
    
    func didTapRow(nodeId: String) {
        nodeArray.enumerated().forEach { (idx, node) in
            if node.id == nodeId {
                activeRowId = node.id
                (tableView.cellForRow(at: IndexPath(row: idx, section: 0)) as? SideMenuItemCell)?.highlight()
            } else {
                (tableView.cellForRow(at: IndexPath(row: idx, section: 0)) as? SideMenuItemCell)?.unHighlight()
            }
        }

    }
}

*/
