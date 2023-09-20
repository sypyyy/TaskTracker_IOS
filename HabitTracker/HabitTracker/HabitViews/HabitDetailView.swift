//
//  HabitDetailView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/6/18.
//

import SwiftUI

struct HabitDetailView: View{
    var habit: habitViewModel {
        didSet {
            print("syppppppppppdsdsefe\(habit)")
        }
    }
    let spacing: CGFloat = 10
    let viewModel: habitTrackerViewModel = habitTrackerViewModel.shared
    var body: some View {
        VStack{
            Spacer().frame(height: spacing)
            Divider()
            Spacer().frame(height: spacing)
            if habit.detail != "" {
                HStack{
                    Image(systemName: "note.text")
                    Text("\(habit.detail)").font(.system(size: 18, weight: .regular, design: .rounded))
                    Spacer()
                }
            }
            Spacer().frame(height: spacing)
            HStack(spacing: 20.0){
                if habit.type != .simple {
                    (modifyButton(systemName: "minus", size: .smaller, color: .gray) ).onTapGesture {
                        displayPopup(operation: .minus)
                    }
                    HabitProgressCircleView(habit: habit).padding(.bottom, 10)
                    modifyButton(systemName: "plus", size: .smaller, color: .gray).onTapGesture {
                        displayPopup(operation: .plus)
                    }
                }
            }.font(.system(size: 15, weight: .bold, design: .rounded))
            HStack(spacing: 5.0){
                if habit.type != .simple {
                    modifyButton(systemName: "checkmark", size: .medium).onTapGesture {
                        if habit.type == .number, let p = habit.numberProgress, let t = habit.numberTarget, p > t {
                            return
                        }
                        if habit.type == .time, let p = habit.timeProgress, let t = habit.timeTarget, p.timeToMinutes() > t.timeToMinutes() {
                            return
                        }
                        viewModel.createRecord(habitID: habit.id, habitType: habit.type, numberProgress: habit.numberTarget ?? 0, timeProgress: habit.timeTarget ?? "0:00")
                    }
                    
                    modifyButton(systemName: "pencil.line", size: .larger).onTapGesture {
                        displayPopup(operation: .setTo)
                    }
                    if habit.type == .time {
                        modifyButton(systemName: "alarm", size: .larger).onTapGesture {
                            
                        }
                    }
                   
                    modifyButton(systemName: "gobackward", size: .medium).onTapGesture {
                        viewModel.createRecord(habitID: habit.id, habitType: habit.type, numberProgress: 0, timeProgress: "0:00")
                    }
                }
                else {
                    modifyButton(systemName: "checkmark", size: .medium)
                    modifyButton(systemName: "gobackward", size: .medium)
                }
            }
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
        if habitType == .number {
            PopupManager.shared.displayPopup(showType: .habitDetailNumberModify, callback: PopupManager.habitDetailNumberModify_CallBack(saveFunc: {numberInput in
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
                viewModel.createRecord(habitID: habit.id, habitType: .number, numberProgress: newProgress)
            }))
        }
        else if habitType == .time {
            PopupManager.shared.displayPopup(showType: .habitDetailTimeModify, callback: PopupManager.habitDetailTimeModify_CallBack(saveFunc: {hourInput, minuteInput in
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
                viewModel.createRecord(habitID: habit.id, habitType: .time, timeProgress: newProgress.minutesToTime())
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
        case .larger:
            return Image(systemName: systemName).frame(width: 12, height: 8).font(.system(size: 18, weight: .bold, design: .rounded)).buttonHorizontal(color: color)
        case .smaller:
            return Image(systemName: systemName).frame(width: 8, height: 3).font(.system(size: 10, weight: .bold, design: .rounded)).buttonHorizontal(color: color)
        case .medium:
            return Image(systemName: systemName).frame(width: 10, height: 5).font(.system(size: 13, weight: .bold, design: .rounded)).buttonHorizontal(color: color)
        }
        
    }
}

//圆圈进度条
struct HabitProgressCircleView: View{
    let habit: habitViewModel
    var body: some View {
        ZStack {
            let progressInPercent = habit.getProgressPercent()
            Circle().stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .miter)).fill(.regularMaterial).frame(width: 100.0, height: 100.0, alignment: .center).rotationEffect(Angle(degrees: -90))
            Circle().trim(from: 0, to: progressInPercent).stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .miter)).fill(backgroundGradientStart).frame(width: 100.0, height: 100.0, alignment: .center).rotationEffect(Angle(degrees: -90))
            if habit.type == .number {
                Text("\(habit.numberProgress ?? 0) / \(habit.numberTarget ?? 0)")
            }
            if habit.type == .time {
                Text("\(habit.timeProgress ?? "0:00") / \(habit.timeTarget ?? "0:00")").frame(maxWidth: 70)
            }
        }.animation(.easeInOut(duration: 1.0), value: habit.numberProgress)
        .animation(.easeInOut(duration: 1.0), value: habit.timeProgress)
        .animation(.easeInOut(duration: 1.0), value: habit.numberTarget)
        .animation(.easeInOut(duration: 1.0), value: habit.timeTarget)
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: habitTrackerViewModel.shared)
    }
}
