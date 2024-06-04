//
//  SelfSizingHostingController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/5/16.
//

import UIKit
import SwiftUI

class SelfSizingHostingController<Content>: UIHostingController<Content> where Content: View {

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.invalidateIntrinsicContentSize()
    }
}
