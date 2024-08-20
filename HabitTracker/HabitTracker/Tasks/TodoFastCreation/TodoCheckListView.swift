//
//  TodoCheckListView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/8/11.
//

import UIKit
//Deprecated
class TodoCheckListView: UITableView, UITableViewDelegate, UITableViewDataSource {
    weak var viewControllerAsDelegate: TodoFastCreatViewController?
    var items: [CheckItemModel] = [CheckItemModel()]
    var cellHeights: [(Bool, CGFloat)] = [(true, CheckListItemView.ROW_HEIGHT)]
    
    init(frame: CGRect, style: UITableView.Style, delegate: TodoFastCreatViewController) {
        super.init(frame: frame, style: style)
        self.viewControllerAsDelegate = delegate
        self.isScrollEnabled = false
        //self.panGestureRecognizer.isEnabled = false
        self.delegate = self
        self.dataSource = self
        self.allowsSelection = false
        self.register(CheckListItemCell.self, forCellReuseIdentifier: "CheckListItemCell")
        self.separatorStyle = .none
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCheckListItem(below itemview: CheckListItemView) {
        let insertIndex = (items.firstIndex(of: itemview.checkItemModel) ?? items.count) + 1
        self.performBatchUpdates{
            items.insert(CheckItemModel(), at: insertIndex)
            cellHeights.insert((true, CheckListItemView.ROW_HEIGHT), at: insertIndex)
            self.insertRows(at: [IndexPath(row: insertIndex, section: 0)], with: .fade)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.viewControllerAsDelegate?.updateSubTodoHeight()
            }
        }
    }
}

extension TodoCheckListView {
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
        if indexPath.row < cellHeights.count && cellHeights[indexPath.row].0 {
            return cellHeights[indexPath.row].1
        }
        if let cell = tableView.cellForRow(at: indexPath) as? CheckListItemCell {
            if let textView = cell.checkItemView?.textView {
                return textView.sizeThatFits(.init(width: textView.frame.width, height: .greatestFiniteMagnitude)).height
            }
        }
        return CheckListItemView.ROW_HEIGHT
    }
}

class CheckListItemView: UIView {
    weak var checkListAsDelegate: TodoCheckListView?
    weak var ownerViewContoller: TodoFastCreatViewController?
    let checkItemModel: CheckItemModel
    static let CHECKBOX_SIZE: CGFloat = 25
    let checkBox = CheckBoxButton(checked: false)
    let textView = UITextView()
    var deleteButton = UIButton()
    var textViewHeightConstraint: NSLayoutConstraint?
        
    init(buttonDelegate: TodoCheckListView, checkItemModel: CheckItemModel) {
        self.checkListAsDelegate = buttonDelegate
        self.ownerViewContoller = buttonDelegate.viewControllerAsDelegate
        self.checkItemModel = checkItemModel
        super.init(frame: .zero)
        configureViews()
        configureConstraints()
        //self.translatesAutoresizingMaskIntoConstraints = false
        
       
        //self.backgroundColor = .white
    }
    
    private func setDeleteButton() {
        deleteButton.setImage(UIImage(systemName: "xmark") ?? UIImage(), for: .normal)
        deleteButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
    }
    
    private func configureViews() {
        setDeleteButton()
        self.addSubview(checkBox)
        self.addSubview(textView)
        self.addSubview(deleteButton)
        textView.text = checkItemModel.content
        textView.isScrollEnabled = false
        textView.delegate = self
        //textView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        //textView.addTarget(self, action: #selector(textFieldDidStartEditing(_:)), for: .editingDidBegin)
        textView.backgroundColor = .clear
        
    }
    static let BUTTON_SIZE: CGFloat = 25
    static let ROW_HEIGHT: CGFloat = 30
    
    private func configureConstraints() {
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: CheckListItemView.ROW_HEIGHT)
        textViewHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            checkBox.widthAnchor.constraint(equalToConstant: CheckListItemView.CHECKBOX_SIZE),
            checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textView.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 2),
            textView.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //deleteButton.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 4),
            deleteButton.widthAnchor.constraint(equalToConstant: CheckListItemView.BUTTON_SIZE),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        ])
    }
    
    func addItem() {
        checkListAsDelegate?.addCheckListItem(below: self)
    }
    
    @objc func expandButtonTapped() {
       
    }
        
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CheckListItemView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        ownerViewContoller?.setEditingSectionType(.subtodo(self))
    }
    func textViewDidChange(_ textView: UITextView) {
        /*
        let textHeight = textView.sizeThatFits(.init(width: textView.frame.width, height: .greatestFiniteMagnitude)).height
        let oldHeight =
        textViewHeightConstraint?.constant = max(CheckListItemView.ROW_HEIGHT, textHeight)
        
         */
        let index = checkListAsDelegate?.items.firstIndex(of: checkItemModel) ?? 0
        let newHeight = textView.sizeThatFits(.init(width: textView.frame.width, height: .greatestFiniteMagnitude)).height
        checkListAsDelegate?.cellHeights[index].1 = newHeight
        textViewHeightConstraint?.constant = newHeight
        self.checkListAsDelegate?.performBatchUpdates {
            
        } completion: {_ in
            UIView.animate(withDuration: 0.1) {
                self.ownerViewContoller?.updateSubTodoHeight()
            }
        }
        
        // This method is called every time the text changes.
        print("Text view content changed: \(textView.text!)")
        
        
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
    
    func configure(with model: CheckItemModel, delegate: TodoCheckListView) {
        self.checkItemModel = model
        if let view = checkItemView {
            view.removeFromSuperview()
        }
        checkItemView = CheckListItemView(buttonDelegate: delegate, checkItemModel: model)
        checkItemView?.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkItemView ?? UIView())
        NSLayoutConstraint.activate([
            checkItemView?.leadingAnchor.constraint(equalTo: contentView.leadingAnchor) ?? NSLayoutConstraint(),
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
