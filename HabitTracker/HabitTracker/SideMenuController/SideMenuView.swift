//
//  SideMenuHostingController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/6/17.
//

import SwiftUI
import SwipeActions

struct SideMenuView: View {
    @StateObject var sideMenuViewModel = SideMenuViewModel.shared
    var body: some View {
        let x = print("rendered!")
        VStack{
            ScrollView {
                
                LazyVStack {
                    SwipeViewGroup {
                        ForEach(sideMenuViewModel.nodeArray, id: \.id) { node in
                            let x = print("id is \(node.id), order is \(node.orderIdx)")
                            
                            SwipeView {
                                HStack {
                                    SideMenuRowView(node: node).padding(.leading, 6)
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .contentShape([.dragPreview], RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .contentShape([.interaction], Rectangle())
                                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .draggable(SideMenuRowDragData(name: ""))
                                /*
                                .dropDestination(for: SideMenuRowDragData.self) { item,_  in
                                    print("dropped!")
                                    return true
                                } isTargeted: { item in
                                    print("targeted!")
                                }
                                 */
                               
                                
                                
                                
                            } trailingActions: { _ in
                                SwipeAction(action: {
                                    
                                }, label: {_ in
                                    Text("t")
                                }, background: {_ in
                                    Rectangle().fill(.red.opacity(0.3))
                                })
                                SwipeAction(action: {
                                    
                                }, label: {_ in
                                    Text("t")
                                }, background: {_ in
                                    Rectangle().fill(.green.opacity(0.3))
                                })
                                SwipeAction(action: {
                                    
                                }, label: {_ in
                                    Text("t")
                                }, background: {_ in
                                    Rectangle().fill(.blue.opacity(0.3))
                                })
                                //.allowSwipeToTrigger()
                            }
                            .swipeActionsStyle(.equalWidths)
                            .swipeActionsMaskCornerRadius(12)
                            .swipeActionCornerRadius(0)
                            .swipeActionWidth(40)
                            .swipeSpacing(0)
                            .swipeActionsVisibleStartPoint(0)
                            
                            //.swipeOffsetTriggerAnimation(stiffness: 1000, damping: 70)
                            .padding(.horizontal)
                        }
                    }
                }
                .onDrop(of: ["SideMenuRowDragData.self"], delegate: CustomDropDelegate())
                
            }
            .frame(maxWidth: .infinity)
            // .listStyle(.plain)
            .background(Color.clear)
            //.animation(.linear, value: sideMenuViewModel.nodeArray)
            //ReorderableListView()
            //DemoDragRelocateView().frame(height: 800)
        }.onTapGesture {
            
        }
    }
}


struct CustomDropDelegate: DropDelegate {
    func validateDrop(info: DropInfo) -> Bool {
        // Customize validation logic here
        false
    }

    func dropEntered(info: DropInfo) {
        // Handle drop entered
    }

    func dropExited(info: DropInfo) {
        // Handle drop exited
    }

    func performDrop(info: DropInfo) -> Bool {
        // Handle the drop and process the data
        return true
    }
}

class SideMenuRowDragData: Identifiable, Codable, Transferable {
    var id = UUID()
    let name: String
    
    init(name: String) {
        self.name = name
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .plainText)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}


