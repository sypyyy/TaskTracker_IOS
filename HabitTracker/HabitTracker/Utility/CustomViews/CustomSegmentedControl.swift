//
//  CustomViews.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/11.
//

import SwiftUI

struct CustomSegmentedControlLabel<T: View>: View {
    @Binding var preselectedIndex: Int
    var index: Int
    var content: (Bool) -> T
    var body: some View {
        content(index == preselectedIndex)
    }
}

struct CustomSegmentedControl<T: View>: View {
    @State var preselectedIndex: Int = 0
    var optionLabels: [(Bool) -> T]
    var slidingBlockColors: [Color] = []
    let color = Color.gray.opacity(0.4)
    let onSelect: (Int) -> Void
    
    var body: some View {
        if slidingBlockColors.count != 0 && slidingBlockColors.count != optionLabels.count {
            fatalError()
        }
        HStack(spacing: 0) {
            
            ForEach(optionLabels.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.2))
                        
                    if(index == 0) {
                        GeometryReader { m in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(slidingBlockColors.count == 0 ? backgroundGradientStart.opacity( 0.4) : slidingBlockColors[preselectedIndex])
                                .padding(3)
                                .offset(x: CGFloat((preselectedIndex)) * m.size.width, y: 0)
                        }
                    }
                    
                        /*
                        if str != "" {
                            Text(str).foregroundColor(.primary.opacity(index == preselectedIndex ? 0.7 : 0.2))
                        }
                         */
                    CustomSegmentedControlLabel(preselectedIndex: $preselectedIndex, index: index) {selected in
                        optionLabels[index](selected)
                    }.foregroundColor(.primary.opacity(index == preselectedIndex ? 0.7 : 0.2))
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
