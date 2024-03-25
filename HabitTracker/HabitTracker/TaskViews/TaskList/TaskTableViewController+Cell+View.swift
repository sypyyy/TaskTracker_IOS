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
let Task_Card_Horizontal_Padding: CGFloat = 12
@MainActor
var Estimated_Task_Card_Folded_Height: CGFloat = 75

fileprivate let loggingTag = "TaskTableViewController"

enum TaskTableSortBy: Int {
    case time = 0, priority = 1, habitOrTodo = 2, goal = 3
}

class TaskTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ChangeListener {
    let Table_Bottom_Padding: CGFloat = 0
    var masterViewModel = TaskMasterViewModel.shared
    //SegmentedControl
    let SEGMENTEDCONTROL_HEIGHT: CGFloat = 40
    var segmentedControlView: UIView!
    var segmentedControlHeightConstraint: NSLayoutConstraint?
    //Header
    let HEADER_HEIGHT: CGFloat = 30
    
    var taskTableView: UITableView!
    var taskTableLeadingConstraint: NSLayoutConstraint?
    var taskTableTopConstraint: NSLayoutConstraint?
    private let TASK_CELL_REGISTER_NAME = "TaskTableCell"
    
    var tasks = [TaskModel]()
    var taskHeaders = [TaskHeaderModel]()
    var taskId2IndexPathMapping = [String: IndexPath]()
    var indexPath2TaskIdMapping = [IndexPath: String]()
    var taskId2TaskModelMapping = [String: TaskModel]()
    //For Header expansion and collapse, Bool means is expanded
    //The key is the table section index of section, the first task section is 1, not 0.
    
    //Timeline view
    let TIME_LINE_TABLE_WIDTH: CGFloat = 80
    var timelineLeadingConstraint: NSLayoutConstraint?
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
        setupTaskTableView()
        setupTimeLineView()
        setupSegmentedControl()
        setInitLayoutDetails()
        masterViewModel.registerListener(listener: self)
        //Set up the data
        updateData(rowMovedDeletedInserted: true, sortBy: masterViewModel.sortBy, reloadDirectly: true, expandAllHeaders: true, shouldScrollToTop: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Set up segmented control's height with tasktableview contentoffset
        addContentOffsetObservers()
    }
    
    func setInitLayoutDetails() {
        taskTableView.sectionHeaderTopPadding = 0
        timeLineView.sectionHeaderTopPadding = 0
        taskTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Table_Bottom_Padding, right: 0)
        timeLineView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Table_Bottom_Padding, right: 0)
        taskTableView.contentOffset.y = -0
        timeLineView.contentOffset.y = -0
        
    }
    
    func setupSegmentedControl() {
        segmentedControlView = TaskViewSegmentedControl(options: ["Time", "Priority", "Habit/Todo", "Goal"]) {idx in
            self.masterViewModel.sortBy(by: TaskTableSortBy(rawValue: idx) ?? .time)
        }
        segmentedControlView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(segmentedControlView)
        segmentedControlHeightConstraint = segmentedControlView.heightAnchor.constraint(equalToConstant: SEGMENTEDCONTROL_HEIGHT)
        segmentedControlHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            segmentedControlView.topAnchor.constraint(equalTo: view.topAnchor),
            segmentedControlView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            segmentedControlView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
    }

    func setupTaskTableView() {
        taskTableView = UITableView(frame: .zero, style: .plain)
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.dragDelegate = self
        taskTableView.dragInteractionEnabled = true
        taskTableView.contentInsetAdjustmentBehavior = .never
        taskTableView.register(TaskTableCell.self, forCellReuseIdentifier: TASK_CELL_REGISTER_NAME)
        //Remove separators
        taskTableView.separatorStyle = .none
        taskTableView.allowsSelection = false
        taskTableView.showsVerticalScrollIndicator = false
        //Set transparent background for the UITableView
        taskTableView.backgroundColor = UIColor.clear
        self.view.addSubview(taskTableView)
        taskTableView.translatesAutoresizingMaskIntoConstraints = false
        taskTableLeadingConstraint = taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: TIME_LINE_TABLE_WIDTH)
        taskTableLeadingConstraint?.isActive = true
        taskTableTopConstraint = taskTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: SEGMENTEDCONTROL_HEIGHT)
        taskTableTopConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            taskTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Table_Bottom_Padding),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setupTimeLineView() {
        timeLineView = UITableView(frame: .zero, style: .plain)
        timeLineView.delegate = self
        timeLineView.dataSource = self
        timeLineView.contentInsetAdjustmentBehavior = .never
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
        timelineLeadingConstraint = timeLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        timelineLeadingConstraint?.isActive = true
        NSLayoutConstraint.activate([
            timeLineView.widthAnchor.constraint(equalToConstant: TIME_LINE_TABLE_WIDTH),
            timeLineView.topAnchor.constraint(equalTo: view.topAnchor),
            timeLineView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Table_Bottom_Padding),
            
        ])
       
    }
    fileprivate func updateData(rowMovedDeletedInserted: Bool, sortBy: TaskTableSortBy, reloadDirectly: Bool = false, expandAllHeaders: Bool, shouldScrollToTop: Bool, useFadeAnimationOnly: Bool = false) {
        //????
        print("bug tap quick: Updating because isUpdating is false")
        taskTableView.setEditing(false, animated: true)
        var newTasks = masterViewModel.getDayTasks(date: masterViewModel.selectedDate)
        switch sortBy {
        case .priority:
            newTasks.sort(by: {a, b in
                let p1 = a.mPriority, p2 = b.mPriority
                if(p1 == 0) {
                    return false
                } else if (p2 == 0) {
                    return true
                } else {
                    return p1 < p2
                }
            })
        case .time:
            newTasks.sortByTime()
        case .habitOrTodo:
            newTasks.sort(by: {$0.taskType.rawValue > $1.taskType.rawValue})
        default: break
        }
        
        var newId2IndexPathMapping = [String: IndexPath]()
        var newId2TaskModelMapping = [String: TaskModel]()
        var newIndexPath2TaskIdMapping = [IndexPath: String]()
        var newTaskHeaders = [TaskHeaderModel]()
        
        func addTaskToHeaders(task: TaskModel, taskHeaderIdx: Int) {
            if(!expandAllHeaders) {
                if(taskHeaders[taskHeaderIdx].isExpanded == false) {
                    return
                }
            }
            newTaskHeaders[taskHeaderIdx].tasks.append(task)
        }
        var shouldResetExpandState = true
        if(taskHeaders.first?.sortType == sortBy && !expandAllHeaders) {
            shouldResetExpandState = false
        }
        
        let sortTypeChanged = taskHeaders.first?.sortType != sortBy
        
        func copyExpandState() {
            if !shouldResetExpandState {
                newTaskHeaders.enumerated().forEach{idx, h in
                    h.isExpanded = taskHeaders[idx].isExpanded
                }
            }
        }
        
        switch sortBy {
        case .time:
            
            newTaskHeaders = [TaskHeaderModel(headerString: "Morning", headerImageString: "", sortType: .time), TaskHeaderModel(headerString: "Afternoon", headerImageString: "", sortType: .time), TaskHeaderModel(headerString: "Evening", headerImageString: "", sortType: .time), TaskHeaderModel(headerString: "AllDay", headerImageString: "", sortType: .time)]
            copyExpandState()
            var currentTaskHeaderIdx = 0
            let timeAreas = [AmbiguousExecutionTime.morning, AmbiguousExecutionTime.afternoon, AmbiguousExecutionTime.evening, AmbiguousExecutionTime.allDay]
            var currentTimeArea = timeAreas[currentTaskHeaderIdx]
            for (idx, task)in newTasks.enumerated() {
                if(task.mExecutionTime.getTimeArea() != currentTimeArea){
                    currentTaskHeaderIdx += 1
                    currentTimeArea = timeAreas[currentTaskHeaderIdx]
                }
                addTaskToHeaders(task: task, taskHeaderIdx: currentTaskHeaderIdx)
            }
        case .priority:
            newTaskHeaders = [TaskHeaderModel(headerString: "High Priority", headerImageString: "", sortType: .priority), TaskHeaderModel(headerString: "Medium Priority", headerImageString: "", sortType: .priority), TaskHeaderModel(headerString: "Low Priority", headerImageString: "", sortType: .priority), TaskHeaderModel(headerString: "No Priority", headerImageString: "", sortType: .priority)]
            copyExpandState()
            var currentTaskHeaderIdx = 0
            let priorities = [1, 2, 3, 0]
            var currentPriorityGroup = priorities[currentTaskHeaderIdx]
            for (idx, task)in newTasks.enumerated() {
                if(task.mPriority != currentPriorityGroup){
                    currentTaskHeaderIdx += 1
                    currentPriorityGroup = priorities[currentTaskHeaderIdx]
                }
                addTaskToHeaders(task: task, taskHeaderIdx: currentTaskHeaderIdx)
            }
        case .habitOrTodo:
            newTaskHeaders = [TaskHeaderModel(headerString: "Todo", headerImageString: "", sortType: .habitOrTodo), TaskHeaderModel(headerString: "Habit", headerImageString: "", sortType: .habitOrTodo)]
            copyExpandState()
            if !shouldResetExpandState {
                newTaskHeaders.enumerated().forEach{idx, h in
                    h.isExpanded = taskHeaders[idx].isExpanded
                }
            }
            
            var currentTaskHeaderIdx = 0
            let taskTypes = [TaskType.todo, TaskType.habit]
            var currentTaskTypeGroup = taskTypes[currentTaskHeaderIdx]
            for (idx, task)in newTasks.enumerated() {
                if(task.taskType != currentTaskTypeGroup){
                    currentTaskHeaderIdx += 1
                    currentTaskTypeGroup = taskTypes[currentTaskHeaderIdx]
                }
                addTaskToHeaders(task: task, taskHeaderIdx: currentTaskHeaderIdx)
            }
        case .goal:
            copyExpandState()
            break
        }
        var rowsSum = 0
        for headerModel in newTaskHeaders {
            headerModel.rowIdx = rowsSum
            rowsSum += 1
            headerModel.tasks.enumerated().forEach { (idx, task) in
                let indexPath = IndexPath(row: rowsSum + idx, section: 0)
                newIndexPath2TaskIdMapping[indexPath] = task.taskId
                newId2IndexPathMapping[task.taskId] = indexPath
            }
                rowsSum += headerModel.numberOfRows
        }
        for (idx, task)in newTasks.enumerated() {
            newId2TaskModelMapping[task.taskId] = task
        }
        
        if reloadDirectly {
            taskHeaders = newTaskHeaders
            tasks = newTasks
            taskId2TaskModelMapping = newId2TaskModelMapping
            taskId2IndexPathMapping = newId2IndexPathMapping
            indexPath2TaskIdMapping = newIndexPath2TaskIdMapping
            taskTableView.reloadData()
            timeLineView.reloadData()
            scrollToTop(animated: false)
            return
        }
        /*
         DataUpdates
         */
        let oldTaskHeaders = self.taskHeaders
        self.taskHeaders = newTaskHeaders
        self.tasks = newTasks
        self.taskId2TaskModelMapping = newId2TaskModelMapping
        let oldTaskId2IndexPathMapping = self.taskId2IndexPathMapping
        self.taskId2IndexPathMapping = newId2IndexPathMapping
        self.indexPath2TaskIdMapping = newIndexPath2TaskIdMapping
        self.timeLineView.reloadData()
        if shouldScrollToTop {
            self.scrollToTop(animated: true)
        }
        if rowMovedDeletedInserted {
            
            if let expanded = masterViewModel.tappedTaskId {
                masterViewModel.tappedTaskId = nil
                masterViewModel.objectWillChange.send()
            }
            
            self.taskTableView.performBatchUpdates{
                
                var indexesToDelete = [IndexPath: UITableView.RowAnimation]()
                var indexesToInsert = [IndexPath: UITableView.RowAnimation]()
                if sortTypeChanged {
                    for i in 0..<oldTaskHeaders.count {
                        indexesToDelete[IndexPath(row: oldTaskHeaders[i].rowIdx, section: 0)] = .fade
                        print("to delete: \(oldTaskHeaders[i].rowIdx)")
                    }
                  
                    
                    for i in 0..<taskHeaders.count {
                        indexesToInsert[IndexPath(row: taskHeaders[i].rowIdx, section: 0)] = .fade
                    }
                } else {
                    //这一块肯定还要大改因为Project sort还没做
                    for i in 0..<taskHeaders.count {
                        if taskHeaders[i].rowIdx != oldTaskHeaders[i].rowIdx {
                            self.taskTableView.moveRow(at: IndexPath(row: oldTaskHeaders[i].rowIdx, section: 0), to: IndexPath(row: taskHeaders[i].rowIdx, section: 0))
                        }
                    }
                }
                
                
                for pairing in oldTaskId2IndexPathMapping.enumerated() {
                    let pair = pairing.element
                    let oldTaskId = pair.key
                    
                    if newId2IndexPathMapping[oldTaskId] == nil {
                        indexesToDelete[pair.value] = useFadeAnimationOnly ? .fade : .right
                        print("to delete: \(pair.value.row)")
                    }
                }
                
                for pairing in newId2IndexPathMapping.enumerated() {
                    let pair = pairing.element
                    let newIdxPath = pair.value
                    if let oldIdxPath = oldTaskId2IndexPathMapping[pair.key] {
                        if oldIdxPath.row != newIdxPath.row {
                            self.taskTableView.moveRow(at: oldIdxPath, to: newIdxPath)
                        }
                    } else {
                        indexesToInsert[newIdxPath] =  useFadeAnimationOnly ? .fade : .left
                        print("\(loggingTag) inserted row at \(newIdxPath)")
                    }
                }
               
                for pairing in indexesToInsert.enumerated() {
                    self.taskTableView.insertRows(at: [pairing.element.key], with: pairing.element.value)
                }
                for pairing in indexesToDelete.enumerated() {
                    self.taskTableView.deleteRows(at: [pairing.element.key], with: pairing.element.value)
                    print("to delete and deleted: \(pairing.element.key.row)")
                }
                
            } completion: { _ in
                print("\(loggingTag) finished moving rows")
                print("current thread is \(Thread.current)")
                
                self.taskTableView.reloadData()
                print("bug tap quick: Finished updating")
            }
        }
    }
    
    func scrollToTop(animated: Bool) {
        
            self.taskTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
            self.timeLineView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    
    }
    
    func didUpdate(msg: ChangeMessage) {
        switch msg {
        case .dateSelected:
            updateData(rowMovedDeletedInserted: true, sortBy: masterViewModel.sortBy, expandAllHeaders: true, shouldScrollToTop: true)
            masterViewModel.objectWillChange.send()
        case .taskStateChanged:
            updateData(rowMovedDeletedInserted: false, sortBy: masterViewModel.sortBy, expandAllHeaders: false, shouldScrollToTop: false)
            masterViewModel.objectWillChange.send()
        case .taskCreated:
            updateData(rowMovedDeletedInserted: true, sortBy: masterViewModel.sortBy, expandAllHeaders: false, shouldScrollToTop: true)
            masterViewModel.objectWillChange.send()
        case .sortChanged(let sortBy):
            updateData(rowMovedDeletedInserted: true, sortBy: sortBy, expandAllHeaders: true, shouldScrollToTop: true)
            UIView.animate(withDuration: 0.3) {
                self.taskTableLeadingConstraint?.constant = sortBy == .time ? self.TIME_LINE_TABLE_WIDTH : 0
                self.timelineLeadingConstraint?.constant = sortBy == .time ?  0 : -self.TIME_LINE_TABLE_WIDTH
                self.timeLineView.alpha = sortBy == .time ? 1 : 0
                self.view.layoutIfNeeded()
            }
            print("received sort change")
        case .taskSelected:
            //These two are here to make sure the cell height changes when the cell is selected or deselected
            self.taskTableView.performBatchUpdates {
            }
            self.timeLineView.performBatchUpdates{}
        }
           
    }
    
    // MARK: - TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        //return 5
        }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var taskNum = 0
        taskHeaders.forEach{h in
            taskNum += h.numberOfRows
        }
        return taskHeaders.count + taskNum
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let taskId = indexPath2TaskIdMapping[indexPath], let task = taskId2TaskModelMapping[taskId] {
            if tableView == timeLineView {
                let cell = TimelineCell()
                cell.configure(with: "\(task.mExecutionTime.getDisplayStartString())")
                return cell
                
            } else {
                let cell = taskTableView.dequeueReusableCell(withIdentifier: TASK_CELL_REGISTER_NAME, for: indexPath) as! TaskTableCell
                cell.contentView.backgroundColor = UIColor.clear
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = .none
                cell.contentView.clipsToBounds = true
                cell.hostSwiftUIView(tableViewDelegate: self, taskId: task.taskId)
                return cell
            }
        } else {
            let rowIdx = indexPath.row
            var sectionView = UIView()
            taskHeaders.enumerated().forEach{idx, header in
                if header.rowIdx == rowIdx {
                    sectionView = getHeaderViewForSection(tableView: tableView, section: idx) ?? UIView()
                }
            }
            let res = UITableViewCell()
            res.frame.size.height = HEADER_HEIGHT
            res.backgroundColor = .clear
            sectionView.translatesAutoresizingMaskIntoConstraints = false
            res.contentView.addSubview(sectionView)
            NSLayoutConstraint.activate([
                sectionView.topAnchor.constraint(equalTo: res.contentView.topAnchor),
                sectionView.bottomAnchor.constraint(equalTo: res.contentView.bottomAnchor),
                sectionView.leadingAnchor.constraint(equalTo: res.contentView.leadingAnchor),
                sectionView.trailingAnchor.constraint(equalTo: res.contentView.trailingAnchor),
            ])
            return res
            
        }
    }

    // MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("bug tap quick: asking for height for row \(indexPath.row), istaskView: \(tableView == taskTableView)")
        if let taskId = indexPath2TaskIdMapping[indexPath] {
            let cellView =  TaskTableCellView(tableViewDelegate: self, taskId: taskId)
            let hostingVC = UIHostingController(rootView: cellView)
            let res = hostingVC.sizeThatFits(in: .init(width: UIScreen.main.bounds.width - 2 * 16, height: .greatestFiniteMagnitude)).height
            if(taskId != masterViewModel.tappedTaskId) {
                Estimated_Task_Card_Folded_Height = res
            }
            return res
        } else {
            return HEADER_HEIGHT
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(tableView == timeLineView) {return nil}
        if let taskId = indexPath2TaskIdMapping[indexPath] {
            let task = taskId2TaskModelMapping[taskId]
            if taskId == masterViewModel.tappedTaskId {
                return UISwipeActionsConfiguration(actions: [])
            }
            let timerAction =  UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
                completionHandler(true)
            })
                timerAction.image = imageResources.getTimerActionButton()
            timerAction.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.001)
                    return UISwipeActionsConfiguration(actions: [ timerAction])
        }
        return UISwipeActionsConfiguration(actions: [])
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(tableView == timeLineView) {return nil}
        if let taskId = indexPath2TaskIdMapping[indexPath] {
            let task = taskId2TaskModelMapping[taskId]
            if taskId == masterViewModel.tappedTaskId {
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
        return UISwipeActionsConfiguration(actions: [])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        func adjustTableTopConstraint(constant: CGFloat) {
            
            let newConstant = constant - taskTableView.contentOffset.y
            taskTableTopConstraint?.constant = clamp(value: newConstant, minimum: 0.0001, maximum: SEGMENTEDCONTROL_HEIGHT - 0.0001)
            taskTableView.contentOffset.y = 0
        }
        if(scrollView == self.taskTableView) {
            if let constant = taskTableTopConstraint?.constant {
                print("constant IS \(constant)")
                if constant > 0.001 && constant < SEGMENTEDCONTROL_HEIGHT - 0.001 {
                    adjustTableTopConstraint(constant: constant)
                } else {
                    if constant > SEGMENTEDCONTROL_HEIGHT / 2 && taskTableView.contentOffset.y > 0 {
                        adjustTableTopConstraint(constant: constant)
                    } else if constant < SEGMENTEDCONTROL_HEIGHT / 2 && taskTableView.contentOffset.y < 0 {
                        adjustTableTopConstraint(constant: constant)
                    }
                }
            }
            
            print("bug: taskTableTopConstraint \(taskTableTopConstraint?.constant)")
            timeLineView.contentOffset = taskTableView.contentOffset
        } else {
            taskTableView.contentOffset = timeLineView.contentOffset
        }
        
       
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
        willDecelerate decelerate: Bool
    ) {
        if !decelerate {
            print("setting! 3")
            if scrollView == taskTableView {
                UIView.animate(withDuration: 0.2) {
                    if self.taskTableTopConstraint?.constant ?? 0 > self.SEGMENTEDCONTROL_HEIGHT / 2 {
                        print("setting! 1")
                        self.taskTableTopConstraint?.constant = self.SEGMENTEDCONTROL_HEIGHT - 0.0001
                    } else {
                        print("setting! 2")
                        self.taskTableTopConstraint?.constant = 0.0001
                    }
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("setting! 3")
        if scrollView == taskTableView {
            UIView.animate(withDuration: 0.2) {
                if self.taskTableTopConstraint?.constant ?? 0 > self.SEGMENTEDCONTROL_HEIGHT / 2 {
                    print("setting! 1")
                    self.taskTableTopConstraint?.constant = self.SEGMENTEDCONTROL_HEIGHT - 0.0001
                } else {
                    print("setting! 2")
                    self.taskTableTopConstraint?.constant = 0.0001
                }
                self.view.layoutIfNeeded()
            }
            
        }
    }
}

//Header
extension TaskTableViewController {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //view.isHidden = false
        /*
        view.frame = CGRect(x: 0, y: -view.frame.height, width: view.frame.width, height: view.frame.height)
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                // Slide in animation - adjust final y to 0 or under the navigation bar if you have one
                view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            }, completion: nil)
        */
    }
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        view.isHidden = true
    }
    func getHeaderViewForSection(tableView: UITableView, section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        if(tableView == taskTableView && section < taskHeaders.count && section >= 0) {
            let headerLabel = UILabel(frame: CGRect(x: 36, y: 0, width: tableView.bounds.size.width, height: HEADER_HEIGHT))
            headerLabel.text = taskHeaders[section].headerString
            headerLabel.textColor = .gray.withAlphaComponent(0.9)
            headerLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            headerView.addSubview(headerLabel)
            let expandArrow = UIImageView(image: UIImage(systemName: "chevron.down"))
            expandArrow.tintColor = .gray.withAlphaComponent(0.4)
            let arrowHeight = CGFloat(16)
            expandArrow.frame = CGRect(x: 12, y: (HEADER_HEIGHT - arrowHeight) / 2, width: arrowHeight * 1.2, height: arrowHeight)
            expandArrow.preferredSymbolConfiguration = .init(pointSize: 16, weight: .regular)
            headerView.addSubview(expandArrow)
            headerView.layer.cornerRadius = 0
            headerView.clipsToBounds = true
            headerView.addMaterialBackground(style: .systemMaterialLight)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_:)))
                headerView.addGestureRecognizer(tapGesture)
                headerView.tag = section // Use the tag to identify the section
        }
        return headerView
    }
    
    @objc func headerTapped(_ gesture: UITapGestureRecognizer) {
        
        guard let section = gesture.view?.tag else { return }
        print("Section \(section) was tapped.")
        taskHeaders[section].isExpanded.toggle()
        self.updateData(rowMovedDeletedInserted: true, sortBy: self.masterViewModel.sortBy, reloadDirectly: false, expandAllHeaders: false, shouldScrollToTop: false, useFadeAnimationOnly: true)
    }
}

extension TaskTableViewController {
    private func addContentOffsetObservers() {
        taskTableTopConstraint?.addObserver(self, forKeyPath: "constant", options: [.old, .new], context: nil)

    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "constant", let newConstant = change?[.newKey] as? CGFloat {
            // Handle the content offset change
            updateSegmentedControlHeight(newConstant: newConstant)
        }
    }
    
    private func updateSegmentedControlHeight(newConstant: CGFloat) {
        var segHeight = newConstant
        print("segHeight: \(segHeight)")
        
        if segHeight < 0 {
            segHeight = 0
        } else if segHeight > SEGMENTEDCONTROL_HEIGHT {
            segHeight = SEGMENTEDCONTROL_HEIGHT
        }
        /*
        if let oldHeight = segmentedControlHeightConstraint?.constant{
            print(":animating: \(segHeight) from \(oldHeight)")
            if abs(oldHeight - segHeight) > 10 {
                
                UIView.animate(withDuration: 0.1) {
                    self.segmentedControlHeightConstraint?.constant = segHeight
                    self.view.layoutIfNeeded()
                }
                return
            }
        }
         */
        self.segmentedControlHeightConstraint?.constant = segHeight
        let ratio = segHeight / SEGMENTEDCONTROL_HEIGHT
        if(ratio) < 0.6 {
            if(ratio < 0.5) {
                self.segmentedControlView.alpha = 0
            } else {
                self.segmentedControlView.alpha = (ratio - 0.5) * 10
            }
        } else {
            self.segmentedControlView.alpha = 1
        }
        
    }

}

//Dragging
extension TaskTableViewController: UITableViewDragDelegate {

    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        for h in taskHeaders {
            if h.rowIdx == indexPath.row {
                return []
            }
        }
         let itemProvider = NSItemProvider()
         let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
         
     }
    
    
    
    func tableView(_ tableView: UITableView, dragPreviewParametersForRowAt indexPath: IndexPath) -> UIDragPreviewParameters? {
            let previewParameters = UIDragPreviewParameters()
            
            // Customize the appearance of the preview.
            // For example, to make the preview have rounded corners:
        previewParameters.visiblePath = UIBezierPath(roundedRect: tableView.cellForRow(at: indexPath)?.bounds.insetBy(dx: Task_Card_Horizontal_Padding, dy: Task_Card_Vertical_Padding) ?? CGRect.zero, cornerRadius: 15)
            
            // You can also customize the background color of the preview like this:
        previewParameters.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
            return previewParameters
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
    
    
    private func convertTaskToToDoModel(_ task: TaskModel) -> TodoModel {
        let emptyTodo: TodoModel = .init()
        return task as? TodoModel ?? emptyTodo
    }
    
    private func convertTaskToHabitModel(_ task: TaskModel) -> HabitModel {
        let emptyHabit: HabitModel = .init()
        return task as? HabitModel ?? emptyHabit
    }

    var body: some View {
        
        //GeometryReader { metric in
        VStack {
            if let task = tableViewDelegate?.taskId2TaskModelMapping[taskId]{
                TaskCardView(taskType: task.taskType, habit: convertTaskToHabitModel(task), todo: convertTaskToToDoModel(task))
                    .onTapGesture {
                        
                        masterViewModel.selectTask(taskId: task.taskId)
                        
                    }
            }
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

extension [TaskModel] {
    mutating func sortByTime() {
        self.sort(by: {a, b in
            let aTimeString = a.mExecutionTime, bTimeString = b.mExecutionTime
            if(aTimeString.getTimeArea() == bTimeString.getTimeArea()) {
                let aStartEnd = aTimeString.getStartEndTime(), bStartEnd = bTimeString.getStartEndTime()
                if aStartEnd == nil {
                    if bStartEnd == nil {
                        return true
                    } else {
                        return false
                    }
                } else {
                    if bStartEnd == nil {
                        return true
                    } else {
                        return aStartEnd?.0 ?? "" < bStartEnd?.0 ?? ""
                    }
                }
            } else {
                return aTimeString.getTimeArea().sortOrder < bTimeString.getTimeArea().sortOrder
            }
        })
    }
}

class TaskHeaderModel {
    let headerString: String
    let headerImageString: String
    let sortType: TaskTableSortBy
    var numberOfRows: Int {
        tasks.count
    }
    var rowIdx: Int = -1
    var tasks = [TaskModel]()
    var isExpanded: Bool = true
    init(headerString: String, headerImageString: String, sortType: TaskTableSortBy) {
        self.headerString = headerString
        self.headerImageString = headerImageString
        self.sortType = sortType
    }
}

struct TaskTableViewController_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

func clamp<T: Comparable>(value: T, minimum: T, maximum: T) -> T {
    return min(max(value, minimum), maximum)
}
