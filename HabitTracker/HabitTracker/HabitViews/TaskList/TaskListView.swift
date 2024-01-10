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
            
            
            test_Wrapper()
           
        }.font(.title)
    }
}

struct SubView: View {
    @State var change: Bool = false

    var body: some View {
        Rectangle()
            .frame(width: 200)
            .modifier(AnimatingCellHeight(height: change ? 300 : 200))
            .foregroundColor(Color.red)
            .onTapGesture {
                withAnimation {
                    self.change.toggle()
                }
            }
    }
}

struct AnimatingCellHeight: AnimatableModifier {
    var height: CGFloat = 0

    var animatableData: CGFloat {
        get { height }
        set { height = newValue }
    }

    func body(content: Content) -> some View {
        content.frame(height: height)
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
let testVC = TaskTableViewController()

struct test_Wrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        //let swiftUIView = InitView()
        //let hostingController = UIHostingController(rootView: swiftUIView)
        //hostingController.view.backgroundColor = .clear
        //hostingController.view.isHidden = true
        testVC.view.backgroundColor = .clear
        testVC.view.isHidden = false
        return testVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //uiViewController.view.isHidden = HabitTrackerViewModel.shared.tabIndex != .initial
        //tabView_hostingController.present(initView_hostingController, animated: true)
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        testVC.view.isHidden = true
    }
    
    typealias UIViewControllerType = UIViewController
}

