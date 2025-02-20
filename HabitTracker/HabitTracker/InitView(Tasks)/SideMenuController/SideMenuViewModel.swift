//
//  SideMenuViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/6/17.
//

import SwiftUI

class SideMenuViewModel: ObservableObject {
    @MainActor
    static let shared = SideMenuViewModel()
    @Published var isShowing = false
    var activeRowId: String?
    
    let persistenceController = PersistenceController.preview

    private var leadingConstraint: NSLayoutConstraint!
    private var shadowColor: UIColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.2)
        
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
        
        nodeArray = []
        
        
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
        
        objectWillChange.send()
    }
    
}



extension SideMenuViewModel {
    func selectRow() {
    }
    
    func didTapRow(nodeId: String) {
        activeRowId = nodeId
        objectWillChange.send()
    }
}


