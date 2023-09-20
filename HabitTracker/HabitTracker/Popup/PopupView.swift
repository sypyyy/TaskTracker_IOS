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
                if popupMgr.showType == .habitDetailNumberAddBy ||  popupMgr.showType == .habitDetailNumberReduceBy || popupMgr.showType == .habitDetailNumberSetTo {
                    numberPickerPopupWrapperView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut, value: popupMgr.showPopup)
            .animation(.easeInOut, value: popupMgr.showType)
            .onTapGesture {
            }
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
    @State private var showSelf = true
    var body: some View {
        VStack {
            //Text("Add progress by")
            numberPickerPopupView(number: $number, onDoneDidTap: {number in
                (popupMgr.callback as? PopupManager.habitDetailNumberModify_CallBack)?.save(Int16(number))
                popupMgr.closePopup()
            })
        }
       
    }
}
