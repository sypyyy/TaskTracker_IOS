//
//  CheckListDelegate.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/3/30.
//

import UIKit
//Deprecated
class CheckListView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var items: [CheckItemModel] = []
    var modelToViewMapping: [CheckItemModel: CheckListItemView] = [:]
    
    var rootModel: CheckItemModel = {
        var res = CheckItemModel()
        res.isExpanded = true
        return res
    }()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
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

class CheckListItemView: UIView, UITextFieldDelegate {
    weak var buttonDelegate: CheckListView?
    let checkItemModel: CheckItemModel
    var level: Int {
        return checkItemModel.level
    }
    let checkBox = CheckBoxButton(checked: false)
    let textView = UITextField()
    var textViewHeightConstraint: NSLayoutConstraint?
    
    let INDENT: CGFloat = 16
    var indentSpacing: CGFloat {
        return INDENT * CGFloat(level)
    }
        
    init(buttonDelegate: CheckListView, checkItemModel: CheckItemModel) {
        self.buttonDelegate = buttonDelegate
        self.checkItemModel = checkItemModel
        super.init(frame: .zero)
        //self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(checkBox)
        self.addSubview(textView)
        textView.text = checkItemModel.content
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.backgroundColor = .red
        textViewHeightConstraint = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        textViewHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.clipsToBounds = true
        
        let expandButton = UIButton()
        stackView.addArrangedSubview(expandButton)
        expandButton.setImage(UIImage(systemName: "chevron.down") ?? UIImage(), for: .normal)
        expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        
        let addItemButton = UIButton()
        stackView.addArrangedSubview(addItemButton)
        addItemButton.setImage(UIImage(systemName: "plus") ?? UIImage(), for: .normal)
        addItemButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 30),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        //self.backgroundColor = .white
    }
    
    @objc func expandButtonTapped() {
       
        buttonDelegate?.expandOrCollapseItem(view: self)
        
    }
    
    @objc func addItem() {
     
        buttonDelegate?.addCheckListItem(CheckItemModel(), below: self)
        
    }
        
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CheckListItemView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkItemModel.content = textView.text
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

