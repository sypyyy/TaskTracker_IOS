//
//  GoalView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/6/21.
//

import SwiftUI

struct GoalView: View {
    @State var isPresentedGoalCreatView = false
    var body: some View {
        ZStack {
            //Color.clear.background(.ultraThinMaterial).opacity(0.4)
            
            GoalListView()
            VStack(spacing: 0) {
                GoalViewNavBar()
                Spacer()
            }
            VStack(spacing: 0) {
                Spacer()
                HStack {
                    Spacer()
                    
                    PlusGoalView().padding(.trailing, 4)
                        .onTapGesture {
                            isPresentedGoalCreatView = true
                            //BottomSheetViewController.shared.show(snapPoints: [.AlmostFull], background: .blur(style: .extraLight), viewType: .swiftUI(view: AnyView(Text("test"))))
                        }
                }
                Spacer().frame(height: TAB_BAR_HEIGHT + 6)
            }.ignoresSafeArea()
            
        }.sheet(isPresented: $isPresentedGoalCreatView, content: {
            GoalCreationView()
        })
    }
}

struct PlusGoalView: View {
    var body: some View {
        Image(systemName: "plus")
            .padding(20)
            .background(.thinMaterial)
            .clipShape(Circle())
            
    }
}

struct GoalViewNavBar: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "line.3.horizontal")
                    .navBarSystemImageButtonModifier()
                    .padding(.trailing, 4)
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        VStack(spacing: 2) {
                            Text("All")
                            RoundedRectangle(cornerRadius: 4)
                                .fill(backgroundGradientStart)
                                .frame(height: 4)
                        }
                        VStack(spacing: 2) {
                            Text("Weekly")
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.clear)
                                .frame(height: 4)
                        }
                        VStack(spacing: 2) {
                            Text("Monthly")
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.clear)
                                .frame(height: 4)
                        }
                        VStack(spacing: 2) {
                            Text("Annually")
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.clear)
                                .frame(height: 4)
                        }
                      
                        //Spacer()
                    }
                }
                .scrollIndicators(.hidden)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.primary.lighter(by: 32))
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 6)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial)
    }
}


struct GoalListView: View {
    @StateObject var viewModel = GoalViewModel.shared
    var body: some View {
         ScrollView {
             Spacer().frame(height: 50)
             LazyVStack(spacing: 16) {
                 ForEach(viewModel.nodeArray, id: \.id) { node in
                     GoalRowView(node: node)
                 }
             }.id(viewModel.sessionID)
         }
    }


    private func emoji(_ value: Int) -> String {
        guard let scalar = UnicodeScalar(value) else { return "?" }
        return String(Character(scalar))
    }
}


struct GoalRowView: View {
    @State var isExpanded: Bool
    @StateObject var viewModel = GoalViewModel.shared
    let node: AnyTreeNode
    
    
    init(node: AnyTreeNode) {
        self.node = node
        self.isExpanded = node.isExpanded
    }
    
    var body: some View {
        Group {
            switch node.subTypeInfo {
            case .goalRow(info: let info):
                switch info {
                case .goal(id: let id):
                    let goalModel = node as? GoalModel
                    HStack {
                        //Image(.goal2).resizable().scaledToFit().frame(width: 26)
                        //Image(.goal).resizable().scaledToFit().frame(width: 26)
                        Image(systemName: "scope")
                            .resizable().scaledToFit().frame(width: 22)
                            .foregroundStyle(Color.red.opacity(0.5))
                        
                        Text("\(goalModel?.name ?? "")")
                        Spacer()
                        
                        if(node.children.count > 0)
                        {
                            
                            ExpandArrow(isExpanded: $isExpanded, action: {
                                isExpanded.toggle()
                                withAnimation{
                                    viewModel.expandOrCollapseGoal(nodeId: node.id)
                                }
                            }).frame(width: 16).padding(.trailing, 4)
                        }
                        
                    }
                    //.foregroundStyle(Color.primary.lighter(by: node.level == 1 ? 16 : 32))
                    .padding(8)
                    .padding(.vertical, 6)
                    .silverliningBackground(material: .thinMaterial)
                    .padding(.horizontal, 12)
                    .padding(.leading, (CGFloat(node.level - 1) * 28))
                }
            case .todo:
                let todoModel = node as? TodoModel
                HStack {
                    Text("\(todoModel?.name ?? "")")
                    Spacer()
                }
                .padding(8)
                .padding(.vertical, 6)
                .silverliningBackground(material: .thinMaterial)
                .padding(.horizontal, 12)
                .padding(.leading, (CGFloat(node.level - 1) * 28))
            default:
                EmptyView()
            }
        }.onChangeCustom(of: node.isExpanded, {
           isExpanded = node.isExpanded
        })
    }
}





/*
struct VerticalSmileys: View {
    @StateObject var viewModel = GoalViewModel.shared
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
         ScrollView {
             Spacer().frame(height: 50)
             LazyVGrid(columns: columns, spacing: 24) {
                 ForEach(viewModel.getAllGoals(), id: \.self.id) { goal in
                     VStack{
                         HStack {
                             //Text("🎨")
                             Image(systemName: "figure.run")
                                 .font(.system(size: 16, weight: .medium, design: .rounded))
                                 .padding(7)
                                 .background {
                                     Circle().fill(.green.opacity(0.2))
                                 }
                             Text("\(goal.name)").lineLimit(2).minimumScaleFactor(0.8)
                                 .frame(maxHeight: .infinity)
                             Spacer()
                         }
                         .foregroundColor(.primary.lighter(by: 32))
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
                     .background(.thinMaterial)
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
*/

#Preview {
    ZStack {
        DefaultIslandBackgroundView(tabIndex: .constant(.goals), zoom: .constant(true))
        GoalView()
    }
    
}
