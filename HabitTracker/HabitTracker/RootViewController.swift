//
//  RootViewController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/14.
//

import SwiftUI
import UIKit

@MainActor
let rootViewController = RootViewController(rootView: RootView(viewModel: TaskMasterViewModel.shared))

class RootViewController: UIHostingController<RootView> {
    
    override func viewDidLoad() {
        /*
        let popupBgVc = PopupBackgroundViewController()
        popupBgVc.view.frame.size = UIScreen.main.bounds.size
        popupBgVc.view.backgroundColor = .clear
        view.addSubview(popupBgVc.view)
        addChild(popupBgVc)
        popupBgVc.didMove(toParent: self)
        */
    }
}


