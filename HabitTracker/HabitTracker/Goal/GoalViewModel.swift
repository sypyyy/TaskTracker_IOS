//
//  ProjectViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/4.
//

import Foundation
@MainActor
class GoalViewModel : ObservableObject, TreeBasedTableViewController {
    let listenerID = UUID().uuidString
    static var shared = GoalViewModel()
    let masterViewModel = MasterViewModel.shared
    var dummyRootNode: AnyTreeNode = AnyTreeNode()
    private var parentModel = MasterViewModel.shared
    private var persistenceModel : PersistenceController = PersistenceController.preview
    var nodeArray: [AnyTreeNode] = [] {
        didSet {
            print("nodeArrayCount: \(nodeArray.count)")
        }
    }
    
    var sessionID: String = UUID().uuidString
    
    init() {
        loadDataAndUpdate()
        masterViewModel.registerListener(listener: self)
    }
    
    func loadDataAndUpdate() {
        //因为这里会导致所有node Collapse，所以重设sessionID来强制重新绘制scrollview， 如果不这样展开箭头的按钮变化会有动画
        sessionID = UUID().uuidString
        let rootGoals = getAllRootGoals()
        dummyRootNode.removeAllChildren()
        dummyRootNode.addChildren(rootGoals)
        updateNodeArray(shouldRememberExpandedState: true)
    }
    
    private func updateNodeArray(shouldRememberExpandedState: Bool = false) {
        let oldNodeArr = nodeArray
        print("oldNodeArr: \(oldNodeArr.last?.id)")
        var id2ExpandedMapping: [String: Bool]? = nil
        if shouldRememberExpandedState {
            id2ExpandedMapping = oldNodeArr.reduce(into: [:]) { (result, node) in
                if let goal = node as? GoalModel {
                    result[goal.id] = goal.isExpanded
                }
            }
        }
        let newNodeArr = self.getNewNodeArray(expandedStatesToRestore: id2ExpandedMapping)
        print("newNodeArr: \(newNodeArr.last?.id)")
        nodeArray = newNodeArr
        objectWillChange.send()
    }
}

extension GoalViewModel: ChangeListener {
    var listenerId: String {
        self.listenerID
    }
    
    func didUpdate(msg: ChangeMessage) {
        switch msg {
        case .taskGoalSet:
            loadDataAndUpdate()
        case .goalCRUD:
            loadDataAndUpdate()
        default:
            break
        }
    }
}


//Goal CRUD
extension GoalViewModel {
    private func getAllRootGoals() -> [GoalModel] {
        return persistenceModel.getAllRootGoals().map {goal in
                .init(goal: goal)
        }
    }
    
    func createNewGoal(goal: GoalModel) {
        persistenceModel.createGoal(dataModel: goal)
    }
}


extension GoalViewModel {

    func expandOrCollapseGoal(nodeId: String) {
        guard let goal = nodeArray.first(where: {
            $0.id == nodeId
        }) as? GoalModel else {
            return
        }
        goal.isExpanded = !goal.isExpanded
        updateNodeArray()
    }
}

