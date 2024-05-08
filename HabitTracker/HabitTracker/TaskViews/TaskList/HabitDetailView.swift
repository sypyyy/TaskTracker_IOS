//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/6/18.
//

import SwiftUI

//This file is deprecated for now, but kept because components may be useful
struct HabitDetailView: View{
    var habit: HabitModel {
        didSet {
        }
    }
    let spacing: CGFloat = 10
    let viewModel: HabitViewModel = HabitViewModel.shared
    var body: some View {
        
            VStack{
                Spacer().frame(height: spacing)
                Divider()
                Spacer().frame(height: spacing)
                if habit.detail != "" {
                    HStack{
                        Image(systemName: "note.text")
                        Text("\(habit.detail)").font(.system(size: 18, weight: .regular, design: .rounded)).lineLimit(30)
                        //Spacer()
                    }
                }
                Spacer().frame(height: spacing)
                HStack(){
                    if habit.type != .simple {
                        /*
                        (modifyButton(systemName: "minus", size: .smaller, color: .gray) ).onTapGesture {
                            displayPopup(operation: .minus)
                        }
                         */
                        MeasuredButton(action: { frame in
                            let popMgr = GlobalPopupManager.shared
                            if(popMgr.showPopup) {
                                popMgr.hidePopup(reason: "touched button again")
                                return
                            }
                            let view = HabitNumberModifyPopup(habit: habit, modifyType: .minus).id(UUID())
                            popMgr.showPopup(view: AnyView(view), sourceFrame: frame, center: true)
                        }) {
                            Image(systemName: "minus")
                        }
                        
                        
                        MeasuredButton(action: { frame in
                            let popMgr = GlobalPopupManager.shared
                            if(popMgr.showPopup) {
                                popMgr.hidePopup(reason: "touched button again")
                                return
                            }
                            let view = HabitNumberModifyPopup(habit: habit, modifyType: .set).id(UUID())
                            popMgr.showPopup(view: AnyView(view), sourceFrame: frame, center: true)
                        }) {
                            HabitProgressCircleView(habit: habit)
                        }
                         
                        
                        /*
                        modifyButton(systemName: "plus", size: .smaller, color: .gray).onTapGesture {
                            displayPopup(operation: .plus)
                        }
                         */
                        MeasuredButton(action: { frame in
                            let popMgr = GlobalPopupManager.shared
                            if(popMgr.showPopup) {
                                popMgr.hidePopup(reason: "touched button again")
                                return
                            }
                            let view = HabitNumberModifyPopup(habit: habit, modifyType: .add).id(UUID())
                            popMgr.showPopup(view: AnyView(view), sourceFrame: frame, center: true)
                        }) {
                            Image(systemName: "plus")
                        }
                        Image(systemName: "gobackward")
                        
                    }
                }.font(.system(size: 15, weight: .bold, design: .rounded))
                /*
                HStack(spacing: 10.0){
                    
                    if habit.type != .simple {
                        RoundedRectangle(cornerRadius: 15).fill(.green.opacity(0.4)).frame(height: 45).overlay {
                            Image(systemName: "checkmark").font(.system(size: 17, weight: .bold, design: .rounded))
                        }
                        .onTapGesture {
                            if habit.type == .number, let p = habit.numberProgress, let t = habit.numberTarget, p > t {
                                return
                            }
                            if habit.type == .time, let p = habit.timeProgress, let t = habit.timeTarget, p.timeToMinutes() > t.timeToMinutes() {
                                return
                            }
                            viewModel.createRecord(habitID: habit.id, habitType: habit.type, habitCycle: habit.cycle, numberProgress: habit.numberTarget ?? 0, timeProgress: habit.timeTarget ?? "0:00")
                        }
                        
                        
                        if habit.type == .time {
                            RoundedRectangle(cornerRadius: 15).fill(.yellow.opacity(0.4)).frame(width: 45, height: 45).overlay {
                                Image(systemName: "alarm").font(.system(size: 17, weight: .bold, design: .rounded))
                            }.onTapGesture {
                                
                            }
                        }
                        
                        RoundedRectangle(cornerRadius: 15).fill(.red.opacity(0.4)).frame(height: 45).overlay {
                            Image(systemName: "gobackward").font(.system(size: 17, weight: .bold, design: .rounded))
                        }.onTapGesture {
                            viewModel.createRecord(habitID: habit.id, habitType: habit.type, habitCycle: habit.cycle, numberProgress: 0, timeProgress: "0:00")
                        }
                    }
                    else {
                        
                         modifyButton(systemName: "checkmark", size: .medium).onTapGesture {
                         viewModel.createRecord(habitID: habit.id, habitType: habit.type, habitCycle: habit.cycle, done: true)
                         }
                         modifyButton(systemName: "gobackward", size: .medium).onTapGesture {
                         viewModel.createRecord(habitID: habit.id, habitType: habit.type, habitCycle: habit.cycle, done: false)
                         }
                        
                        /*
                        RoundedRectangle(cornerRadius: 15).fill(.green.opacity(0.4)).frame(height: 45).overlay {
                            Image(systemName: "checkmark").font(.system(size: 17, weight: .bold, design: .rounded))
                        }.onTapGesture {
                            viewModel.createRecord(habitID: habit.id, habitType: habit.type, habitCycle: habit.cycle, done: true)
                            }
                        
                        RoundedRectangle(cornerRadius: 15).fill(.red.opacity(0.4)).frame(height: 45).overlay {
                            Image(systemName: "gobackward").font(.system(size: 17, weight: .bold, design: .rounded))
                        }.onTapGesture {
                            viewModel.createRecord(habitID: habit.id, habitType: habit.type, habitCycle: habit.cycle, done: false)
                            }
                        */
                    }
                    
                    
                }
                */
                
            }.font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.primary.opacity(0.6))
        
    }
}

//点击更改按钮后的逻辑
extension HabitDetailView {
    
    private enum OperationType {
        case minus, plus, setTo, timer
    }
    
    private func displayPopup(operation: OperationType) {
        let habitType = habit.type
        var title = ""
        switch operation {
        case .minus:
            title = "Reduce progress by"
        case .plus:
            title = "Add progress by"
        case .setTo:
            title = "Set progress to"
        case .timer:
            title = "Timer"
        }
        if habitType == .number {
            PopupManager.shared.displayPopup(showType: .habitDetailNumberModify, title: title, callback: PopupManager.habitDetailNumberModify_CallBack(saveFunc: {numberInput in
                var progress: Int16 = 0
                if let number = habit.numberProgress {
                    progress = number
                }
                var newProgress: Int16
                switch operation {
                case .minus:
                    newProgress = progress - numberInput
                    newProgress = newProgress < 0 ? 0 : newProgress
                case .plus:
                    newProgress = progress + numberInput
                case .setTo:
                    newProgress = numberInput
                case .timer:
                    return
                }
                viewModel.createRecord(habitID: habit.id, habitType: .number, habitCycle: habit.cycle, numberProgress: newProgress)
            }))
        }
        else if habitType == .time {
            PopupManager.shared.displayPopup(showType: .habitDetailTimeModify, title: title, callback: PopupManager.habitDetailTimeModify_CallBack(saveFunc: {hourInput, minuteInput in
                var progress = 0
                if let time = habit.timeProgress {
                    progress = time.timeToMinutes()
                }
                let change = hourInput * 60 + minuteInput
                var newProgress: Int
                switch operation {
                case .minus:
                    newProgress = progress - change
                    newProgress = newProgress < 0 ? 0 : newProgress
                case .plus:
                    newProgress = progress + change
                case .setTo:
                    newProgress = change
                case .timer:
                    return
                }
                viewModel.createRecord(habitID: habit.id, habitType: .time, habitCycle: habit.cycle, timeProgress: newProgress.minutesToTime())
            }))
        }
       
    }
}

//更改按钮
extension HabitDetailView {
    
    private enum ModifyButtonSize {
        case smaller, larger, medium
    }
    
    private func modifyButton(systemName: String, size: ModifyButtonSize, color: ButtonColor = .main) -> some View {
        var buttonFunc = buttonHorizontal
        switch size {
            /*
             case .larger:
             return Image(systemName: systemName).frame(width: 12, height: 8).font(.system(size: 18, weight: .bold, design: .rounded)).buttonHorizontal(color: color)
             case .smaller:
             return Image(systemName: systemName).frame(width: 8, height: 8).font(.system(size: 10, weight: .bold, design: .rounded)).buttonHorizontal(color: color)
             case .medium:
             return Image(systemName: systemName).frame(width: 10, height: 5).font(.system(size: 13, weight: .bold, design: .rounded)).buttonHorizontal(color: color)
             }
             */
        default:
            return Image(systemName: systemName)
                .frame(width: 50)
                .frame(height: 50)
                .background(
                    Color.clear.background(.ultraThinMaterial).environment(\.colorScheme, .light))
            
                .clipShape(RoundedRectangle(cornerRadius: 35, style: .continuous))
                .shadow(color: Color("Shadow"), radius: 2, x: 0, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 35, style: .continuous).stroke(.white.opacity(0.6), lineWidth: 2).offset(y :0.5).blur(radius: 0).mask(RoundedRectangle(cornerRadius: 35))
                )
            
        }
    }
    
    
    //圆圈进度条
    struct HabitProgressCircleView: View{
        let habit: HabitModel
        let viewModel: TaskMasterViewModel = TaskMasterViewModel.shared
        var body: some View {
            ZStack {
                let progressInPercent = habit.getProgressPercent()
                /*
                 Circle().stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .miter)).fill(Color("Background").opacity(0.8)).frame(width: 100.0, height: 100.0, alignment: .center).rotationEffect(Angle(degrees: -90))
                 Circle().trim(from: 0, to: progressInPercent)
                 .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .miter)).fill(backgroundGradientStart).frame(width: 100.0, height: 100.0, alignment: .center).rotationEffect(Angle(degrees: -90))
                 */
                
                VStack{
                    if habit.type == .number {
                        Text("\(habit.numberProgress ?? 0)").font(.system(size: 21, weight: .medium, design: Font.Design.rounded))
                            .contentTransition(.numericText())
                    }
                    if habit.type == .time {
                        Text("\(habit.timeProgress ?? "0:00")").font(.system(size: 21, weight: .medium, design: Font.Design.rounded))
                    }
                }
                .padding()
                
                .background(
                    Color.white.opacity(0.4)
                        .environment(\.colorScheme, .light))
                
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                
                
                
            }
            .animation(.default, value: viewModel.selectedDate)
            .animation(.easeInOut(duration: 0.3), value: habit.numberProgress)
            .animation(.easeInOut(duration: 0.3), value: habit.timeProgress)
            .animation(.easeInOut(duration: 0.3), value: habit.numberTarget)
            .animation(.easeInOut(duration: 0.3), value: habit.timeTarget)
        }
    }
}
    
   
    
    struct HabitDetailView_Previews: PreviewProvider {
        static var previews: some View {
            RootView(viewModel: TaskMasterViewModel.shared)
        }
    }

