//
//  PopupView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/6/25.
//

import SwiftUI

struct PopupView: View {
    @StateObject var popupMgr = PopupManager.shared
    var body: some View {
        if popupMgr.showPopup {
            VStack {
                if popupMgr.showType == .habitDetailNumberModify {
                    numberPickerPopupWrapperView()
                }
                if popupMgr.showType == .habitDetailTimeModify {
                    timePickerPopupWrapperView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: POPUP_ANIMATION_DURATION), value: popupMgr.showPopup)
            .animation(.easeInOut(duration: POPUP_ANIMATION_DURATION), value: popupMgr.showType)
            
        }
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        PopupView()
    }
}


struct numberPickerPopupWrapperView: View {
    @StateObject var popupMgr = PopupManager.shared
    @State private var number: Int = 1
    var body: some View {
        VStack {
            //Text("Add progress by")
            numberPickerPopupView(title: popupMgr.popupTitle, minimum: 0, number: $number, onDoneDidTap: {number in
                (popupMgr.callback as? PopupManager.habitDetailNumberModify_CallBack)?.save(Int16(number))
                popupMgr.closePopup()
            })
        }
       
    }
}

struct timePickerPopupWrapperView: View {
    @StateObject var popupMgr = PopupManager.shared
    @State private var hour: Int = 0
    @State private var minute: Int = 0
    var body: some View {
        VStack {
            //Text("Add progress by")
            timePickerPopupView(title: popupMgr.popupTitle, hour: $hour, minute: $minute, onDoneDidTap: {hour, minute in
                (popupMgr.callback as? PopupManager.habitDetailTimeModify_CallBack)?.save(hour, minute)
                popupMgr.closePopup()
            })
        }
       
    }
}
