//
//  TaskCardViews.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/30.
//

import SwiftUI



struct HabitTaskCardView: View {
    @StateObject var masterViewModel = TaskMasterViewModel.shared
    
    let taskType: TaskType
    let habit: HabitModel
    let todo: TodoModel
    let metric: GeometryProxy
    var tappedOne: String? {
        masterViewModel.tappedTaskId
    }
    let cardMaxHeight: Int
    let cardIdealHeight: Int
    let tapFunction: () -> Void
    
    func getTaskName() -> String {
        switch taskType {
        case .habit:
            habit.name
        case .todo:
            todo.name
        }
    }
    
    func isTaskDone() -> Bool {
        switch taskType {
        case .habit:
            habit.done ?? false
        case .todo:
            todo.done
        }
    }
    
    var body: some View {
        VStack{
            HStack {
                VStack {
                    
                    TaskCardTopView(name: getTaskName(), done: isTaskDone(), metric: metric, isExpanded: tappedOne == habit.id, cardMaxHeight: cardMaxHeight, cardIdealHeight: cardIdealHeight)
                        
                    HStack{
                        Text("\(habit.cycle.rawValue)")
                        if habit.type == .number {
                            Text("|").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                            Text("\(habit.numberProgress ?? 0)\(habit.numberTarget == nil ? "" : " / \(habit.numberTarget ?? 0)") \(habit.unit)").font(.system(size: 18, weight: .regular, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                        }
                        
                        if habit.type == .time {
                            Text("|").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                            Text("\(habit.timeProgress ?? "0:00")\(habit.timeTarget == nil ? "" : " / \(habit.timeTarget ?? "0:00")")").font(.system(size: 18, weight: .regular, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                        }
                        
                        Spacer()
                    }.font(.system(size: 18, weight: .regular, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                        
                }
            }
            .contentShape(Rectangle())
            
            
            
            
            
            
            //MARK: the detail view
            //
            if(tappedOne == habit.id) {
                HabitDetailView(habit: habit).onTapGesture {
                }
            }
            
            //Spacer()
            
        }
        
        .padding()
        //.background(.white.opacity(0.6))
        
        .background(
            Color.clear.background(.regularMaterial).environment(\.colorScheme, .light))
        
        .clipShape(RoundedRectangle(cornerRadius: 15))
        //.shadow(color: Color("Shadow"), radius: 2, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.6), lineWidth: 2).offset(y :1.5).blur(radius: 0).mask(RoundedRectangle(cornerRadius: 15))
        )
        
        .padding(.vertical, Task_Card_Vertical_Padding)
        .padding(.horizontal, 12)
    }
}

struct TaskCardTopView: View {
    let name: String
    let done: Bool
    let metric: GeometryProxy
    let isExpanded: Bool
    let cardMaxHeight: Int
    let cardIdealHeight: Int
    var body: some View {
        HStack(alignment: .center){
            HStack{
                ZStack {
                    Circle()
                    //.stroke(lineWidth: 2)
                        .fill(Color(uiColor: UIColor(red: 252 / 255, green: 236 / 255, blue: 232 / 255, alpha: 1)).opacity(1))
                    /*
                        .softOuterShadow(darkShadow: Color(uiColor: UIColor(red: 252 / 255, green: 236 / 255, blue: 232 / 255, alpha: 1)).darker(by: 8).opacity(1), lightShadow: Color(uiColor: UIColor(red: 252 / 255, green: 236 / 255, blue: 232 / 255, alpha: 1)).lighter(by: 8).opacity(1), offset: 1.2, radius: 1)
                    */
                    
                    
                        .frame(width: 28, height: 28)
                        .onTapGesture {
                            
                        }
                    CheckMarkShape().foregroundColor(done ? .pink.opacity(0.5) : .clear).frame(width: 26, height: 21).offset(x: -1, y: 0).mask(Circle().frame(width: 28, height: 28))
                }
                Text("\(name)")
                    .allowsTightening(true)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary.opacity(0.6))
                    .lineLimit(isExpanded ? 20 : 2)
                //.multilineTextAlignment(TextAlignment.leading)
                Spacer()
            }.frame(maxWidth: metric.size.width * 1)
            
            Spacer()
        }.frame(maxHeight: !isExpanded ? CGFloat(cardMaxHeight): CGFloat(cardIdealHeight))
    }
}

/*
struct editNumberView: View {
    var body: some View {
        
    }
}
 */

struct ContentView_Previews_TaskCard: PreviewProvider {
    static let overalViewModel = TaskMasterViewModel()
    
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        RootView(viewModel : overalViewModel).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


