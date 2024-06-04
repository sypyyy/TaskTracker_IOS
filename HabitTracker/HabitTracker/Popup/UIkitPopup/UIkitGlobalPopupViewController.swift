//
//  GlobalPopup.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/5/12.
//

import UIKit
import SwiftUI

class UIkitPopupViewController: UIViewController {
    static let shared = UIkitPopupViewController()
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViews() {
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        let popupHostingController = UIHostingController(rootView: SwiftUIGlobalPopupView())
        popupHostingController.view.backgroundColor = .clear
        popupHostingController.view.frame = self.view.bounds
        addChild(popupHostingController)
        view.addSubview(popupHostingController.view)
        popupHostingController.didMove(toParent: self)
    }
    
    func switchInteraction(_ showPop: Bool) {
        view.isUserInteractionEnabled = showPop
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
}

extension UIkitPopupViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false }
        return true
    }
}
