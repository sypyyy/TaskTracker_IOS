//
//  GoalPickingViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/7/1.
//

import Foundation

@MainActor
class GoalPickingViewModel: ObservableObject, TreeBasedTableViewController {
    let listenerID = UUID().uuidString
    let masterViewModel = MasterViewModel.shared
    private var persistenceModel : PersistenceController = PersistenceController.preview
    
    // For when not in search mode
    var dummyRootNode: AnyTreeNode = AnyTreeNode()
    var nodeArray: [AnyTreeNode] = []
    
    var allGoals: [GoalModel] = []
    
    var currentActiveGoal: GoalModel? = nil
    
    init(preselectedGoal: GoalModel?) {
        currentActiveGoal = preselectedGoal
        loadDataAndUpdate()
        masterViewModel.registerListener(listener: self)
    }
    
    func loadDataAndUpdate() {
        allGoals = getAllGoals()
        let rootGoals = getAllRootGoals()
        dummyRootNode.addChildren(rootGoals)
        updateNodeArray()
    }
    
    private func updateNodeArray() {
        let oldNodeArr = nodeArray
        //print("oldNodeArr: \(oldNodeArr.last?.id)")
        let newNodeArr = self.getNewNodeArray()
        //print("newNodeArr: \(newNodeArr.last?.id)")
        nodeArray = newNodeArr
        objectWillChange.send()
    }
    
    func expandOrCollapseGoal(nodeId: String) {
        guard let goal = nodeArray.first(where: {
            $0.id == nodeId
        }) as? GoalModel else {
            return
        }
        goal.isExpanded = !goal.isExpanded
        updateNodeArray()
    }
    
    func commitPick(goal: GoalModel?, mode: GoalPickingMode) {
        switch mode {
        case .todo(let todo):
            self.pickGoal(goal: goal, forTodo: todo)
        case .choosingParentForExistedGoal(let parent):
            self.pickGoal(goalAsParent: parent, forGoal: goal)
        case .callBack(let callback):
            callback(goal)
        }
        currentActiveGoal = goal
        objectWillChange.send()
    }
    
    func pickGoal(goal: GoalModel?, forTodo todo: TodoModel?) {
        if let todo = todo {
            if let goal = goal {
                persistenceModel.setGoalForTodo(goalId: goal.id, todoId: todo.id)
            } else {
                persistenceModel.resetGoalForTodo(todoId: todo.id)
            }
            masterViewModel.didReceiveChangeMessage(msg: .taskGoalSet)
        }
        
    }
    
    func pickGoal(goalAsParent parentGoal: GoalModel?, forGoal childGoal: GoalModel?) {
        if let childGoal = childGoal {
            if let parentGoal = parentGoal {
                persistenceModel.addGoalToParent(parentID: parentGoal.id, childID: childGoal.id)
            } else {
                persistenceModel.resetParentForGoal(goalId: childGoal.id)
            }
            masterViewModel.didReceiveChangeMessage(msg: .goalCRUD)
        }
    }
}


extension GoalPickingViewModel: ChangeListener {
    var listenerId: String {
        listenerID
    }
    
    func didUpdate(msg: ChangeMessage) {
        switch msg {
        default:
            break
        }
    }
}

extension GoalPickingViewModel {
    private func getAllRootGoals() -> [GoalModel] {
        return persistenceModel.getAllRootGoals().map {goal in
                .init(goal: goal)
        }
    }
    
    private func getAllGoals() -> [GoalModel] {
        return persistenceModel.getAllGoals().map {goal in
                .init(goal: goal)
        }
    }
    /*
    func createNewGoal(goal: GoalModel) {
        persistenceModel.createGoal(dataModel: goal)
    }
     */
}
