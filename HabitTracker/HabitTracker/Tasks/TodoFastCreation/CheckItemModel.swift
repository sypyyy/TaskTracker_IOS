//
//  CheckItemModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/3/30.
//

import UIKit

final class CheckItemModel: Codable {
    var isChecked: Bool
    var content: String
    var level: Int
    var isEditing: Bool
    var sumOfAllChildren: Int {
        var res = 0
        children.forEach { res += (1 + $0.sumOfAllChildren) }
        return res
    }
    var isExpanded: Bool = false
    var parent: CheckItemModel?
    var children: [CheckItemModel]
    
    init(isChecked: Bool, content: String, level: Int, isEditing: Bool, parent: CheckItemModel?, children: [CheckItemModel]) {
        self.isChecked = isChecked
        self.content = content
        self.level = level
        self.isEditing = isEditing
        self.parent = parent
        self.children = children
    }
    
    init() {
        self.isChecked = false
        self.content = ""
        self.level = 0
        self.isEditing = false
        self.parent = nil
        self.children = []
    }
    
    func addChild(child: CheckItemModel) {
        child.parent = self
        children.append(child)
    }
    
    func removeChild(child: CheckItemModel) {
        children.removeAll { $0 === child }
    }
    
    func removeChild(at index: Int) {
        children.remove(at: index)
    }
    
    func removeAllChildren() {
        children.removeAll()
    }
    
    func isLeaf() -> Bool {
        return children.isEmpty
    }
    
    func isRoot() -> Bool {
        return parent == nil
    }
    
    func isLastChild() -> Bool {
        return parent?.children.last === self
    }
    
    func isFirstChild() -> Bool {
        return parent?.children.first === self
    }
    
    func isOnlyChild() -> Bool {
        return parent?.children.count == 1
    }
}

extension CheckItemModel: Equatable {
    static func == (lhs: CheckItemModel, rhs: CheckItemModel) -> Bool {
        return lhs === rhs
    }
}

extension CheckItemModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
