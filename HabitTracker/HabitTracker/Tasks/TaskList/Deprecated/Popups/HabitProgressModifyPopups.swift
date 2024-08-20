//
//  HabitProgressModifyPopups.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/15.
//

import SwiftUI
import Combine



enum ModifyType {
    case add,minus,set
}

@MainActor
struct HabitNumberModifyPopup: View {
    @State var number: String = ""
    @FocusState private var keyboardFocused: Bool
    var habit: HabitModel
    let viewModel = HabitViewModel.shared
    var modifyType: ModifyType
    var title: String {
        switch modifyType {
        case .add:
            return "Add progress by"
        case .minus:
            return "Minus progress by"
        case .set:
            return "Set progress to"
        }
    }
    func caculateNewProgress() -> Int16 {
        switch modifyType {
        case .add:
            return (habit.numberProgress ?? 0) + (Int16(number) ?? 0)
        case .minus:
            let res = (habit.numberProgress ?? 0) - (Int16(number) ?? 0)
            return res < 0 ? 0 : res
        case .set:
            return (Int16(number) ?? 0)
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            Text("\(title)").padding(.vertical).font(.system(size: 18, weight: .bold, design: .rounded))
            
            //TextField("Total number of people", text: $number)
                        
            inputField(title: "", text: $number)
                .keyboardType(.numberPad)
                .onReceive(Just(number)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.number = filtered
                    }
                }
                .focused($keyboardFocused)
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        keyboardFocused = true
                    }
                }
            let test = print("rendered add popover")
            
            HStack {
                RoundedRectangle(cornerRadius: 15).fill(.green.opacity(0.4)).frame(height: 45).overlay {
                    Image(systemName: "checkmark").font(.system(size: 17, weight: .regular, design: .rounded))
                }.onTapGesture {
                    let newProgress = caculateNewProgress()
                    viewModel.createRecord(habitID: habit.id, habitType: .number, habitCycle: habit.cycle, numberProgress: newProgress)
                    keyboardFocused = false
                    SwiftUIGlobalPopupManager.shared.hidePopup(reason: "user saved")
                    //number = ""
                    }
                
                RoundedRectangle(cornerRadius: 15).fill(.red.opacity(0.4)).frame(height: 45).overlay {
                    Image(systemName: "multiply").font(.system(size: 17, weight: .regular, design: .rounded))
                }.onTapGesture {
                    keyboardFocused = false
                    SwiftUIGlobalPopupManager.shared.hidePopup(reason: "user cancelled")
                    //number = ""
                    }
            }.padding()
            
            /*
            Button (action:{
                let newProgress = habit.numberProgress ?? 0 + (Int16(number) ?? 0)
                viewModel.createRecord(habitID: habit.id, habitType: .number, habitCycle: habit.cycle, numberProgress: newProgress)
                GlobalPopupManager.shared.hidePopup(reason: "user saved")
                }){
                    HStack(alignment: .center){
                        Spacer()
                        Text("Done").fontWeight(.medium)
                        Spacer()
                    }
                    .padding(.vertical)
                }
             */
        }.frame(width: 290)
            .foregroundStyle(.primary.opacity(0.7))
    }
}

fileprivate struct ControlPanelButtonBackground: ViewModifier {
    let color: Color
    let size: PanelUseCase
    var preferredSize: CGFloat {
        switch size {
        case .largeBottomSheet:
            40
        case .smallPopover:
            30
        }
    }
    var horizontalPadding: CGFloat {
        switch size {
        case .largeBottomSheet:
            return 4
        case .smallPopover:
            return 0
        }
    }
    var cornerRadius: CGFloat {
        switch size {
        case .largeBottomSheet:
            return 16
        case .smallPopover:
            return 12
        }
    }
    func body(content: Content) -> some View {
        content
            .frame(height: preferredSize)
            .frame(minWidth: preferredSize)
            .background(RoundedRectangle(cornerRadius: cornerRadius, style: .circular).foregroundColor(color))
            .padding(.horizontal, horizontalPadding)
    }
}

fileprivate extension View {
    func addControlPanelBackground(color: Color = .white.opacity(0.4), size: PanelUseCase) -> some View {
        self.modifier(ControlPanelButtonBackground(color: color, size: size))
    }
}

enum PanelUseCase {
    case smallPopover, largeBottomSheet
}

@MainActor
struct HabitProgressModifyControlPanel: View {
    @Binding var isEditing: Bool
    var size: PanelUseCase
    var habit: HabitModel
    let viewModel = HabitViewModel.shared
    func caculateNewProgress(modifyType: ModifyType, number: Int) -> Int16 {
        switch modifyType {
        case .add:
            return (habit.numberProgress ?? 0) + (Int16(number))
        case .minus:
            let res = (habit.numberProgress ?? 0) - (Int16(number))
            return res < 0 ? 0 : res
        case .set:
            return (Int16(number))
        }
    }
    var body: some View {
        
        VStack {
            
            
            HStack{
                Button{
                    let newProgress = max(0, (habit.numberProgress ?? 0) - 1)
                    viewModel.createRecord(habitID: habit.id, habitType: .number, habitCycle: habit.cycle, numberProgress: newProgress)
                    habit.numberProgress? = newProgress
                    //GlobalPopupManager.shared.hidePopup(reason: "user saved")
                } label: {
                    HStack(spacing: 0) {
                        Image(systemName: "arrowtriangle.down.fill")
                            .foregroundColor(.primary.opacity(0.5))
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                        Text("1")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                    }.addControlPanelBackground(size: size)
                    
                }
                /*
                 Button{
                 
                 } label: {
                 
                 Image(systemName: "arrowtriangle.down.fill")
                 .foregroundColor(.primary.opacity(0.5))
                 .addControlPanelBackground()
                 }
                 */
                
                Button{
                    isEditing = true
                    if !isEditing {
                        let popMgr = SwiftUIGlobalPopupManager.shared
                        popMgr.hidePopup(reason: "showing next popover")
                        if(popMgr.showPopup) {
                            popMgr.hidePopup(reason: "touched button again")
                            return
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            let view = HabitNumberModifyPopup(habit: habit, modifyType: .set).id(UUID())
                            popMgr.showPopup(view: AnyView(view), sourceFrame: .zero, center: true)
                        }
                    }
                } label: {
                    Image(systemName: "pencil.line")
                        .addControlPanelBackground(size: size)
                }
                /*
                 Button{
                 
                 } label: {
                 
                 Image(systemName: "arrowtriangle.up.fill")
                 .foregroundColor(.primary.opacity(0.5))
                 .addControlPanelBackground()
                 }
                 */
                
                Button{
                    let newProgress = min((habit.numberProgress ?? 0) + 1, Int16.max)
                    viewModel.createRecord(habitID: habit.id, habitType: .number, habitCycle: habit.cycle, numberProgress: newProgress)
                    habit.numberProgress? = newProgress
                } label: {
                    HStack(spacing: 0) {
                        Image(systemName: "arrowtriangle.up.fill")
                            .font(.system(size: 12, weight: .regular, design: .rounded))
                            .foregroundColor(.primary.opacity(0.5))
                        Text("1")
                            .font(.system(size: 18, weight: .regular, design: .rounded))
                    }.addControlPanelBackground(size: size)
                    
                }
                
                Button{
                    
                } label: {
                    Image(systemName: "gobackward").addControlPanelBackground(color: .red.lighter(by: 50), size: size)
                    
                }
                
            }
            .foregroundColor(.primary.opacity(0.6))
            
        }
        //.animation(.default, value: test)
    }
}


struct HabitNumberProgressModifyControlPanelPreview: PreviewProvider {
    static var previews: some View {
        ZStack{
            RootView()
            VStack{
                Spacer()
                VStack{
                    HabitDetailBottomSheet(habit: HabitViewModel.shared.getOngoingHabitViewModels().first!)
                        //.background(.blue.opacity(0.2))
                        .padding()
                }
                
                .frame(maxWidth: .infinity)
                
                   .background(.ultraThinMaterial)
                   
                    .cornerRadius(16, corners: .allCorners)
            }
            .ignoresSafeArea()
        }
        
    }
}


struct HabitTimeProgressModifyControlPanelPreview: PreviewProvider {
    static var previews: some View {
        ZStack{
            RootView()
            VStack{
                Spacer()
                VStack{
                    HabitDetailBottomSheet(habit: HabitViewModel.shared.getOngoingHabitViewModels().first(where: {
                        $0.type == .time
                    }) ?? HabitModel())
                        //.background(.blue.opacity(0.2))
                        .padding()
                }
                
                .frame(maxWidth: .infinity)
                
                   .background(.ultraThinMaterial)
                   
                    .cornerRadius(16, corners: .allCorners)
            }
            .ignoresSafeArea()
        }
        
    }
}
