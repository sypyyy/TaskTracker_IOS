//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/4/20.
//

import SwiftUI


@main
struct HabitTrackerApp: App {
    //let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let overalViewModel = HabitTrackerViewModel.shared
            RootView(viewModel : overalViewModel)
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
