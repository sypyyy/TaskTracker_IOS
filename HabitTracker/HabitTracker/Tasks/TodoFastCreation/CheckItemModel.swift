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
    var isEditing: Bool
    
    init(isChecked: Bool, content: String) {
        self.isChecked = isChecked
        self.content = content
        self.isEditing = true
    }
    
    init() {
        self.isChecked = false
        self.content = ""
        self.isEditing = false
        
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
