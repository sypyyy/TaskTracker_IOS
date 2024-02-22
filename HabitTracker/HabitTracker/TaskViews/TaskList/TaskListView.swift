//
//  TaskListView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/11.
//

import Foundation
import SwiftUI
import Neumorphic


struct TaskListView : View {
    let masterViewModel: TaskMasterViewModel = TaskMasterViewModel.shared
    @StateObject var habitviewModel: HabitViewModel = HabitViewModel.shared
    let cardIdealHeight = 230
    let cardMaxHeight = 230
    
    private func convertTaskToToDoModel(_ task: TaskModel) -> TodoModel {
        let emptyTodo: TodoModel = .init()
        return task as? TodoModel ?? emptyTodo
    }
    
    private func convertTaskToHabitModel(_ task: TaskModel) -> HabitModel {
        let emptyHabit: HabitModel = .init()
        return task as? HabitModel ?? emptyHabit
    }
    
    var body : some View {
        GeometryReader{ metric in
            taskTable_Wrapper(metric: metric.frame(in: .global))
                
           
        }.font(.title)
    }
}


struct ContentView_Previews_TaskList: PreviewProvider {
    static let overalViewModel = TaskMasterViewModel()
    
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        RootView(viewModel : overalViewModel).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


import UIKit

@MainActor
struct taskTable_Wrapper: UIViewControllerRepresentable {
    var metric: CGRect
    
    func makeUIViewController(context: Context) -> UIViewController {
        let taskTableVC = TaskTableViewController(frame: metric)
        taskTableVC.view.isHidden = false
        return taskTableVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        print("update called!")
        
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        uiViewController.view.isHidden = true
    }
    
}

