//
//  TodoCheckListView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/8/11.
//

import UIKit
import SwiftUI

class TodoCheckListView: UIStackView {
    weak var viewControllerAsDelegate: TodoFastCreatViewController?
    
    init(frame: CGRect, style: UITableView.Style, delegate: TodoFastCreatViewController) {
        super.init(frame: frame)
        self.alignment = .fill
        self.distribution = .equalSpacing
        self.axis = .vertical
        self.viewControllerAsDelegate = delegate
        addCheckListItem(below: nil)
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCheckListItem(below itemview: CheckListItemView?) {
        if let itemview = itemview {
            let arrangedSubviews = self.arrangedSubviews
            if let insertIndex = self.arrangedSubviews.firstIndex(of: itemview) {
                addCheckListItem(insertIndex: insertIndex + 1)
            }
        } else {
            addCheckListItem(insertIndex: 0)
        }
        
        func addCheckListItem(insertIndex: Int) {
            let newModel = CheckItemModel()
            let newView = CheckListItemView(buttonDelegate: self, checkItemModel: newModel)
            
            newView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(newView)
            NSLayoutConstraint.activate([
                newView.widthAnchor.constraint(equalTo: self.widthAnchor),
            ])
            var initialTopConstraint: NSLayoutConstraint? = nil
            if insertIndex > 0 {
                initialTopConstraint = newView.topAnchor.constraint(equalTo: self.arrangedSubviews[insertIndex - 1].topAnchor)
                initialTopConstraint?.isActive = true
            }
            newView.alpha = 0
            self.layoutIfNeeded()
            UIView.animate(withDuration: 0.15) {
                initialTopConstraint?.isActive = false
                self.insertArrangedSubview(newView, at: insertIndex)
                newView.alpha = 1
                self.viewControllerAsDelegate?.view.layoutIfNeeded()
                newView.textView.becomeFirstResponder()
            } completion: { _ in
                
            }
            
        }
        
        
        
    }
    
    func removeCheckListItem(item itemView: CheckListItemView) {
        if(self.arrangedSubviews.count > 1) {
            itemView.textView.resignFirstResponder()
            let arrangedSubviews = self.arrangedSubviews
            self.removeArrangedSubview(itemView)
            itemView.removeFromSuperview()
            self.layoutIfNeeded()
        }
    }
}


class CheckListItemView: UIView {
    weak var checkListAsDelegate: TodoCheckListView?
    weak var ownerViewContoller: TodoFastCreatViewController?
    let checkItemModel: CheckItemModel
    let checkBox = CheckBoxButton(checked: false)
    static let FONT_SIZE: CGFloat = 16
    static let HORI_MARGIN: CGFloat = 10
    let textView: UITextView = {
        let res = UITextView()
        res.font = UIFont.systemFont(ofSize: FONT_SIZE)
        res.textColor = UIColor(Color.primary.lighter(by: 24))
        return res
    }()
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
        deleteButton.addTarget(self, action: #selector(attemptToRemoveItem), for: .touchUpInside)
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
    static let ROW_HEIGHT: CGFloat = {
        let lineHeight = UIFont.systemFont(ofSize: FONT_SIZE).lineHeight
        let defaultTextView = UITextView()
        defaultTextView.font = UIFont.systemFont(ofSize: FONT_SIZE)
        let textContainerInsets = defaultTextView.textContainerInset
        let lineFragmentPadding = defaultTextView.textContainer.lineFragmentPadding
        let totalVerticalPadding = textContainerInsets.top + textContainerInsets.bottom
        return lineHeight + totalVerticalPadding
    }()
    
    private func configureConstraints() {
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: CheckListItemView.ROW_HEIGHT)
        textViewHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: CheckListItemView.HORI_MARGIN),
            checkBox.widthAnchor.constraint(equalToConstant: UIFont.systemFont(ofSize: CheckListItemView.FONT_SIZE).lineHeight),
            checkBox.heightAnchor.constraint(equalToConstant: UIFont.systemFont(ofSize: CheckListItemView.FONT_SIZE).lineHeight),
            checkBox.topAnchor.constraint(equalTo: self.topAnchor, constant: textView.textContainerInset.top),
            textView.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 2),
            textView.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //deleteButton.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 4),
            deleteButton.widthAnchor.constraint(equalToConstant: UIFont.systemFont(ofSize: CheckListItemView.FONT_SIZE).lineHeight),
            deleteButton.heightAnchor.constraint(equalToConstant: UIFont.systemFont(ofSize: CheckListItemView.FONT_SIZE).lineHeight),
            deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: textView.textContainerInset.top),
            deleteButton.widthAnchor.constraint(equalToConstant: CheckListItemView.ROW_HEIGHT),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -CheckListItemView.HORI_MARGIN),
        ])
    }
    
    func addItem() {
        checkListAsDelegate?.addCheckListItem(below: self)
    }
    
    @objc func attemptToRemoveItem() {
        checkListAsDelegate?.removeCheckListItem(item: self)
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
        
        let newHeight = textView.sizeThatFits(.init(width: textView.frame.width, height: .greatestFiniteMagnitude)).height
        textViewHeightConstraint?.constant = newHeight
        // This method is called every time the text changes.
        print("Text view content changed: \(textView.text!)")
        
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Check if the replacement text is the "Enter" key (Return key)
        if text == "\n" {
            // Handle the "Enter" key press (e.g., dismiss the keyboard)
            addItem()
            return false // Prevents adding a newline character in the textView
        }
        /*
        if text.isEmpty {
            // Check if the UITextView is already empty
            if textView.text.isEmpty {
                attemptToRemoveItem()
                return false
            }
        }
         */
        return true
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
