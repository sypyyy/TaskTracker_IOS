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
    @State var tappedOne: String?
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
        VStack{
            GeometryReader{ metric in
                ScrollView {
                    ScrollViewReader {v in
                        VStack{
                            
                            ForEach(masterViewModel.getDayTasks(), id: \.self.taskId) { task in
                                HabitTaskCardView(taskType: task.taskType, habit: convertTaskToHabitModel(task), todo: convertTaskToToDoModel(task), metric: metric, tappedOne: $tappedOne, cardMaxHeight: cardMaxHeight, cardIdealHeight: cardIdealHeight, tapFunction: {
                                    withAnimation(.default){
                                        v.scrollTo(task.taskId, anchor: .center)
                                        
                                        if tappedOne == task.taskId {
                                            tappedOne = nil
                                        } else {
                                            tappedOne = task.taskId
                                        }
                                        
                                        
                                    }
                                    
                                })
                            }
                            
                        }.padding(.bottom, 88)
                        
                    }
                }
                
            }
           
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

