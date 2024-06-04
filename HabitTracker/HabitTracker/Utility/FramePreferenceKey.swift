//
//  FramePreferenceKey.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/5/14.
//

import SwiftUI

/*
 Usage:
 .background(
     GeometryReader { geo in
         Color.clear
             .preference(key: FramePreferenceKey.self,
                         value: geo.frame(in: CoordinateSpace.global))
     }
 )
 .onPreferenceChange(FramePreferenceKey.self) { value in
     self.frame = value
 }
 */

struct FramePreferenceKey: PreferenceKey {
    typealias Value = CGRect
    static var defaultValue: Value = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
