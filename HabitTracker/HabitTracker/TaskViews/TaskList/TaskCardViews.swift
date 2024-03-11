//
//  TaskCardViews.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/30.
//

import SwiftUI



struct TaskCardView: View {
    @StateObject var masterViewModel = TaskMasterViewModel.shared
    
    let taskType: TaskType
    let habit: HabitModel
    let todo: TodoModel
    var tappedOne: String? {
        masterViewModel.tappedTaskId
    }
    
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
            TaskCardDigestView(taskType: taskType, habit: habit, todo: todo).animation(.none, value: masterViewModel.tappedTaskId)
            
            
            //MARK: the detail view
            

            if(tappedOne == habit.id) {
                HabitDetailView(habit: habit).onTapGesture {
                }
            }
            //Spacer()
            
        }
        
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        //.background(.white.opacity(0.6))
        .padding(.vertical, Task_Card_Vertical_Padding)
        .padding(.horizontal, Task_Card_Horizontal_Padding)
        
    }
}

struct TaskCardDigestView: View {
    @StateObject var masterViewModel = TaskMasterViewModel.shared
    
    let taskType: TaskType
    let habit: HabitModel
    let todo: TodoModel
    var tappedOne: String? {
        masterViewModel.tappedTaskId
    }
    
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
        let testColor = Color(uiColor: UIColor(red: CGFloat(Double(Int.random(in: 0...255)) / 255.0), green: CGFloat(Double(Int.random(in: 0...255)) / 255.0), blue: CGFloat(Double(Int.random(in: 0...255)) / 255.0), alpha: 1))
        HStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 3)
                .fill(backgroundGradientStart.opacity(0.6))
                .frame(width: 28, height: 28)
                .onTapGesture {
                    
                }
                /*
                    .softOuterShadow(darkShadow: Color(uiColor: UIColor(red: 252 / 255, green: 236 / 255, blue: 232 / 255, alpha: 1)).darker(by: 8).opacity(1), lightShadow: Color(uiColor: UIColor(red: 252 / 255, green: 236 / 255, blue: 232 / 255, alpha: 1)).lighter(by: 8).opacity(1), offset: 1.2, radius: 1)
                */
                
                
                    
                //CheckMarkShape().foregroundColor( .pink.opacity(0.5)).frame(width: 26, height: 21).offset(x: -1, y: 0).mask(Circle().frame(width: 28, height: 28))
            }
            VStack {
                
                TaskCardTopView(name: getTaskName(), done: isTaskDone(), isExpanded: tappedOne == habit.id)
                    
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
            /*
            Text("📗").font(.system(size: 20, weight: .light, design: .default))
                .foregroundColor(.primary.opacity(0.5))
                .padding(.trailing, 3).background{
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(testColor.opacity(0.2))
                        .frame(width: 36, height: 36, alignment: .center)
                    
                }
             */
            
            RoundedRectangle(cornerRadius: 3, style: .circular)
                .fill(testColor.opacity(0.2))
                .frame(width: 6, height: 34)
                
        }
        .contentShape(Rectangle())
    }
}

struct TaskCardTopView: View {
    let name: String
    let done: Bool
    let isExpanded: Bool
    var body: some View {
        HStack(alignment: .center){
            HStack(spacing: 0){
                
                
                Text("\(name)")
                    .allowsTightening(true)
                    
                    .lineLimit(1)
                //.multilineTextAlignment(TextAlignment.leading)
                Spacer()
            }.frame(maxWidth: .infinity)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.primary.opacity(0.75))
            Spacer()
        }.frame(maxHeight: !isExpanded ? CGFloat(230): CGFloat(230))
    }
}

/*
struct TaskCardBgView: View {
    var body: some View {
        VStack{}
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
            Color.clear.background(.thinMaterial).environment(\.colorScheme, .light))
        
        .clipShape(RoundedRectangle(cornerRadius: 15))
        //.shadow(color: Color("Shadow"), radius: 2, x: 0, y: 1)
        .overlay(
            RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.6), lineWidth: 2).offset(y :1.5).blur(radius: 0).mask(RoundedRectangle(cornerRadius: 15))
        )
        .padding(.vertical, Task_Card_Vertical_Padding)
        .padding(.horizontal, 12)
    }
}
*/
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


