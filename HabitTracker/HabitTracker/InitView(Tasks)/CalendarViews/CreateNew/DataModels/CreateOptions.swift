//
//  InitViewCreateOptions.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/12/23.
//

import SwiftUI

enum CreateOptions: Int {
    case task = 0
    case event = 2
    case habit = 1
    
}

extension CreateOptions {
    
    var description: String {
        switch self {
        case .task:
            "New Task"
        case .event:
            "New Event"
        case .habit:
            "New Habit"
        
        }
    }
    
    var iconImage: Image {
        switch self {
        case .task:
            Image(systemName: "checkmark.circle")
        case .event:
            Image(systemName: "calendar")
        case .habit:
            Image(systemName: "repeat")
        
        }
        
        
       
    }
}
