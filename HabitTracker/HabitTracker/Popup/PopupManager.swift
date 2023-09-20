//
//  PopupManager.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/6/25.
//

import Foundation

let POPUP_ANIMATION_DURATION = 0.4

class PopupManager : ObservableObject{
    static var shared = PopupManager()
    var showPopup = false {
        didSet {
            HabitTrackerViewModel.shared.blurEverything = showPopup
        }
    }
    var showType: PopupType = .habitDetailNumberModify
    var popupTitle: String = ""
    var callback: PopupCallback?
    public func displayPopup(showType: PopupType, title: String = "", callback: PopupCallback) {
        popupTitle = title
        showPopup = true
        HabitTrackerViewModel.shared.blurEverything = showPopup
        self.showType = showType
        self.callback = callback
        objectWillChange.send()
    }
    
    public func closePopup() {
        showPopup = false
        HabitTrackerViewModel.shared.blurEverything = showPopup
        self.callback = nil
        objectWillChange.send()
    }
}

enum PopupType {
    //case createFormNumberPicker
    //case createFormTimePicker
    case habitDetailNumberModify
    case habitDetailTimeModify
    case habitDetailTimeTimerSetTo
}


extension PopupManager {
    
    class PopupCallback {
    }
    
    class habitDetailNumberModify_CallBack: PopupCallback {
        var save: (Int16) -> Void?
        init(saveFunc: @escaping (Int16) -> Void){
            self.save = saveFunc
        }
    }
    
    class habitDetailTimeModify_CallBack: PopupCallback {
        var save: (Int, Int) -> Void?
        init(saveFunc: @escaping (Int, Int) -> Void){
            self.save = saveFunc
        }
    }
}
