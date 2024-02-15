//
//  ProjectViews.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/3.
//

import SwiftUI

struct ProjectViews: View {
    var body: some View {
        VerticalSmileys()
    
    }
}

struct VerticalSmileys: View {
    @StateObject var viewModel = ProjectViewModel.shared
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
         ScrollView {
             LazyVGrid(columns: columns, spacing: 24) {
                 ForEach(viewModel.getAllProjects(), id: \.self.id) { project in
                     VStack{
                         HStack {
                             //Text("🎨")
                             Image(systemName: "figure.run")
                                 .foregroundColor(.primary.opacity(0.6))
                                 .font(.system(size: 16, weight: .medium, design: .rounded))
                                 .padding(7)
                                 .background {
                                     Circle().fill(.green.opacity(0.2))
                                 }
                             Text("\(project.name)").lineLimit(2).minimumScaleFactor(0.8)
                                 .frame(maxHeight: .infinity)
                             Spacer()
                         }
                         Spacer()
                         HStack {
                             Spacer()
                             Text("")
                                 .lineLimit(1)
                                 .font(.system(size: 12, weight: .medium, design: .rounded))
                         }
                     }
                     .frame(maxWidth: .infinity)
                     .padding(6)
                     .padding(.vertical, 3)
                     .background(.regularMaterial)
                     .clipShape(RoundedRectangle(cornerRadius: 12))
                     .padding(.horizontal, 6)
                 }
             }.padding(.horizontal, 12)
            .font(.system(size: 16, weight: .medium, design: .rounded))
         }
    }


    private func emoji(_ value: Int) -> String {
        guard let scalar = UnicodeScalar(value) else { return "?" }
        return String(Character(scalar))
    }
}

struct ProjectViews_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: TaskMasterViewModel.shared)
    }
}
