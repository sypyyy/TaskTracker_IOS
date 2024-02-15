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
    @StateObject var masterViewModel: TaskMasterViewModel = TaskMasterViewModel.shared
    @StateObject var habitviewModel: HabitViewModel = HabitViewModel.shared
    let cardIdealHeight = 230
    let cardMaxHeight = 230
    @State var tappedOne: String? {
        didSet {
            masterViewModel.tappedTaskId = tappedOne
        }
    }
    @State var scaleRatio: CGFloat = 1.0
    
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
        
            /*
            List() {
                    ScrollViewReader {v in
                    
                        
                            ForEach(masterViewModel.getDayTasks(), id: \.self.taskId) { task in
                                /*
                                    HabitTaskCardView(taskType: task.taskType, habit: convertTaskToHabitModel(task), todo: convertTaskToToDoModel(task), metric: metric, cardMaxHeight: cardMaxHeight, cardIdealHeight: cardIdealHeight, tapFunction: { withAnimation {
                                        v.scrollTo(task.taskId, anchor: .center)
                                        if tappedOne == task.taskId {
                                            tappedOne = nil
                                        } else {
                                            tappedOne = task.taskId
                                        }
                                    }
                                    })
                                   */
                                
                                //.modifier(AnimatingCellHeight(height: tappedOne == task.taskId ? 280 : 80))
                                //.padding(.vertical)
                                
                                
                                
                                
                                
                            }
                            
                       
                        
                        
                        
                    }
                }
             */
            
            
            taskTable_Wrapper()
           
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
let taskTableVC = TaskTableViewController()

struct taskTable_Wrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        //let swiftUIView = InitView()
        //let hostingController = UIHostingController(rootView: swiftUIView)
        //hostingController.view.backgroundColor = .clear
        //hostingController.view.isHidden = true
        taskTableVC.view.backgroundColor = .clear
        taskTableVC.view.isHidden = false
        return taskTableVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //uiViewController.view.isHidden = HabitTrackerViewModel.shared.tabIndex != .initial
        //tabView_hostingController.present(initView_hostingController, animated: true)
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        taskTableVC.view.isHidden = true
    }
    
    typealias UIViewControllerType = UIViewController
}

