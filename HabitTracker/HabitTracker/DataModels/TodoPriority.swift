//
//  TodoPriority.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/5/27.
//

import SwiftUI

enum TodoPriority: Int {
    case none = 0
    case high = 1
    case medium = 2
    case low = 3
}

extension TodoPriority {
    var color: Color {
        switch self {
        case .none:
            return .gray
        case .high:
            return .red
        case .medium:
            return .yellow.darker(by: 10)
        case .low:
            return .green
        }
    }
    
    var description: String {
        switch self {
        case .none:
            "No priority"
        case .high:
            "High priority"
        case .medium:
            "Medium priority"
        case .low:
            "Low priority"
        }
    }
}
