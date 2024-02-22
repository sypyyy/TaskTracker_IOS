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
                    GlobalPopupManager.shared.hidePopup(reason: "user saved")
                    //number = ""
                    }
                
                RoundedRectangle(cornerRadius: 15).fill(.red.opacity(0.4)).frame(height: 45).overlay {
                    Image(systemName: "multiply").font(.system(size: 17, weight: .regular, design: .rounded))
                }.onTapGesture {
                    let newProgress = habit.numberProgress ?? 0 + (Int16(number) ?? 0)
                    viewModel.createRecord(habitID: habit.id, habitType: .number, habitCycle: habit.cycle, numberProgress: newProgress)
                    GlobalPopupManager.shared.hidePopup(reason: "user cancelled")
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
