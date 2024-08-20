//
//  HabitProgressModifyBottomSheet.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/3/28.
//

import SwiftUI
import Combine

struct HabitDetailBottomSheet: View {
    static let CONTENT_HORIZONTAL_PADDING: CGFloat = 12
    @State var isEditing = false
    @State var editingNumber = ""
    @FocusState var editingKeyboardFocued
    @StateObject var viewModel = HabitViewModel.shared
    var habit: HabitModel
    func getProgressText() -> String {
        if habit.type == .number {
            return "\(habit.numberProgress ?? 0)"
        } else {
            return habit.timeProgress ?? "0:00"
        }
    }
    func getTargetText() -> String {
        if habit.type == .number {
            return "\(habit.numberTarget ?? 0)"
        } else {
            return habit.timeTarget ?? "0:00"
        }
    }
    var body: some View {
        
        ScrollView {
            VStack{
               
                HabitNameAndDetailView(habit: habit)
                    .padding(.horizontal, HabitDetailBottomSheet.CONTENT_HORIZONTAL_PADDING)
                HabitDetailSection{
                    VStack{
                        HStack{
                            Text("\(habit.cycle.rawValue) progress")
                                .font(.system(size: 18, weight: .medium, design: .rounded))
                                .foregroundStyle(.primary.opacity(0.7))
                            Spacer()
                        }
                        HStack(spacing: 2) {
                            VStack {
                                if isEditing {
                                    if(habit.type == .number) {
                                        inputField(title: "", text: $editingNumber)
                                            .frame(width: 100)
                                            .padding(.trailing, -12)
                                            .keyboardType(.numberPad)
                                            .onReceive(Just(editingNumber)) { newValue in
                                                let filtered = newValue.filter { "0123456789".contains($0) }
                                                if filtered != newValue {
                                                    self.editingNumber = filtered
                                                }
                                            }
                                            .focused($editingKeyboardFocued)
                                            .onAppear{
                                                editingKeyboardFocued = true
                                            }
                                    }
                                    if(habit.type == .time) {
                                        
                                    }
                                } else {
                                    Text("\(getProgressText())")
                                        .contentTransition(.numericText())
                                        .animation(.default, value: habit.numberProgress)
                                        .offset(CGSize(width: 0, height: 3))
                                }
                            }
                            
                            Text("/")
                                .font(.system(size: 21, weight: .regular, design: .rounded))
                                .offset(.init(width: 0, height: 1))
                                .foregroundColor(.primary.opacity(0.5))
                                .padding(.leading, 2)
                            Text("\(getTargetText())")
                                .font(.system(size: 20, weight: .regular, design: .rounded))
                                .offset(.init(width: 0, height: 3))
                                .foregroundColor(.primary.opacity(0.6))
                            if(habit.type == .number) {
                                Text("\(habit.unit)")
                                    .foregroundColor(.primary.opacity(0.5))
                                    .font(.system(size: 21, weight: .regular, design: .rounded))
                                    .offset(.init(width: 0, height: 2))
                            }
                        }
                        .animation(.none, value: isEditing)
                        .font(.system(size: 22, weight: .regular, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        
                        let barLength: CGFloat = 280
                        VStack {
                            RoundedRectangle(cornerRadius: 12).fill(.gray.opacity(0.1)).frame(width: barLength, height: 12)
                                .overlay(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 12).fill(backgroundGradientStart.opacity(0.6)).frame(width: barLength * habit.getProgressPercent(), height: 12)
                                }
                                .animation(.easeIn, value: habit.numberProgress)
                                .animation(.easeIn, value: habit.timeProgress)
                        }.frame(maxWidth: barLength)
                            .padding(.bottom, 8)
                    }
                    
                    HabitProgressModifyControlPanel(isEditing: $isEditing, size: .largeBottomSheet, habit: habit)
                        .opacity(isEditing ? 0.8 : 1)
                        .disabled(isEditing)
                        .padding(.bottom, 20)
                }
                
                HabitDetailSection {
                    LazyVStack{
                        ForEach(1..<2) {i in
                            HStack {
                                Text("Recent Records")
                                Spacer()
                            }
                            
                        }
                    }.frame(maxWidth: .infinity)
                }
                
                HabitDetailSection {
                    LazyVStack{
                        ForEach(1..<12) {i in
                            HStack {
                                Text("Check in \(i)")
                                Spacer()
                            }
                            
                        }
                    }.frame(maxWidth: .infinity)
                }
                
            }.animation(.default, value: isEditing)
               // .padding(.horizontal)
        }.padding(.top, 20)
    }
}

struct HabitNameAndDetailView: View {
    var habit: HabitModel
    var body: some View {
        VStack(spacing: 2){
            HStack {
                Text("\(habit.name)")
                Spacer()
            }.font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(.primary.opacity(0.7))
            
            if habit.detail != "" {
                HStack{
                    Image(systemName: "note")
                    Text("\(habit.detail)").font(.system(size: 18, weight: .medium, design: .rounded)).lineLimit(30)
                    Spacer()
                }
                .foregroundStyle(.primary.opacity(0.7))
            }
        }
    }
}

struct HabitDetailSection<Content: View>: View {
    @ViewBuilder let content: () -> (Content)
    var body: some View {
        VStack{
            content()
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12.0, style: .continuous).fill(.white.opacity(0.3))
        }
        .clipped()
        .padding(.vertical, 6)
        .padding(.horizontal, HabitDetailBottomSheet.CONTENT_HORIZONTAL_PADDING)
        
    }
}


struct HabitProgressModifyBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            RootView()
            VStack{
                Spacer()
                VStack{
                    HabitDetailBottomSheet(habit: HabitViewModel.shared.getOngoingHabitViewModels().first!)
                        //.background(.blue.opacity(0.2))
                        //.padding()
                }
                
                .frame(maxWidth: .infinity)
                
                   .background(.ultraThinMaterial)
                   
                    .cornerRadius(16, corners: .allCorners)
            }
           // .ignoresSafeArea()
        }
    }
}
