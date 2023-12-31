//
//  NumberExtensions.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/31.
//

import Foundation


extension Double {
    func equals(_ subject: Double) -> Bool {
        return fabs(self - subject) < Double.ulpOfOne
    }
}

