//
//  CustomViews.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/11.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @State var preselectedIndex: Int = 0
    var options: [String]
    let color = Color.gray.opacity(0.4)
    let onSelect: (Int) -> Void
    var body: some View {
        HStack(spacing: 0) {
            
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.2))
                        
                    if(index == 0) {
                        GeometryReader { m in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(backgroundGradientStart.opacity( 0.4))
                                .padding(3)
                                .offset(x: CGFloat((preselectedIndex)) * m.size.width, y: 0)
                        }
                    }
                    Text(options[index]).foregroundColor(.primary.opacity(index == preselectedIndex ? 0.7 : 0.2))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeIn(duration: 0.2)) {
                        if (preselectedIndex == index) {
                            return
                        }
                        preselectedIndex = index
                        onSelect(index)
                    }
                }
            }
        }
        .foregroundColor(.primary.opacity(0.4))
        .frame(height: 40)
        .cornerRadius(10)
    }
}

struct CustomViews_Previews: PreviewProvider {
    
    static var previews: some View {
        RootView(viewModel: TaskMasterViewModel.shared)
    }
}
