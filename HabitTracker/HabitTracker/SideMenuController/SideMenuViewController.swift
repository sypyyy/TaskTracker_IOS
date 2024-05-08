

import UIKit

enum SideMenuRowInfo: Equatable {
    case defaultRow(SideMenuDefaultRowType)
    case Folder(id: String)
    case List(id: String)
    case CustomFilter(id: String)
    case Label(id: String)
}

class SideMenuViewController: UIViewController {
    var activeRowInfo: SideMenuRowInfo = .defaultRow(.today)
    var activeRowId: String?
    
    let persistenceController = PersistenceController.shared
    //一个可以放头像之类的section，现在没用，是空的
    private var topHeaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()

    private var sideMenuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var screenWidth: CGFloat {
        view.frame.size.width
    }

    private var leadingConstraint: NSLayoutConstraint!
    private var shadowColor: UIColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.2)
    weak var delegate: SideMenuDelegate?
    
    private var tableData: SideMenuTableViewDatas = SideMenuTableViewDatas()
    
    internal var nodeArray: [AnyTreeNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureView()
        updateTableView()
        selectRow(row: SideMenuRowInfo.defaultRow(.today))
    }
    
    private func loadData() {
        dummyRootNode.removeAllChildren()
        nodeArray = []
        //Put default rows in (Today, inbox blablabla)
        defaultSideMenuRows.forEach {node in
            dummyRootNode.addChild(node)
        }
        //Put folders in
        let rootFolders = persistenceController.getAllRootFolders()
        let rootLists = persistenceController.getAllRootLists()
        dummyRootNode.addChildren(rootFolders.map{ folder in
            FolderModel(folder: folder, parent: dummyRootNode)
        } + rootLists.map{ list in
            ListModel(list: list, parent: dummyRootNode)
        })
        for node in dummyRootNode.children {
            traverse(node: node)
        }
        func traverse(node: AnyTreeNode) {
            nodeArray.append(node)
            if(node.isExpanded) {
                node.children.forEach{ child in
                    traverse(node: child)
                }
            }
        }
    }
    
    private func configureView() {
        view.backgroundColor = .clear
        view.frame.origin.x = -screenWidth

        addSubviews()
        configureTableView()
        configureTapGesture()
    }

    private func addSubviews() {
        view.addSubview(sideMenuView)
        addMaterialBackgroundToSideMenu()
        sideMenuView.addSubview(topHeaderView)
        sideMenuView.addSubview(tableView)
        configureConstraints()
    }
    
    private func addMaterialBackgroundToSideMenu() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = sideMenuView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideMenuView.insertSubview(blurEffectView, at: 0)
    }

    private func configureConstraints() {
        sideMenuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingConstraint = sideMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -view.frame.size.width)
        leadingConstraint.isActive = true
        sideMenuView.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.8).isActive = true
        sideMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        topHeaderView.topAnchor.constraint(equalTo: sideMenuView.topAnchor).isActive = true
        topHeaderView.leadingAnchor.constraint(equalTo: sideMenuView.leadingAnchor).isActive = true
        topHeaderView.trailingAnchor.constraint(equalTo: sideMenuView.trailingAnchor).isActive = true
        topHeaderView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        tableView.topAnchor.constraint(equalTo: topHeaderView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: sideMenuView.leadingAnchor, constant: 6).isActive = true
        tableView.trailingAnchor.constraint(equalTo: sideMenuView.trailingAnchor, constant: -6).isActive = true
        tableView.bottomAnchor.constraint(equalTo: sideMenuView.bottomAnchor).isActive = true
    }

    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.register(SideMenuItemCell.self, forCellReuseIdentifier: SideMenuItemCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
    }

    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func tapped() {
        hide()
    }

    func show() {
        self.view.frame.origin.x = 0
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = self.shadowColor
            self.leadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    func hide() {
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .clear
            self.leadingConstraint.constant = -self.screenWidth
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.view.frame.origin.x = -self.screenWidth
        }
    }
    
    func translateLeft(by: CGFloat) {
        if(leadingConstraint.constant - by > 0) {
            leadingConstraint.constant = 0
            return
        }
        leadingConstraint.constant -= by
    }
    
    func onSwipeEnded() {
        if(leadingConstraint.constant < -100) {
            self.hide()
        } else {
            show()
        }
        
    }
}

extension SideMenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false }
        if view === topHeaderView || view.isDescendant(of: tableView) {
            return false
        }
        return true
    }
}




extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodeArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(rowIdx: indexPath.row)
    }
    
    private func getCell(rowIdx: Int) -> UITableViewCell {
        if(rowIdx >= nodeArray.count) {
            return UITableViewCell()
        }
        let node: AnyTreeNode = nodeArray[rowIdx]
        switch node.subTypeInfo {
        case .sideMenuRow(info: .Folder(_)):
            guard let folder = node as? FolderModel, let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuItemCell.identifier) as? SideMenuItemCell else {
                return UITableViewCell()
            }
            cell.configureCell(icon: nil, text: folder.name, isExpandable: folder.children.count > 0, isExpanded: folder.isExpanded, delegate: self, nodeId: node.id, indentLevel: folder.level)
            return cell
        case .sideMenuRow(info: .List(_)):
            guard let list = node as? ListModel, let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuItemCell.identifier) as? SideMenuItemCell else {
                return UITableViewCell()
            }
            cell.configureCell(icon: nil, text: list.name, isExpandable: false, isExpanded: false, delegate: self, nodeId: node.id, indentLevel: list.level)
            return cell
        case .sideMenuRow(info: .defaultRow(let defaultRow)):
            guard let sideMenuRow = node as? SideMenuDefaultRow, let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuItemCell.identifier) as? SideMenuItemCell else {
                return UITableViewCell()
            }
            cell.configureCell(icon: nil, text: sideMenuRow.title, isExpandable: false, isExpanded: false, delegate: self, nodeId: node.id, indentLevel: 0)
            return cell
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        /*
        if let item = tableData.indexPath2SideMenuItemMapping[indexPath] {
            delegate?.itemSelected(item: item.viewController)
        }
         */
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           // Your custom appearance logic goes here.
           // Example: Setting rounded corners and shadow
        if let itemCell = cell as? SideMenuItemCell {
            if itemCell.nodeId != self.activeRowId {
                itemCell.contentView.backgroundColor = .clear
            }
            itemCell.contentView.layer.cornerRadius = 10
            itemCell.contentView.layer.masksToBounds = true
        }
       }
    
    private func updateTableView() {
        self.tableView.performBatchUpdates() {
            let oldNodeArr = nodeArray
            let newNodeArr = self.getNewNodeArray()
            nodeArray = newNodeArr
            self.updateTable(tableView: tableView, oldModelArray: oldNodeArr, newModelArray: newNodeArr)
        }
    }
    
    func expandOrCollapseFolder(nodeId: String) {
        guard let folder = nodeArray.first(where: {
            $0.id == nodeId
        }) as? FolderModel else {
            return
        }
        folder.isExpanded = !folder.isExpanded
        updateTableView()
    }
}



//这边开始是关于tableViewDelegate的
class SideMenuTableViewDatas {
    var dummyRoot: AnyTreeNode = AnyTreeNode()
    var indexPath2SideMenuRowInfoMapping: [IndexPath: SideMenuRowInfo] = [:]
}

extension SideMenuViewController: TreeBasedTableViewController {
    
    var dummyRootNode: AnyTreeNode {
        get {
            return tableData.dummyRoot
        }
        set {
            self.tableData.dummyRoot = newValue
        }
    }

}

extension SideMenuViewController {
    func selectRow(row: SideMenuRowInfo) {
        nodeArray.enumerated().forEach { (idx, node) in
            switch node.subTypeInfo {
            case .sideMenuRow(let info):
                if info == row {
                    activeRowId = node.id
                    (tableView.cellForRow(at: IndexPath(row: idx, section: 0)) as? SideMenuItemCell)?.highlight()
                } else {
                    (tableView.cellForRow(at: IndexPath(row: idx, section: 0)) as? SideMenuItemCell)?.unHighlight()
                }
            default:
                break
            }
        }
    }
    
    func didTapRow(nodeId: String) {
        nodeArray.enumerated().forEach { (idx, node) in
            if node.id == nodeId {
                activeRowId = node.id
                (tableView.cellForRow(at: IndexPath(row: idx, section: 0)) as? SideMenuItemCell)?.highlight()
            } else {
                (tableView.cellForRow(at: IndexPath(row: idx, section: 0)) as? SideMenuItemCell)?.unHighlight()
            }
        }

    }
}



