//
//  KeyboardAvoiding.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/8/22.
//

import UIKit

extension UIView {
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        for subview in self.subviews {
            if let firstResponder = subview.findFirstResponder() {
                return firstResponder
            }
        }
        return nil
    }
}
