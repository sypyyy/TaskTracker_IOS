//
//  SwiftUIView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/6/26.
//

import SwiftUI

struct ExpandArrow: View {
    @Binding var isExpanded: Bool
    let action: () -> Void
    var body: some View {
        
        Image(systemName: "chevron.up")
            .resizable()
            .scaledToFit()
            .foregroundStyle(.gray)
            .rotationEffect(.degrees(isExpanded ? 0 : 180))
            .frame(maxWidth: 18)
            .onTapGesture {
                action()
            }
            .animation(.easeIn, value: isExpanded)
    }
}

#Preview {
    ExpandArrow(isExpanded: .constant(false)) {}
}
