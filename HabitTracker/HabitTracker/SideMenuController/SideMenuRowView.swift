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
            case .Folder(let id):
                let folderModel = node as? FolderModel
                let x = print("name is \(folderModel?.name ?? "")")
                Text("Folder\(folderModel?.name ?? "")")
                    .onTapGesture {
                        withAnimation {
                            sideMenuViewModel.expandOrCollapseFolder(nodeId: id)
                        }
                    }
            case .List(let id):
                let listModel = node as? ListModel
                let x = print("name is \(listModel?.name ?? "")")
                Text("List\(listModel?.name ?? "")")
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
