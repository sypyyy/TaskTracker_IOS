//
//  TreeNodeClassInfo.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/6/23.
//

import Foundation

enum TreeNodeSubclassInfo {
    case goal, habit, todo
    case sideMenuRow(info: SideMenuRowInfo)
    case goalRow(info: GoalRowInfo)
}
