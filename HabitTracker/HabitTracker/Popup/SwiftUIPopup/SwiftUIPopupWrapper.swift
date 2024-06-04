//
//  SwiftUIPopupWrapper.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/5/19.
//

import SwiftUI

struct SwiftUIPopupWrapper<Content: View>: View {
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    var body: some View {
        content()
            .padding(6)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .gray.opacity(0.4), radius: 48)
    }
}
