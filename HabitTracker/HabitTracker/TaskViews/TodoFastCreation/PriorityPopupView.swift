//
//  PriorityPopupView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/5/27.
//

import SwiftUI

struct PriorityPopupView: View {
    let editingTodo: TodoModel
    @State var selectedPriority: TodoPriority = .none
    var options: [TodoPriority] = [.high, .medium, .low, .none]
    
    var body: some View {
        let scaleRatio = 1.2
        let rowHeight: CGFloat = 35
        let width: CGFloat = 220
        ZStack {
            VStack(spacing: 0){
                RoundedRectangle(cornerRadius: 10)
                    .fill(selectedPriority.color.opacity(0.2))
                    .frame(width: width, height: rowHeight)
                    .offset(y: rowHeight * CGFloat(options.firstIndex(of: selectedPriority) ?? 0))
                Spacer()
            }
            
            VStack(spacing: 0) {
                ForEach(options, id: \.self.rawValue) { priority in
                    Button(action: {
                        selectedPriority = priority
                        editingTodo.priority = priority
                    }, label: {
                        HStack {
                            Group {
                                if(priority == .none) {
                                    Image(systemName: "flag.slash.fill")
                                } else {
                                    Image(systemName: "flag.fill")
                                }
                            }
                            .foregroundColor(priority.color)
                            .scaleEffect(priority == selectedPriority ? scaleRatio : 1)
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                            
                            
                            Text(priority.description)
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .foregroundColor(.primary.opacity(0.6))
                            Spacer()
                        }
                        .padding(.horizontal, 6)
                        .frame(height: rowHeight)
                        
                    })
                }
            }
        }
        .frame(width: width)
        .frame(height: rowHeight * 4)
        .animation(.easeIn(duration: 0.2), value: selectedPriority)
    }
}

struct PriorityPopupView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            PriorityPopupView(editingTodo: TodoModel())
                .background(.thinMaterial)
        }
    }
}

