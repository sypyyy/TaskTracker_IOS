//
//  TaskGoalPickingSheet.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/7/1.
//

import SwiftUI
import SwiftMessages

enum GoalPickingMode {
    case todo(todo: TodoModel)
    case choosingParentForExistedGoal(goal: GoalModel)
    case callBack((GoalModel?) -> Void)
}

struct TaskGoalPickingSheetView: View {
    static let deepestLevelAllowed = 3
    
    //@State private var fontSize = 12.0
    let preselectedGoal: GoalModel?
    @StateObject var viewModel: GoalPickingViewModel
    @FocusState private var isSearchFieldFocused: Bool
    let mode: GoalPickingMode
    
    init(preselectedGoal: GoalModel?, mode: GoalPickingMode) {
        self.preselectedGoal = preselectedGoal
        _viewModel = StateObject(wrappedValue: GoalPickingViewModel(preselectedGoal: preselectedGoal))
        self.mode = mode
    }
    
    var body: some View {
        VStack {
            NavigationStack{
                ZStack {
                    GradientBackgroundInForm()
                    GoalPickingListView(viewModel: viewModel, isSearchFocused: $isSearchFieldFocused, mode: mode)
                }
                .background(.red.opacity(0.0))
                .toolbarBackground(Color.red.opacity(0.0), for: .navigationBar)
                .toolbar(content: {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        
                        HStack {
                            Group {
                                Text("Goal:")
                                //.foregroundStyle(Color.primary.lighter(by: 32))
                                    .fontWeight(.semibold)
                                    .animation(.none, value: viewModel.currentActiveGoal?.id)
                                Text("\(viewModel.currentActiveGoal?.name ?? "No Goal")")
                                    .contentTransition(.numericText())
                                    .fontWeight(.medium)
                            }
                            
                            .font(.title2)
                            if (viewModel.currentActiveGoal != nil) {
                                Button {
                                    withAnimation {
                                        viewModel.commitPick(goal: nil, mode: mode)
                                    }
                                    
                                } label: {
                                    
                                    Image(systemName: "gobackward")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 22, height: 22)
                                        .fontWeight(.bold)
                                    
                                }
                                .buttonStyle(RotatingButtonStyle())
                            }
                            
                            
                        }
                        
                        
                        .foregroundStyle(Color.primary.lighter(by: 24))
                        
                        
                        /*
                         Slider(
                         value: $fontSize,
                         in: 8...120,
                         minimumValueLabel:
                         Text("A").font(.system(size: 8)),
                         maximumValueLabel:
                         Text("A").font(.system(size: 16))
                         ) {
                         Text("Font Size (\(Int(fontSize)))")
                         }
                         .frame(width: 150)
                         Toggle(isOn: .constant(true)) {
                         Image(systemName: "bold")
                         }
                         Toggle(isOn: .constant(true)) {
                         Image(systemName: "italic")
                         }
                         */
                    }
                    
                })
                
                //.toolbar(.hidden, for: .navigationBar)
                
                
            }
            .focused($isSearchFieldFocused)
            .onChangeCustom(of: isSearchFieldFocused) {
                print(isSearchFieldFocused)
            }
        }
    }
}







fileprivate struct GoalPickingListView: View {
    @StateObject var viewModel: GoalPickingViewModel
    @State var searchText = ""
    @FocusState.Binding var isSearchFocused: Bool
    let mode: GoalPickingMode
    
    var body: some View {
        Group {
            if !isSearchFocused {
                GoalPickingPageView(mode: mode, viewModel: viewModel)
            } else {
                ScrollView {
                    //Not searching
                    
                    LazyVStack {
                        ForEach(viewModel.allGoals, id: \.id) { goalNode in
                            let x = print(goalNode.id)
                            if goalNode.getSearchKeyWord().contains(searchText.lowercased()), let goalModel = goalNode as? GoalModel  {
                                Button {
                                    
                                    withAnimation {
                                        //isSearchFocused = false
                                        //searchText = ""
                                        viewModel.commitPick(goal: goalModel, mode: mode)
                                        presentPickedMessage(goalName: goalModel.name)
                                    }
                                } label: {
                                    GoalPickingSearchRowView(viewModel: viewModel, goal: goalModel)
                                }
                                .buttonStyle(SearchRowButtonStyle())
                                .padding(.horizontal, 16)
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        }
        .searchable(text: $searchText, placement: .toolbar)
        .onChangeCustom(of: searchText) {
            print("the search: \(searchText)")
        }
    }
}

fileprivate struct GoalPickingPageView: View {
    let rootGoal: GoalModel? = nil
    let mode: GoalPickingMode
    let level = 0
    @StateObject var viewModel: GoalPickingViewModel
    @State var searchText = ""
    var body: some View {
        //NavigationStack{
            ScrollView{
                LazyVStack {
                    
                    ForEach(viewModel.nodeArray, id: \.id) { node in
                        // Text("\(node.level)")
                        let x = print("node level is\(node.level)")
                        if ((node.level - level) > TaskGoalPickingSheetView.deepestLevelAllowed) {
                            
                             NavigationLink {
                             //Text("")
                             GoalPickingPageView(mode: mode, viewModel: viewModel)
                             } label: {
                             //Text("")
                             GoalPickingRowView(isExpanded: node.isExpanded, viewModel: viewModel, node: node, mode: mode).disabled(true)
                             }
                             
                            EmptyView()
                        } else {
                            GoalPickingRowView(isExpanded: node.isExpanded, viewModel: viewModel, node: node, mode: mode)
                        }
                        
                        
                    }
                     
                }
            }
            //.searchable(text: $searchText, placement: .navigationBarDrawer)
            .navigationBarTitleDisplayMode(.inline)
        //}
    }
}

fileprivate struct GoalPickingSearchRowView: View {
    @StateObject var viewModel: GoalPickingViewModel
    let goal: GoalModel

    var body: some View {
        HStack {
            //Image(systemName: "scope")
            Text("\(goal.name)")
            Spacer()
        }
        .padding(8)
        .silverliningBackground(material: .thinMaterial)
        
    }
}



fileprivate struct GoalPickingRowView: View {
    @State var isExpanded: Bool
    @StateObject var viewModel: GoalPickingViewModel
    let node: AnyTreeNode
    let mode: GoalPickingMode
    
    var body: some View {
        switch node.subTypeInfo {
        case .goalRow(info: let info):
            switch info {
            case .goal(id: let id):
                if let goalModel = node as? GoalModel {
                    
                    
                    HStack {
                       // Image(.goal2).resizable().scaledToFit().frame(width: 26)
                        
                        ZStack {
                            Spacer()
                            if viewModel.currentActiveGoal?.id ?? "" == goalModel.id {
                                Image(systemName: "checkmark")
                            }
                        }.frame(width: 15)
                         
                        Text("\(goalModel.name)")
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
                    .silverliningBackground(material: .thinMaterial)
                    .padding(.horizontal, 16)
                    .padding(.leading, (CGFloat(node.level - 1) * 24))
                    .onTapGesture {
                        withAnimation {
                            viewModel.commitPick(goal: goalModel, mode: mode)
                        }
                    }
                }
            }
        default:
            EmptyView()
        }
    }
}

#Preview {
    TaskGoalPickingSheetView(preselectedGoal: nil, mode: .todo(todo: TodoModel()))
}


@MainActor fileprivate func presentPickedMessage(goalName: String) {
    let messageView = MessageHostingView(id: UUID().uuidString, content: Text("Selected Goal: \(goalName)").messageBackground(messageType: .success))
   // let view = MessageView.viewFromNib(layout: .cardView)
    //SwiftMessages.show(view: messageView)
    var config = SwiftMessages.Config()
    
    config.presentationStyle = .bottom
    SwiftMessages.show(config: config, view: messageView)
}




struct RotatingButtonStyle: ButtonStyle {
    @State private var rotationAngle: Double = 0

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .rotationEffect(.degrees(rotationAngle))
            .animation(.default, value: rotationAngle)
            .onChange(of: configuration.isPressed) { isPressed in
                if isPressed {
                    rotationAngle -= 360
                }
            }
    }
}

struct SearchRowButtonStyle: ButtonStyle {
    static let animationDuration = 0.2
    @State private var scaleRatio: Double = 1

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? .gray.opacity(0.1) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: SilverLiningBackground.cornerRadius))
            .scaleEffect(scaleRatio)
            .animation(.easeIn(duration: SearchRowButtonStyle.animationDuration), value: scaleRatio)
            .onChange(of: configuration.isPressed) { isPressed in
                scaleRatio = isPressed ? 0.95 : 1
            }
    }
}
