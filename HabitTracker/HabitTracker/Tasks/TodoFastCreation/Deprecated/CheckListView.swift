//
//  CheckListDelegate.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/3/30.
//
/*
import UIKit
//Deprecated
class CheckListView: UITableView, UITableViewDelegate, UITableViewDataSource {
    weak var viewControllerAsDelegate: TodoFastCreatViewController?
    var items: [CheckItemModel] = []
    var modelToViewMapping: [CheckItemModel: CheckListItemView] = [:]
    
    var rootModel: CheckItemModel = {
        var res = CheckItemModel()
        res.isExpanded = true
        return res
    }()
    
    init(frame: CGRect, style: UITableView.Style, delegate: TodoFastCreatViewController) {
        super.init(frame: frame, style: style)
        self.viewControllerAsDelegate = delegate
        self.delegate = self
        self.dataSource = self
        self.allowsSelection = false
        self.register(CheckListItemCell.self, forCellReuseIdentifier: "CheckListItemCell")
        self.separatorStyle = .none
        // Initialize your root model and flatten it
        rootModel.addChild(child: CheckItemModel())
        autoUpdateView()
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCheckListItem(_ child: CheckItemModel, below parentView: CheckListItemView) {
        let parent = parentView.checkItemModel
        parent.addChild(child: child)
        if !parent.isExpanded {
            expandOrCollapseItem(view: parentView)
        } else {
            autoUpdateView()
        }
    }
    
    func expandOrCollapseItem(view: CheckListItemView) {
        let model = view.checkItemModel
        if model.isExpanded {
            model.isExpanded = false
            collapseHelper(model: model)
        } else {
            model.isExpanded = true
        }
        autoUpdateView()
        
        func collapseHelper(model: CheckItemModel) {
            model.isExpanded = false
            model.children.forEach { child in
                collapseHelper(model: child)
            }
        }
    }
    
    func autoUpdateView() {
        var oldModelArr_Modified = self.items
        var oldModelArray = self.items
        func traverseChildren(model: CheckItemModel) {
            if let parent = model.parent, parent.isExpanded {
                newModelArray.append(model)
                if(oldModelArray.contains(model)) {
                    newModelArrWithoutAddition.append(model)
                } else {
                    modelsToAdd.append(model)
                }
            }
            model.level = (model.parent?.level ?? 0) + 1
            model.children.forEach { child in
                traverseChildren(model: child)
            }
        }
        
        var newModelArray = [CheckItemModel]()
        var modelsToAdd = [CheckItemModel]()
        var newModelArrWithoutAddition = [CheckItemModel]()
        self.rootModel.children.forEach { model in
            traverseChildren(model: model)
        }
        
        var deletionIdxSet = IndexSet()
        //First lets delete the views that are not in the new model array.
        oldModelArray.enumerated().forEach { idx, model in
            if !newModelArray.contains(model) {
                deletionIdxSet.insert(idx)
            }
        }
        oldModelArr_Modified.remove(atOffsets: deletionIdxSet)
        //Time to compare what's left and see if any model is moved
        var modelsToMove = Set<CheckItemModel>()
        oldModelArr_Modified.enumerated().forEach { idx, model in
            let newModel = newModelArrWithoutAddition[idx]
            if newModel !== model {
                modelsToMove.insert(newModel)
            }
        }
        
        //Alright got em all, now update the view
        self.performBatchUpdates{
            items = newModelArray
            var viewsToHide = [CheckListItemView]()
            deletionIdxSet.enumerated().forEach { _, idx in
                self.deleteRows(at: [IndexPath(row: idx, section: 0)], with: .fade)
            }
            /*
            modelsToMove.forEach { model in
                if let idx = newModelArray.firstIndex(of: model) {
                    self.deleteRows(at: [IndexPath(row: idx, section: 0)], with: .fade)
                }
            }
            modelsToMove.forEach { model in
                if let idx = newModelArray.firstIndex(of: model) {
                    self.insertRows(at: [IndexPath(row: idx, section: 0)], with: .fade)
                }
            }
             */
            modelsToAdd.forEach { model in
                let idx = newModelArray.firstIndex(of: model) ?? 0
                self.insertRows(at: [IndexPath(row: idx, section: 0)], with: .fade)
            }
            /*
            self.arrangedSubviews.forEach {view in
                (view as? CheckListItemView)?.updateIndent()
                //view.frame.size.width = 300
                //view.autoresizingMask = .flexibleWidth
            }
            */
        }
        
    }
}

extension CheckListView {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListItemCell", for: indexPath) as! CheckListItemCell
        let item = items[indexPath.row]
        cell.configure(with: item, delegate: self)
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        30
    }
}

class CheckListItemView: UIView {
    weak var checkListAsDelegate: CheckListView?
    weak var ownerViewContoller: TodoFastCreatViewController?
    let checkItemModel: CheckItemModel
    var level: Int {
        return checkItemModel.level
    }
    static let CHECKBOX_SIZE: CGFloat = 25
    let checkBox = CheckBoxButton(checked: false)
    let textView = UITextField()
    var expandButton: UIButton?
    var textViewHeightConstraint: NSLayoutConstraint?
    var hasChild: Bool {
        return checkItemModel.children.count > 0
    }
    let INDENT: CGFloat = 16
    var indentSpacing: CGFloat {
        return INDENT * CGFloat(level)
    }

        
    init(buttonDelegate: CheckListView, checkItemModel: CheckItemModel) {
        self.checkListAsDelegate = buttonDelegate
        self.ownerViewContoller = buttonDelegate.viewControllerAsDelegate
        self.checkItemModel = checkItemModel
        super.init(frame: .zero)
        configureViews()
        configureConstraints()
        updateExpandButton()
        //self.translatesAutoresizingMaskIntoConstraints = false
        
       
        //self.backgroundColor = .white
    }
    
    private func configureViews() {
        
        self.addSubview(checkBox)
        self.addSubview(textView)
        textView.text = checkItemModel.content
        textView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textView.addTarget(self, action: #selector(textFieldDidStartEditing(_:)), for: .editingDidBegin)
        textView.backgroundColor = .clear
        textViewHeightConstraint = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        textViewHeightConstraint?.isActive = true
    }
    static var EXPAND_BUTTON_SIZE: CGFloat = 25
    
    private func updateExpandButton() {
        
        if hasChild {
            expandButton = UIButton()
        } else {
            expandButton?.removeFromSuperview()
        }
        if hasChild, let expandButton = expandButton {
            expandButton.setImage(UIImage(systemName: "chevron.down") ?? UIImage(), for: .normal)
            expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
            self.addSubview(expandButton)
            expandButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                expandButton.trailingAnchor.constraint(equalTo: checkBox.leadingAnchor, constant: 4),
            expandButton.widthAnchor.constraint(equalToConstant: CheckListItemView.EXPAND_BUTTON_SIZE),
            ])
        }
    }
    private func configureConstraints() {
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        expandButton?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            checkBox.widthAnchor.constraint(equalToConstant: CheckListItemView.CHECKBOX_SIZE),
            checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textView.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func addItem() {
        checkListAsDelegate?.addCheckListItem(CheckItemModel(), below: self)
        updateExpandButton()
    }
    
    @objc func expandButtonTapped() {
        checkListAsDelegate?.expandOrCollapseItem(view: self)
    }
        
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CheckListItemView {
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkItemModel.content = textField.text ?? ""
    }
    
    @objc func textFieldDidStartEditing(_ textField: UITextField) {
        ownerViewContoller?.setEditingSectionType(.subtodo(self))
    }
    
}

class CheckBoxButton: UIButton {
    var checked: Bool = false
    
    init(checked: Bool) {
        super.init(frame: .zero)
        self.checked = checked
        setImage(UIImage(systemName: "square") ?? UIImage(), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CheckListItemCell: UITableViewCell {
    var checkItemModel: CheckItemModel?
    var checkItemView: CheckListItemView?
    // Add UI components (e.g., checkBox, textView) and layout constraints
    
    func configure(with model: CheckItemModel, delegate: CheckListView) {
        self.checkItemModel = model
        let indentSpacing = CGFloat((model.level - 1) * 16)
        if let view = checkItemView {
            view.removeFromSuperview()
        }
        checkItemView = CheckListItemView(buttonDelegate: delegate, checkItemModel: model)
        checkItemView?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkItemView ?? UIView())
        NSLayoutConstraint.activate([
            checkItemView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: indentSpacing) ?? NSLayoutConstraint(),
            checkItemView?.trailingAnchor.constraint(equalTo: contentView.trailingAnchor) ?? NSLayoutConstraint(),
            checkItemView?.topAnchor.constraint(equalTo: contentView.topAnchor) ?? NSLayoutConstraint(),
            checkItemView?.bottomAnchor.constraint(equalTo: contentView.bottomAnchor) ?? NSLayoutConstraint()
        ])
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Setup UI components
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Add functions to handle UI updates
}

*/


/*
 
 import UIKit

 final class CheckItemModel: Codable {
     var isChecked: Bool
     var content: String
     var level: Int
     var isEditing: Bool
     var sumOfAllChildren: Int {
         var res = 0
         children.forEach { res += (1 + $0.sumOfAllChildren) }
         return res
     }
     var isExpanded: Bool = false
     var parent: CheckItemModel?
     var children: [CheckItemModel]
     
     init(isChecked: Bool, content: String, level: Int, isEditing: Bool, parent: CheckItemModel?, children: [CheckItemModel]) {
         self.isChecked = isChecked
         self.content = content
         self.level = level
         self.isEditing = isEditing
         self.parent = parent
         self.children = children
     }
     
     init() {
         self.isChecked = false
         self.content = ""
         self.level = 0
         self.isEditing = false
         self.parent = nil
         self.children = []
     }
     
     func addChild(child: CheckItemModel) {
         child.parent = self
         children.append(child)
     }
     
     func removeChild(child: CheckItemModel) {
         children.removeAll { $0 === child }
     }
     
     func removeChild(at index: Int) {
         children.remove(at: index)
     }
     
     func removeAllChildren() {
         children.removeAll()
     }
     
     func isLeaf() -> Bool {
         return children.isEmpty
     }
     
     func isRoot() -> Bool {
         return parent == nil
     }
     
     func isLastChild() -> Bool {
         return parent?.children.last === self
     }
     
     func isFirstChild() -> Bool {
         return parent?.children.first === self
     }
     
     func isOnlyChild() -> Bool {
         return parent?.children.count == 1
     }
 }

 extension CheckItemModel: Equatable {
     static func == (lhs: CheckItemModel, rhs: CheckItemModel) -> Bool {
         return lhs === rhs
     }
 }

 extension CheckItemModel: Hashable {
     func hash(into hasher: inout Hasher) {
         hasher.combine(ObjectIdentifier(self))
     }
 }

 */
