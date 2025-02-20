//
//  Test.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/6/20.
//

import SwiftUI

import SwiftUI

struct ReorderableListView: View {
    @State private var items = ["Item 1", "Item 2", "Item 3", "Item 4"]
    @State private var editMode = EditMode.active

    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    Text(item)
                }
                .onMove(perform: move)
            }
            .navigationBarTitle("Reorderable List")
            //.navigationBarItems(trailing: EditButton())
            .environment(\.editMode, $editMode)
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        items.move(fromOffsets: source, toOffset: destination)
    }
}

struct ReorderableListView_Previews: PreviewProvider {
    static var previews: some View {
        ReorderableListView()
    }
}

