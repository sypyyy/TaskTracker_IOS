//
//  GlobalPopupManager.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/10.
//

import SwiftUI
import UIKit

let POPUP_PADDING: CGFloat = 12

class GlobalPopupManager : ObservableObject{
    static var shared = GlobalPopupManager()
    private(set) var containerFrame: CGRect = .zero
    private(set) var showPopup = false
    var sourceFrame: CGRect?
    var popupSize: CGSize?
    var popupPosition: CGPoint?
    var popupSide: PopupSide = .down
    var popupView: AnyView = AnyView(EmptyView())
}

extension GlobalPopupManager {
    @MainActor func showPopup(view: AnyView, sourceFrame: CGRect, center: Bool = false) {
        print("showing pop")
        popupView = view
        self.sourceFrame = sourceFrame
        if(!center) {
            //MARK: I added a padding here because the PopupView has this padding as well, I need to make sure the size is precise.
            let hostingController = UIHostingController(rootView: view)
            popupSize = hostingController.view.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            popupPosition = getPopupPosition()
        } else {
            popupPosition = CGPoint(x: screenSize.midX, y: screenSize.midY - screenSize.height * 0.1)
            popupSide = .center
        }
        showPopup = true
        objectWillChange.send()
    }
    
    @MainActor func hidePopup(reason: String) {
        print("hiding pop \(reason)")
        showPopup = false
        //sourceFrame = nil
        //popupSize = nil
        //popupPosition = nil
        //popupView = AnyView(EmptyView())
        objectWillChange.send()
    }
    
    @MainActor func setContainerFrame(_ frame: CGRect) {
        containerFrame = frame
    }
    
    @MainActor func getPopupPosition() -> CGPoint? {
        guard let sourceFrame = sourceFrame, let popupSize = popupSize,
              containerFrame != .zero else { return nil }
        var popside = PopupSide.down
        let srcPosY = sourceFrame.midY
        popside = (srcPosY < containerFrame.midY) ? .down : .up
        var popPos = CGPoint.zero
        
        if popside == .up {
            popPos.y = sourceFrame.minY - POPUP_PADDING - popupSize.height / 2
            self.popupSide = .up
        } else {
            popPos.y = sourceFrame.maxY + POPUP_PADDING + popupSize.height / 2
            self.popupSide = .down
        }
        
        popPos.x = sourceFrame.midX
        if(popPos.x + popupSize.width / 2 > (containerFrame.maxX - POPUP_PADDING)) {
            popPos.x = containerFrame.maxX - POPUP_PADDING - popupSize.width / 2
        }
        else if(popPos.x - popupSize.width / 2 < (containerFrame.minX + POPUP_PADDING)) {
            popPos.x = containerFrame.minX + POPUP_PADDING + popupSize.width / 2
        }
        return popPos
    }
}

enum PopupSide {
    case down, up, center
}

