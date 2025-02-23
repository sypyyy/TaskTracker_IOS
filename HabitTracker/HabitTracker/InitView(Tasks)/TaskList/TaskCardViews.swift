//
//  TaskCardViews.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/12/30.
//

import SwiftUI


struct TaskCardView: View {
    @State var isSheetPresent = false
    @StateObject var masterViewModel = MasterViewModel.shared
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
                //HabitDetailView(habit: habit).onTapGesture {}
            }
            //Spacer()
            /*
            PSButton(
                isPresenting: $isSheetPresent,
                label: {
                    Text("Display the Partial Sheet")
                })
             */
        }
        
        /*
        .partialSheet(isPresented: $isSheetPresent,type: .scrollView(height: 300, showsIndicators: false),  iPhoneStyle: .init(background: .blur(.ultraThin), handleBarStyle: .solid(backgroundGradientStart.darker(by: 24)), cover: .enabled(.black.opacity(0.05)), cornerRadius: 12)) {
            CreatTaskForm(viewModel: HabitViewModel.shared)
        }
         */
        //.attachPartialSheetToRoot()
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        //.background(.white.opacity(0.6))
        .padding(.bottom, 2 * Task_Card_Vertical_Padding)
        .padding(.horizontal, Task_Card_Horizontal_Padding)
        
    }
}

struct TaskCardDigestView: View {
    @State var isEditingProgressUsingPopup = false
    @StateObject var masterViewModel = MasterViewModel.shared
    let habitViewModel = HabitViewModel.shared
    let persistenceController = PersistenceController.preview
    let taskType: TaskType
    let habit: HabitModel
    let todo: TodoModel
    var tappedOne: String? {
        masterViewModel.tappedTaskId
    }
    
    func getTaskName() -> String {
        switch taskType {
        case .habit:
            return habit.name
        case .todo:
            return todo.name
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
                    switch taskType {
                    case .habit:
                        guard let done = habit.done else {return}
                        switch habit.type {
                        case .number:
                            let newProgress = done ? 0 : Int16(habit.numberTarget ?? 0)
                            habitViewModel.createRecord(habitID: habit.id, habitType: .number, habitCycle: habit.cycle, numberProgress: newProgress)
                            
                        case .time:
                            if let newProgress = done ? "0:00" : habit.timeTarget {
                                habitViewModel.createRecord(habitID: habit.id, habitType: .time, habitCycle: habit.cycle, timeProgress: newProgress)
                            }
                        case .simple:
                            habitViewModel.createRecord(habitID: habit.id, habitType: .simple, habitCycle: habit.cycle, done: !done)
                        }
                        
                        break
                    case .todo:
                        todo.done.toggle()
                        persistenceController.modifyTodo(dataModel: todo)
                        masterViewModel.didReceiveChangeMessage(msg: .taskStateChanged)
                    }
                }
                /*
                    .softOuterShadow(darkShadow: Color(uiColor: UIColor(red: 252 / 255, green: 236 / 255, blue: 232 / 255, alpha: 1)).darker(by: 8).opacity(1), lightShadow: Color(uiColor: UIColor(red: 252 / 255, green: 236 / 255, blue: 232 / 255, alpha: 1)).lighter(by: 8).opacity(1), offset: 1.2, radius: 1)
                */
                
                
                if(isTaskDone()) {
                    CheckMarkShape().foregroundColor( .pink.opacity(0.3)).frame(width: 24, height: 18).offset(x: -1, y: 0).mask(Circle().frame(width: 28, height: 28))
                }
                
            }
            VStack(spacing: 1) {
                
                TaskCardTopView(name: getTaskName(), done: isTaskDone(), isExpanded: tappedOne == habit.id)
                    
                HStack{
                    Text("\(habit.cycle.rawValue)")
                    if habit.type == .number {
                        Text("|").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                        MeasuredButton(action: { frame in
                            let view = HabitProgressModifyControlPanel(isEditing: .constant(false), size: .smallPopover, habit: habit)
                            SwiftUIGlobalPopupManager.shared.showPopup(view: AnyView(view), sourceFrame: frame, center: false)
                             
                        }) {
                            HStack(spacing: 2) {
                                Text("\(habit.numberProgress ?? 0)")
                                    .contentTransition(.numericText())
                                    .animation(.default, value: habit.numberProgress)
                                    
                                Text("/")
                                    
                                Text("\(habit.numberTarget ?? 0)")
                                Text(" \(habit.unit)")
                                    .foregroundColor(.primary.opacity(0.6))
                                    .font(.system(size: 14, weight: .regular, design: .rounded))
                            }
                            .font(.system(size: 16, weight: .regular, design: .rounded)).foregroundColor(.primary.opacity(0.6)).padding(4).background(RoundedRectangle(cornerRadius: 6).foregroundStyle(backgroundGradientStart.opacity(0.3)))
                        }
                        //This id is neccessary because cell reuse causes unexpected animation:
                        //eg. when u select date the number just animates from another cell's number to the correct one
                        .id(habit.id)
                        .scaleEffect(isEditingProgressUsingPopup ? 1.05 : 1)
                        .animation(.spring, value: isEditingProgressUsingPopup)
                    }
                    
                    if habit.type == .time {
                        Text("|").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                        Text("\(habit.timeProgress ?? "0:00")\(habit.timeTarget == nil ? "" : " / \(habit.timeTarget ?? "0:00")")").font(.system(size: 18, weight: .regular, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                    }
                    
                    Spacer()
                }.font(.system(size: 18, weight: .regular, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                    .scaleEffect(0.8, anchor: .leading)
                    
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
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .foregroundColor(.primary.lighter(by: 35))
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
    static let overalViewModel = MasterViewModel()
    
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        RootView(viewModel : overalViewModel).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


