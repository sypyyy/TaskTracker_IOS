//
//  GlobalPopupManager.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/10.
//

import SwiftUI
import UIKit

let POPUP_PADDING: CGFloat = 6

class SwiftUIGlobalPopupManager : ObservableObject{
    static var shared = SwiftUIGlobalPopupManager()
    private(set) var containerFrame: CGRect = .zero
    @MainActor
    private(set) var showPopup = false {
        didSet {
            bindedViewController.switchInteraction(showPopup)
        }
    }
    let bindedViewController = UIkitPopupViewController.shared
    var sourceFrame: CGRect?
    var popupSize: CGSize?
    var popupPosition: CGPoint?
    var popupSide: PopupSide = .down
    var popupView: AnyView = AnyView(EmptyView())
}

extension SwiftUIGlobalPopupManager {
    @MainActor func showPopup(view: AnyView, sourceFrame: CGRect, center: Bool = false, preferredSide: PopupSide? = .down, padding: EdgeInsets = .init(top: 0, leading: Task_Card_Horizontal_Padding, bottom: TAB_BAR_HEIGHT, trailing: Task_Card_Horizontal_Padding)) {
        print("showing pop")
        popupView = AnyView(view.id(UUID()))
        self.sourceFrame = sourceFrame
        if(!center) {
            //MARK: I added a padding here because the PopupView has this padding as well, I need to make sure the size is precise.
            let hostingController = UIHostingController(rootView: SwiftUIPopupWrapper{view})
            popupSize = hostingController.view.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            print("popup size: \(popupSize)")
            popupPosition = getPopupPosition(preferredSide: preferredSide, padding: padding)
            print("popup pos: \(popupPosition)")
        } else {
            popupPosition = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY - UIScreen.main.bounds.height * 0.1)
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
    
    @MainActor func getPopupPosition(preferredSide: PopupSide?, padding: EdgeInsets) -> CGPoint? {
        guard let sourceFrame = sourceFrame, let popupSize = popupSize,
              containerFrame != .zero else { return nil }
        var popside = PopupSide.down
        let srcPosY = sourceFrame.midY
        if(preferredSide == nil) {
            popside = (srcPosY < containerFrame.midY) ? .down : .up
        }
        if let preferSide = preferredSide {
            popside = preferSide
            switch preferSide {
            case .down:
                if(sourceFrame.maxY + padding.bottom + popupSize.height + POPUP_PADDING) > containerFrame.maxY {
                    popside = .up
                }
                
            case .up:
                if(sourceFrame.minY - padding.top) < containerFrame.minY {
                    popside = .down
                }
            default: break
            }
        }
        var popPos = CGPoint.zero
        
        if popside == .up {
            print("debuging \(sourceFrame), \(sourceFrame.minY), \(popupSize.height), \(containerFrame.maxY), \(containerFrame)")
            popPos.y = sourceFrame.minY - POPUP_PADDING - popupSize.height / 2
            self.popupSide = .up
        } else {
            popPos.y = sourceFrame.maxY + POPUP_PADDING + popupSize.height / 2
            self.popupSide = .down
        }
        
        popPos.x = sourceFrame.midX
        if(popPos.x + popupSize.width / 2 > (containerFrame.maxX - padding.trailing)) {
            popPos.x = containerFrame.maxX - padding.trailing - popupSize.width / 2
        }
        else if(popPos.x - popupSize.width / 2 < (containerFrame.minX + padding.leading)) {
            popPos.x = containerFrame.minX + padding.leading + popupSize.width / 2
        }
        return popPos
    }
}

enum PopupSide {
    case down, up, center
}

