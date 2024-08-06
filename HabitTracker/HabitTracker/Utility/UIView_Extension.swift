//
//  UIView_Animation_Extension.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/10.
//

import Foundation
import UIKit

extension UIView {
    func transitionView(hidden: Bool,  completion : (() -> Void)? = nil) {
        let view = self
        guard let parent = view.superview else { return }
        let target: UIView = !hidden ? view : parent
        UIView.transition(with: target, duration: 0.2, options: [.transitionCrossDissolve], animations: {
            view.isHidden = hidden
        }, completion: {res in
            print("appearComplete\(hidden)")
            completion?()
        })
    }
}

@MainActor 
func findScrollView(in view: UIView) -> UIScrollView? {
    if let scrollView = view as? UIScrollView {
        return scrollView
    }
    for subview in view.subviews {
        if let found = findScrollView(in: subview) {
            return found
        }
    }
    return nil
}
