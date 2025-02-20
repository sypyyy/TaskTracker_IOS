//
//  TodoEditOrCreateNavBarview.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/8/15.
//

import SwiftUI

struct TodoEditOrCreateNavBarView: View {
    weak var todoCreatController: TodoFastCreatViewController?
    @State var formStyle: FormStyle = FormStyle()
    let isCreating: Bool = true
    static let HEIGHT: CGFloat = 44
    static let CANCEL_BUTTON_SIZE: CGFloat = 24
    var body: some View {
        if isCreating {
            HStack {
                Button {
                    BottomSheetViewController.shared.hide()
                } label: {
                    Text("Cancel")
                }
                
                Spacer()
                
                Button {
                    todoCreatController?.saveNewTodo()
                    BottomSheetViewController.shared.hide()
                } label: {
                    Text("Save")
                }
                
            }.foregroundStyle(formStyle.navBarTextColor)
        } else {
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "chevron.down")
                        .fontWeight(.bold)
                        .foregroundStyle(formStyle.foldChevronColor)
                        .frame(width: 20, height: 20)
                }

                
                Spacer()
                
            }
        }
    }
}

#Preview {
    TodoEditOrCreateNavBarView()
}
