//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/4/20.
//

import SwiftUI

private struct MainWindowSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var mainWindowSize: CGSize {
        get { self[MainWindowSizeKey.self] }
        set { self[MainWindowSizeKey.self] = newValue }
    }
}

@main
struct HabitTrackerApp: App {
    //let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let overalViewModel = HabitTrackerViewModel.shared
            //Text("djeshdfhke WTF????")
            
                RootView(viewModel : overalViewModel)
            
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
