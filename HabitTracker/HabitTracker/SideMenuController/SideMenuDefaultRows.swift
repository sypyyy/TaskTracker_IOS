//
//  SideMenuStructure.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/5/4.
//

import Foundation

enum SideMenuDefaultRowType {
    case inbox, today, thisWeek, thisMonth, allToDos, allHabits
}

class SideMenuDefaultRow: AnyTreeNode {
    var title: String
    var icon: String
    var action: SideMenuTappedActions
    var type: SideMenuDefaultRowType
    
    init(title: String, icon: String, action: SideMenuTappedActions, orderIdx: Int, type: SideMenuDefaultRowType) {
        self.title = title
        self.icon = icon
        self.action = action
        self.type = type
        super.init(id: UUID().uuidString, children: [], isExpanded: false, level: 0, originalType: .sideMenuRow(info: .defaultRow(type)), orderIdx: orderIdx)
    }
}

@MainActor
let defaultSideMenuRows: [SideMenuDefaultRow] = [
    SideMenuDefaultRow(title: "Inbox", icon: "calendar", action: .callback({}), orderIdx: 0, type: .inbox),
    SideMenuDefaultRow(title: "Today", icon: "calendar", action: .callback({}), orderIdx: 1, type: .today),
    SideMenuDefaultRow(title: "This Week", icon: "list.bullet", action: .callback({}), orderIdx: 2, type: .thisWeek),
    SideMenuDefaultRow(title: "This Month", icon: "doc.text", action: .callback({}), orderIdx: 3, type: .thisMonth),
    SideMenuDefaultRow(title: "All To-dos", icon: "gear", action: .callback({}), orderIdx: 4, type: .allToDos),
    SideMenuDefaultRow(title: "All Habits", icon: "gear", action: .callback({}), orderIdx: 5, type: .allHabits)
]
