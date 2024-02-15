//
//  TaskTableViewController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/1/4.
//

import UIKit
import SwiftUI

@MainActor
let Task_Card_Vertical_Padding: CGFloat = 8
@MainActor
let Estimated_Task_Card_Folded_Height: CGFloat = 88

fileprivate let loggingTag = "TaskTableViewController"

fileprivate enum TaskTableSortBy {
    case time, priority, none, habitOrTodo, goal, name
}

class TaskTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeListener {
    var masterViewModel = TaskMasterViewModel.shared
    var tableView: UITableView!
    var expandedIndexPath: IndexPath? = nil
    var tasks = [TaskModel]()
    var taskId2IndexPathMapping = [String: Int]()
    var taskId2TaskModelMapping = [String: TaskModel]()
    
    fileprivate func updateData(rowMovedDeletedInserted: Bool, sortBy: TaskTableSortBy = .none) {
        tableView.setEditing(false, animated: true)
        var newTasks = masterViewModel.getDayTasks(date: masterViewModel.selectedDate)
        switch sortBy {
        case .name:
            newTasks.sort(by: { (task1, task2) -> Bool in
                return task1.taskId < task2.taskId
            })
        default: break
            
        }
        
        var newId2IndexMapping = [String: Int]()
        var newId2TaskModelMapping = [String: TaskModel]()
        for (idx, task)in newTasks.enumerated() {
            newId2IndexMapping[task.taskId] = idx
            newId2TaskModelMapping[task.taskId] = task
        }
        let idx = 0
        
        tasks = newTasks
        taskId2TaskModelMapping = newId2TaskModelMapping
        //tableView.moveRow(at: IndexPath(row: 0, section: 0), to: IndexPath(row: 1, section: 0))
        //tableView.moveRow(at: IndexPath(row: 1, section: 0), to: IndexPath(row: 0, section: 0))
        //tableView.insertSections(IndexSet(integer: 0), with: .automatic)
        if rowMovedDeletedInserted {
            tableView.performBatchUpdates{
                
                if rowMovedDeletedInserted {
                    expandedIndexPath = nil
                    masterViewModel.tappedTaskId = nil
                }
                for pairing in newId2IndexMapping.enumerated() {
                    let pair = pairing.element
                    let newIdx = pair.value
                    if let oldIdx = taskId2IndexPathMapping[pair.key] {
                        if oldIdx != newIdx {
                            tableView.moveRow(at: IndexPath(row: oldIdx, section: 0), to: IndexPath(row: newIdx, section: 0))
                            
                            print("\(loggingTag) moved row from \(oldIdx) to \(pair.value)")
                        }
                    } else {
                        tableView.insertRows(at: [IndexPath(row: newIdx, section: 0)], with: .left)
                        print("\(loggingTag) inserted row at \(newIdx)")
                    }
                }
                for pairing in taskId2IndexPathMapping.enumerated() {
                    let pair = pairing.element
                    let oldTaskId = pair.key
                    if newId2IndexMapping[oldTaskId] == nil {
                        tableView.deleteRows(at: [IndexPath(row: pair.value, section: 0)], with: .right)
                        print("\(loggingTag) deleted row at \(pair.value)")
                    }
                }
            } completion: { (finished) in
                if finished {
                    print("\(loggingTag) finished moving rows")
                }
            }
        }
        //MARK:
        taskId2IndexPathMapping = newId2IndexMapping
    }
    
    func didUpdate(msg: ChangeMessage) {
        switch msg {
        case .dateSelected:
            updateData(rowMovedDeletedInserted: true)
            expandedIndexPath = nil
            masterViewModel.objectWillChange.send()
            //masterViewModel.objectWillChange.send()
        case .taskStateChanged:
            updateData(rowMovedDeletedInserted: false)
            masterViewModel.objectWillChange.send()
        case .taskCreated:
            updateData(rowMovedDeletedInserted: true)
            expandedIndexPath = nil
            tableView.reloadData()
            masterViewModel.objectWillChange.send()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        masterViewModel.registerListener(listener: self)
    }

    func setupTableView() {
        tableView = UITableView(frame: self.view.frame, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SwiftUIHostingTableViewCell.self, forCellReuseIdentifier: "SwiftUIHostingCell")
        // Remove separators
        tableView.separatorStyle = .none
        // Set transparent background for the UITableView
        tableView.backgroundColor = UIColor.clear
        tableView.frame.size.height = 500
        self.view.addSubview(tableView)
        tasks = masterViewModel.getDayTasks()
        for (idx, task)in tasks.enumerated() {
            taskId2IndexPathMapping[task.taskId] = idx
            taskId2TaskModelMapping[task.taskId] = task
        }
       
    }

    // MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count // Replace with your data count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwiftUIHostingCell", for: indexPath) as! SwiftUIHostingTableViewCell
        cell.contentView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.hostSwiftUIView(tableViewDelegate: self, taskId: tasks[indexPath.row].taskId)
        print("sypppppppp \(indexPath.row)")
        return cell
    }

    // MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(expandedIndexPath == indexPath ? 295 : Estimated_Task_Card_Folded_Height + 2 * Task_Card_Vertical_Padding) // Expanded and collapsed heights
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.performBatchUpdates {
                    if expandedIndexPath == indexPath {
                        expandedIndexPath = nil
                        masterViewModel.tappedTaskId = nil
                    } else {
                        expandedIndexPath = indexPath
                        masterViewModel.tappedTaskId = tasks[indexPath.row].taskId
                    }
            self.masterViewModel.objectWillChange.send()
                   
                } completion: { success in
                    if(self.expandedIndexPath == indexPath && success) {
                        //tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
                        
                    }
                }
        
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let timerAction =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            completionHandler(true)
        })
            timerAction.image = imageResources.getTimerActionButton()
        timerAction.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
                return UISwipeActionsConfiguration(actions: [ timerAction])
            
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let archiveAction =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            completionHandler(true)
        })
            archiveAction.image = imageResources.getArchiveActionButton()
        archiveAction.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
        let deleteAction =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            completionHandler(true)
        })
        deleteAction.image = imageResources.getDeleteActionButton()
        deleteAction.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
                return UISwipeActionsConfiguration(actions: [ deleteAction, archiveAction])
            
    }
    
}


class SwiftUIHostingTableViewCell: UITableViewCell {
    private var hostingController: UIHostingController<TaskTableCellView>?
    func hostSwiftUIView(tableViewDelegate: TaskTableViewController, taskId: String) {
        let swiftUIView = TaskTableCellView(tableViewDelegate: tableViewDelegate, taskId: taskId)
        
            if hostingController == nil {
                let hostingController = UIHostingController(rootView: swiftUIView)
                self.hostingController = hostingController
                hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                hostingController.view.backgroundColor = UIColor.clear
                
                contentView.addSubview(hostingController.view)
                
                
                NSLayoutConstraint.activate([
                    hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                    hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                    hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                ])
                
            } else {
                hostingController?.rootView = swiftUIView
                print("dfhsijfs")
            }
            
            contentView.isHidden = false
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.isHidden = true
    }
}
 

/*
class SwiftUIHostingTableViewCell: UITableViewCell {
    private var rowLabel: UILabel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rowLabel = UILabel()
        rowLabel?.translatesAutoresizingMaskIntoConstraints = false
        rowLabel?.textAlignment = .center
        if let rowLabel = rowLabel {
            contentView.addSubview(rowLabel)
            NSLayoutConstraint.activate([
                rowLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                rowLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                rowLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                rowLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func hostSwiftUIView(task: TaskModel, tableViewDelegate: TaskTableViewController, idx: Int) {
        rowLabel?.text = "Row \(task.taskId)"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        rowLabel?.text = "Row frsnk"
    }
}
*/

struct TaskTableCellView: View {
    @State private var offset: CGFloat = 0
    @StateObject var masterViewModel: TaskMasterViewModel = TaskMasterViewModel.shared
    @StateObject var habitViewModel: HabitViewModel = HabitViewModel.shared
    weak var tableViewDelegate: TaskTableViewController?
    weak var tableView: UITableView?
    var taskId: String
    var isExpanded: Bool {
        masterViewModel.tappedTaskId == taskId
    }
    var tappedOne: String? {
        masterViewModel.tappedTaskId
    }
    func setTappedTaskId(_ id: String?) {
        masterViewModel.tappedTaskId = id
    }
    let cardIdealHeight = 230
    let cardMaxHeight = 230
    
    private func convertTaskToToDoModel(_ task: TaskModel) -> TodoModel {
        let emptyTodo: TodoModel = .init()
        return task as? TodoModel ?? emptyTodo
    }
    
    private func convertTaskToHabitModel(_ task: TaskModel) -> HabitModel {
        let emptyHabit: HabitModel = .init()
        return task as? HabitModel ?? emptyHabit
    }

    var body: some View {
        let task = tableViewDelegate?.taskId2TaskModelMapping[taskId] ?? TaskModel(taskId: UUID().uuidString, taskType: .todo)
        
        GeometryReader { metric in
            VStack {
                HabitTaskCardView(taskType: task.taskType, habit: convertTaskToHabitModel(task), todo: convertTaskToToDoModel(task), metric: metric, cardMaxHeight: cardMaxHeight, cardIdealHeight: cardIdealHeight, tapFunction: {
                    /*
                     //v.scrollTo(task.taskId, anchor: .center)
                     if tappedOne == task.taskId {
                     setTappedTaskId(nil)
                     } else {
                     setTappedTaskId(task.taskId)
                     }
                     if let tableView = tableView, let delegate = tableViewDelegate {
                     delegate.tableView?(tableView, didSelectRowAt: .init(index: <#T##IndexPath.Element#>))
                     }
                     */
                }).layoutPriority(0)
                    
                Spacer().layoutPriority(1)
            }
            //.id(task.taskId)
            .animation(.easeIn(duration: 0.2), value: masterViewModel.tappedTaskId)
            .offset(x: offset, y: 0)
        }
       
        //大概是因为cell Reuse reloadData会导致出现一下下乱序的列表，加入这个就不会出现了，但是前提是不要同时加id如果加了id这个animation就无效了
        //.animation(.none, value: task.taskId)
    }
}

struct ContentView_Previews_TaskTableController: PreviewProvider {
    static let overalViewModel = TaskMasterViewModel()
    
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        RootView(viewModel : overalViewModel).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
