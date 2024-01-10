//
//  TaskTableViewController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/1/4.
//

import UIKit
import SwiftUI


class TaskTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChangeListener {
    var masterViewModel = TaskMasterViewModel.shared
    var tableView: UITableView!
    var expandedIndexPath: IndexPath? = nil
    var tasks = [TaskModel]()
    
    func didUpdate(msg: ChangeMessage) {
        switch msg {
        case .taskChanged:
            tasks = masterViewModel.getDayTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        masterViewModel.registerListener(listener: self)
    }

    func setupTableView() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
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
        cell.hostSwiftUIView(task: tasks[indexPath.row], tableViewDelegate: self, idx: indexPath.row)
                return cell
    }

    // MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(expandedIndexPath == indexPath ? 295 : 120) // Expanded and collapsed heights
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        if expandedIndexPath == indexPath {
            expandedIndexPath = nil
            masterViewModel.tappedTaskId = nil
        } else {
            expandedIndexPath = indexPath
            masterViewModel.tappedTaskId = tasks[indexPath.row].taskId
        }
        
        masterViewModel.objectWillChange.send()
        tableView.endUpdates()
    }
    
    
    
}

class SwiftUIHostingTableViewCell: UITableViewCell {
    private var hostingController: UIHostingController<TaskTableCellView>?
    func hostSwiftUIView(task: TaskModel, tableViewDelegate: TaskTableViewController, idx: Int) {
        let swiftUIView = TaskTableCellView(tableViewDelegate: tableViewDelegate, rowIdx: idx, taskId: task.taskId)
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
            
        }
        hostingController?.view.isHidden = false
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        //hostingController?.view.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
                hostingController?.view.frame = self.bounds
        //hostingController?.view.frame.size = .init(width: 300, height: 100)
        //hostingController?.view.bounds.size = .init(width: 300, height: 100)
    }
}

struct TaskTableCellView: View {
    @StateObject var masterViewModel: TaskMasterViewModel = TaskMasterViewModel.shared
    @StateObject var habitViewModel: HabitViewModel = HabitViewModel.shared
    weak var tableViewDelegate: TaskTableViewController?
    weak var tableView: UITableView?
    var rowIdx: Int
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
        let task = tableViewDelegate?.tasks[rowIdx] ?? TaskModel(taskId: UUID().uuidString, taskType: .todo)
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
        }
        .animation(.easeIn(duration: 0.2), value: isExpanded)
        
    }
}

struct ContentView_Previews_TaskTableController: PreviewProvider {
    static let overalViewModel = TaskMasterViewModel()
    
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        RootView(viewModel : overalViewModel).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
