//
//  TreeNode.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/4/3.
//

import Foundation

class AnyTreeNode: Hashable {
    static func == (lhs: AnyTreeNode, rhs: AnyTreeNode) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var subTypeInfo: TreeNodeSubclassInfo
    
    var orderIdx: Int
    var level: Int
    weak var parent: AnyTreeNode?
    var id: String
    private(set) var children: [AnyTreeNode]
    var isExpanded: Bool

    init(id: String, children: [AnyTreeNode], isExpanded: Bool, parent: AnyTreeNode? = nil, level: Int, originalType: TreeNodeSubclassInfo, orderIdx: Int) {
        self.parent = parent
        self.id = id
        self.children = children
        self.isExpanded = isExpanded
        self.level = level
        self.subTypeInfo = originalType
        self.orderIdx = orderIdx
        self.children.forEach({
            $0.parent = self
        })
    }
    
    //This is only called for the dummy root node
    init() {
        self.id = UUID().uuidString
        self.children = []
        self.isExpanded = true
        self.parent = nil
        self.level = 0
        self.subTypeInfo = .sideMenuRow(info: .defaultRow(.inbox))
        self.orderIdx = 0
    }
    
    func addChild(_ child: AnyTreeNode) {
        children.append(child)
        child.parent = self
    }
    
    func addChildren(_ children: [AnyTreeNode]) {
        self.children.append(contentsOf: children)
        children.forEach({
            $0.parent = self
        })
    }
    
    func removeAllChildren() {
        children.removeAll()
    }
}


