//
//  TaskTableViewController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/1/4.
//

import UIKit
import SwiftUI

@MainActor
let Task_Card_Vertical_Padding: CGFloat = 10
@MainActor
var Estimated_Task_Card_Folded_Height: CGFloat = 75

fileprivate let loggingTag = "TaskTableViewController"

enum TaskTableSortBy: Int {
    case time = 0, priority = 1, habitOrTodo = 2, goal = 3
}

class TaskTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ChangeListener {
    /*
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
            return [ dragItem ]
    }
    */
    var masterViewModel = TaskMasterViewModel.shared
    var taskTableView: UITableView!
    private let TASK_CELL_REGISTER_NAME = "TaskTableCell"
    
    var tasks = [TaskModel]()
    var taskId2IndexPathMapping = [String: Int]()
    var taskId2TaskModelMapping = [String: TaskModel]()
    
    //Timeline view
    let TIME_LINE_TABLE_WIDTH: CGFloat = 80
    var timelineWidthConstraint: NSLayoutConstraint?
    private let TIMELINE_CELL_REGISTER_NAME = "TimelineCell"
    var timeLineView: UITableView!
    init(frame: CGRect) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTimeLineView()
        masterViewModel.registerListener(listener: self)
    }

    func setupTableView() {
        taskTableView = UITableView()
        taskTableView.delegate = self
        taskTableView.dataSource = self
        //tableView.dragDelegate = self
        //tableView.dragInteractionEnabled = true
        taskTableView.register(TaskTableCell.self, forCellReuseIdentifier: TASK_CELL_REGISTER_NAME)
        // Remove separators
        taskTableView.separatorStyle = .none
        taskTableView.allowsSelection = false
        // Set transparent background for the UITableView
        taskTableView.backgroundColor = UIColor.clear
        
        //tableView.frame.size.height = frame.height
        self.view.addSubview(taskTableView)
        
        //tableView.frame.size.width = 200
        taskTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskTableView.topAnchor.constraint(equalTo: view.topAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        
        print("the size of tableview: \(taskTableView.frame.size)")
        tasks = masterViewModel.getDayTasks()
        for (idx, task)in tasks.enumerated() {
            taskId2IndexPathMapping[task.taskId] = idx
            taskId2TaskModelMapping[task.taskId] = task
        }
       
    }
    
    func setupTimeLineView() {
        timeLineView = UITableView()
        timeLineView.delegate = self
        timeLineView.dataSource = self
        //tableView.dragDelegate = self
        //tableView.dragInteractionEnabled = true
        timeLineView.register(TimelineCell.self, forCellReuseIdentifier: TIMELINE_CELL_REGISTER_NAME)
        // Remove separators
        timeLineView.separatorStyle = .none
        timeLineView.allowsSelection = false
        timeLineView.showsVerticalScrollIndicator = false
        // Set transparent background for the UITableView
        timeLineView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        
        //tableView.frame.size.height = frame.height
        self.view.addSubview(timeLineView)
        timeLineView.translatesAutoresizingMaskIntoConstraints = false
        timelineWidthConstraint = timeLineView.widthAnchor.constraint(equalToConstant: TIME_LINE_TABLE_WIDTH)
        timelineWidthConstraint?.isActive = true
        NSLayoutConstraint.activate([
            timeLineView.topAnchor.constraint(equalTo: view.topAnchor),
            timeLineView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            timeLineView.trailingAnchor.constraint(equalTo: taskTableView.leadingAnchor),
            timeLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
       
    }
    
    fileprivate func updateData(rowMovedDeletedInserted: Bool, sortBy: TaskTableSortBy = .time) {
        //????
        taskTableView.setEditing(false, animated: true)
        var newTasks = masterViewModel.getDayTasks(date: masterViewModel.selectedDate)
        switch sortBy {
        
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
            taskTableView.performBatchUpdates{
                
                if rowMovedDeletedInserted {
                    masterViewModel.tappedTaskId = nil
                }
                for pairing in newId2IndexMapping.enumerated() {
                    let pair = pairing.element
                    let newIdx = pair.value
                    if let oldIdx = taskId2IndexPathMapping[pair.key] {
                        if oldIdx != newIdx {
                            taskTableView.moveRow(at: IndexPath(row: oldIdx, section: 0), to: IndexPath(row: newIdx, section: 0))
                            
                            print("\(loggingTag) moved row from \(oldIdx) to \(pair.value)")
                        }
                    } else {
                        taskTableView.insertRows(at: [IndexPath(row: newIdx, section: 0)], with: .left)
                        print("\(loggingTag) inserted row at \(newIdx)")
                    }
                }
                for pairing in taskId2IndexPathMapping.enumerated() {
                    let pair = pairing.element
                    let oldTaskId = pair.key
                    if newId2IndexMapping[oldTaskId] == nil {
                        taskTableView.deleteRows(at: [IndexPath(row: pair.value, section: 0)], with: .right)
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
            masterViewModel.objectWillChange.send()
            //masterViewModel.objectWillChange.send()
        case .taskStateChanged:
            updateData(rowMovedDeletedInserted: false)
            masterViewModel.objectWillChange.send()
        case .taskCreated:
            updateData(rowMovedDeletedInserted: true)
            taskTableView.reloadData()
            masterViewModel.objectWillChange.send()
        case .sortChanged(let sortBy):
            
            UIView.animate(withDuration: 0.3) {
                self.timelineWidthConstraint?.constant = sortBy == .time ? self.TIME_LINE_TABLE_WIDTH : 0
                self.view.layoutIfNeeded()
            }
            
            print("received sort change")
        case .taskSelected:
            //These two are here to make sure the cell height changes when the cell is selected or deselected
            taskTableView.performBatchUpdates {
                
            }
            timeLineView.performBatchUpdates {
                
            }
        }
    }
    
    

    // MARK: - TableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count // Replace with your data count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == timeLineView {
            let cell = tableView.dequeueReusableCell(withIdentifier: TIMELINE_CELL_REGISTER_NAME, for: indexPath) as! TimelineCell
            cell.configure(with: "10:00 AM")
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TASK_CELL_REGISTER_NAME, for: indexPath) as! TaskTableCell
            cell.contentView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            cell.contentView.clipsToBounds = true
            cell.hostSwiftUIView(tableViewDelegate: self, taskId: tasks[indexPath.row].taskId)
            return cell
        }
    }

    // MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let taskId = tasks[indexPath.row].taskId
        let cellView =  TaskTableCellView(tableViewDelegate: self, taskId: taskId)
        let hostingVC = UIHostingController(rootView: cellView)
        let res = hostingVC.sizeThatFits(in: .init(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)).height
        if(taskId != masterViewModel.tappedTaskId) {
            Estimated_Task_Card_Folded_Height = res
        }
        return res
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
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
        
        */
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = tasks[indexPath.row]
        if task.taskId == masterViewModel.tappedTaskId {
            return UISwipeActionsConfiguration(actions: [])
        }
        let timerAction =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            completionHandler(true)
        })
            timerAction.image = imageResources.getTimerActionButton()
        timerAction.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
                return UISwipeActionsConfiguration(actions: [ timerAction])
            
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = tasks[indexPath.row]
        if task.taskId == masterViewModel.tappedTaskId {
            return UISwipeActionsConfiguration(actions: [])
        }
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == self.taskTableView) {
            timeLineView.contentOffset = taskTableView.contentOffset
        } else {
            taskTableView.contentOffset = timeLineView.contentOffset
        }
    }
    
}


class TaskTableCell: UITableViewCell {
    private var cardBackground: CustomCardBackgroundView?
    private var hostingController: UIHostingController<TaskTableCellView>?
    func hostSwiftUIView(tableViewDelegate: TaskTableViewController, taskId: String) {
        let bgView = CustomCardBackgroundView()
        if cardBackground == nil {
            cardBackground = bgView
            contentView.addSubview(bgView)
            bgView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Task_Card_Vertical_Padding),
                bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Task_Card_Vertical_Padding),
                bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
                bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            ])
        }
        let swiftUIView = TaskTableCellView(tableViewDelegate: tableViewDelegate, taskId: taskId)
            if hostingController == nil {
                let hostingController = UIHostingController(rootView: swiftUIView)
                self.hostingController = hostingController
                hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                
                contentView.addSubview(hostingController.view)
               
                
                NSLayoutConstraint.activate([
                    hostingController.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                    hostingController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                    hostingController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                    hostingController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                ])
                
                
                hostingController.view.backgroundColor = .clear
                
            } else {
                hostingController?.rootView = swiftUIView
            }
            
            contentView.isHidden = false
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.isHidden = true
    }
}

class TimelineCell: UITableViewCell {
    
    private var label: UILabel?
    
    private func setupView() {
        // Configure label
        label = UILabel()
        guard let label = label else { return }
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // Allows for multiple lines
        contentView.addSubview(label)
        
        // Set up constraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
        ])
        
        // Additional view setup
        self.contentView.backgroundColor = .clear
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        self.contentView.clipsToBounds = true
    }
    
    // Configure the cell with text
    func configure(with text: String) {
        if label == nil {
            setupView()
        }
        label?.text = text
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
    let masterViewModel: TaskMasterViewModel = TaskMasterViewModel.shared
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
        
        //GeometryReader { metric in
            let test = print("cell rendered")
                VStack {
                    TaskCardView(taskType: task.taskType, habit: convertTaskToHabitModel(task), todo: convertTaskToToDoModel(task), cardMaxHeight: cardMaxHeight, cardIdealHeight: cardIdealHeight)//.layoutPriority(0)
                        .onTapGesture {
                        
                        masterViewModel.selectTask(taskId: task.taskId)

                    }
                    
                    //Spacer().layoutPriority(1)
                   
                }

                
            
                //.padding(.leading, masterViewModel.sortBy == .time ? 80 : 0)
            //.id(task.taskId)
            
        //}
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
