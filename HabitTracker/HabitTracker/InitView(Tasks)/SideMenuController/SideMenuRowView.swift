//
//  SideMenuRowView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/6/17.
//

import SwiftUI

struct SideMenuRowView: View {
    @StateObject var sideMenuViewModel = SideMenuViewModel.shared
    var node: AnyTreeNode
    var body: some View {
        switch node.subTypeInfo {
        case .sideMenuRow(let info):
            switch info {
            
            case .defaultRow(let rowInfo):
                let listModel = node as? SideMenuDefaultRow
                let x = print("name is \(listModel?.title ?? "")")
                Text("Row\(listModel?.title ?? "")")
            case .CustomFilter(id: _):
                Text("")
            case .Label(id: let id):
                Text("")
            }
        default:
            EmptyView()
        }
    }
}
