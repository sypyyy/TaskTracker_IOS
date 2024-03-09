//
//  RootViewController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/14.
//

import SwiftUI
import UIKit

@MainActor
let rootViewController = ContentViewController(rootView: RootView())

class ContentViewController: UIHostingController<RootView> {
    weak var delegate: SideMenuDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


