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
    let masterViewModel: MasterViewModel = MasterViewModel.shared
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
        ZStack {
            GeometryReader{ metric in
                    taskTable_Wrapper(metric: metric.frame(in: .global))
                   
                }.font(.title)
            /*
            VStack{
                // takes in image system names
                InitialViewCustomSegmentedControl(preselectedIndex: 0, options: ["calendar.day.timeline.leading","flag","folder","square.on.circle"]) {idx in
                    var sortBy = TaskTableSortBy.time
                    if idx == 0 {
                        sortBy = .time
                    } else if idx == 1 {
                        sortBy = .priority
                    } else if idx == 2 {
                        sortBy = .goal
                    } else if idx == 3 {
                        sortBy = .habitOrTodo
                    }
                    masterViewModel
                        .sortBy(by: sortBy)
                    
                }
                Spacer()
            }
             */
        }
        
        
    }
}


struct ContentView_Previews_TaskList: PreviewProvider {
    static let overalViewModel = MasterViewModel()
    
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

