//
//  TodoFastCreatViewController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/3/28.
//

import UIKit

class InsetTextField: UITextField {
    // Define the inset values
    var textInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    // Adjust the text position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    // Adjust the text position while editing
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
    
    // Optionally adjust the placeholder position
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
}

final class TodoFastCreatViewController: UIViewController, UITextViewDelegate {
    let TEXT_FIELD_BACKGROUND_COLOR = UIColor.lightGray.withAlphaComponent(0.15)
    let SECTION_CORNER_RADIUS: CGFloat = 12
    let FORM_HORIZONTAL_PADDING: CGFloat = 14
    let TODO_DESCRIPTION_MIN_HEIGHT: CGFloat = 200
    var todoDescriptView = UITextView()
    var todoNameView = {
        let res = InsetTextField()
        res.tintColor = .darkGray
        return res
    }()
    
    //Sub Todo
    let SUB_TODO_MIN_HEIGHT: CGFloat = 200
    var subTodoView = CheckListView(frame: .zero, style: .plain)
    var subTodoHeightConstraint: NSLayoutConstraint?
    var subTodoWrapper = UIView()
    var todoDescriptionHeightConstraint: NSLayoutConstraint!
    //States
    var hasSubTodo: Bool {
        get {
            subTodoView.superview != nil
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configureViews()
        configureGestures()
    }
    
    private func configureViews() {
        addSubviews()
        configureConstraints()
        setupTodoAccessoryView()
    }
    
    private func addSubviews() {
        todoNameView.backgroundColor = TEXT_FIELD_BACKGROUND_COLOR
        todoNameView.layer.cornerRadius = SECTION_CORNER_RADIUS
        todoNameView.placeholder = "To-Do"
        view.addSubview(todoNameView)
        subTodoWrapper.backgroundColor = .clear
        view.addSubview(subTodoWrapper)
        subTodoView.backgroundColor = TEXT_FIELD_BACKGROUND_COLOR
        subTodoView.layer.cornerRadius = SECTION_CORNER_RADIUS
        todoDescriptView.backgroundColor = TEXT_FIELD_BACKGROUND_COLOR
        todoDescriptView.isEditable = true
        todoDescriptView.isScrollEnabled = false
        todoDescriptView.layer.cornerRadius = SECTION_CORNER_RADIUS
        todoDescriptView.delegate = self
        todoDescriptView.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 2)
        view.addSubview(todoDescriptView)
        
        
    }

    
    private func configureConstraints() {
        todoNameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todoNameView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            todoNameView.heightAnchor.constraint(equalToConstant: 40),
            todoNameView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FORM_HORIZONTAL_PADDING),
            todoNameView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FORM_HORIZONTAL_PADDING),
        ])
        subTodoWrapper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTodoWrapper.topAnchor.constraint(equalTo: todoNameView.bottomAnchor, constant: 0),
            subTodoWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FORM_HORIZONTAL_PADDING),
            subTodoWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FORM_HORIZONTAL_PADDING),
        ])
        todoDescriptView.translatesAutoresizingMaskIntoConstraints = false
        todoDescriptionHeightConstraint = todoDescriptView.heightAnchor.constraint(equalToConstant: TODO_DESCRIPTION_MIN_HEIGHT)
        todoDescriptionHeightConstraint.isActive = true
        NSLayoutConstraint.activate([
            todoDescriptView.topAnchor.constraint(equalTo: subTodoWrapper.bottomAnchor, constant: 20),
            todoDescriptView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FORM_HORIZONTAL_PADDING),
            todoDescriptView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FORM_HORIZONTAL_PADDING),
        ])
        
    }
    
    @objc func toggleSubTodoView(_ sender: UIButton) {
        if !hasSubTodo {
            insertSubTodoView()
        } else {
            removeSubTodoView()
        }
        (sender as? AccessoryButton)?.isActive = hasSubTodo
    }
    
   func insertSubTodoView() {
        self.subTodoView.alpha = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else {return}
            subTodoView.alpha = 1
            subTodoWrapper.addSubview(subTodoView)
            subTodoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subTodoView.heightAnchor.constraint(equalToConstant: 300),
                subTodoView.topAnchor.constraint(equalTo: subTodoWrapper.topAnchor, constant: 20),
                subTodoView.leadingAnchor.constraint(equalTo: subTodoWrapper.leadingAnchor),
                subTodoView.trailingAnchor.constraint(equalTo: subTodoWrapper.trailingAnchor),
                subTodoView.bottomAnchor.constraint(equalTo: subTodoWrapper.bottomAnchor),
            ])
            view.layoutIfNeeded()
        } completion: { _ in
            
        }
    }
    
    private func removeSubTodoView() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else {return}
            subTodoView.removeFromSuperview()
            view.layoutIfNeeded()
        }
    }
    
    private func configureGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == todoDescriptView {
            let textHeight = todoDescriptView.sizeThatFits(.init(width: todoDescriptView.frame.width, height: .greatestFiniteMagnitude)).height + 5
            todoDescriptionHeightConstraint.constant = max(TODO_DESCRIPTION_MIN_HEIGHT, textHeight)
                // This method is called every time the text changes.
                print("Text view content changed: \(textView.text!)")
        }
        if textView == subTodoView {
            let textHeight = subTodoView.sizeThatFits(.init(width: subTodoView.frame.width, height: .greatestFiniteMagnitude)).height + 5
            subTodoHeightConstraint?.constant = max(SUB_TODO_MIN_HEIGHT, textHeight)
                // This method is called every time the text changes.
                print("Text view content changed: \(textView.text!)")
        }
        
    }
}

extension TodoFastCreatViewController {
    func setupTodoAccessoryView() {
        // Setup the custom input accessory view
        let todoAccessorySubView = UIView()
        todoAccessorySubView.translatesAutoresizingMaskIntoConstraints = false
        todoAccessorySubView.backgroundColor = .clear
        todoNameView.inputAccessoryView = getTodoAccessoryView()
        todoDescriptView.inputAccessoryView = getTodoAccessoryView()
    
    }
    
    func getTodoAccessoryView() -> AccessoryView {
        let listButton = AccessoryButton(isActive: hasSubTodo, activeImage: UIImage(systemName: "checklist") ?? UIImage(), activeColor: .systemBlue, inactiveImage: UIImage(systemName: "checklist") ?? UIImage(), inactiveColor: nil)
        listButton.addTarget(self, action: #selector(toggleSubTodoView(_:)), for: .touchUpInside)
        let subTaskButton = AccessoryButton(isActive: true, activeImage: UIImage(resource: .subtask) ?? UIImage(), activeColor: .systemBlue, inactiveImage: UIImage(resource: .subtask) ?? UIImage(), inactiveColor: nil)
        subTaskButton.addTarget(self, action: #selector(toggleSubTodoView(_:)), for: .touchUpInside)
        return AccessoryView(buttons: [listButton, subTaskButton])
    }
    
    func getChecklistAccessoryView() -> AccessoryView {
        let listButton = AccessoryButton(isActive: hasSubTodo, activeImage: UIImage(systemName: "checklist") ?? UIImage(), activeColor: .systemBlue, inactiveImage: UIImage(systemName: "checklist") ?? UIImage(), inactiveColor: nil)
        listButton.addTarget(self, action: #selector(toggleSubTodoView(_:)), for: .touchUpInside)
        let subTaskButton = AccessoryButton(isActive: true, activeImage: UIImage(resource: .subtask) ?? UIImage(), activeColor: .systemBlue, inactiveImage: UIImage(resource: .subtask) ?? UIImage(), inactiveColor: nil)
        subTaskButton.addTarget(self, action: #selector(toggleSubTodoView(_:)), for: .touchUpInside)
        return AccessoryView(buttons: [listButton, subTaskButton])
    }
}


class AccessoryView: UIView {
    //accessory
    static let ACCESSORY_HEIGHT: CGFloat = 60
    //var accessoryHConstraint: NSLayoutConstraint?
    
    var backgroundView: UIView
    var stackView: UIStackView
    var buttons: [AccessoryButton]
    
    init(buttons: [AccessoryButton]) {
        self.backgroundView = UIView()
        self.stackView = AccessoryView.getAccessoryStackview()
        self.buttons = buttons
        super.init(frame: .zero)
        self.frame.size.height = AccessoryView.ACCESSORY_HEIGHT
        configureViews()
        configureConstriants()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViews() {
        backgroundView.addBlurBackground(effect: .systemUltraThinMaterialLight)
        addSubview(backgroundView)
        backgroundView.addSubview(stackView)
        buttons.forEach { button in
            stackView.addArrangedSubview(button)
        }
    }
    
    func configureConstriants() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 12),
            stackView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
        ])
    }
    
  
    static func getAccessoryStackview() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }
}



class AccessoryButton: UIButton {
    var isActive: Bool {
        didSet {
            if isActive {
                setImage(activeImage, for: .normal)
                tintColor = activeColor
            } else {
                setImage(inactiveImage, for: .normal)
                tintColor = inactiveColor
            }
        }
    }
    var activeImage: UIImage
    var activeColor: UIColor?
    var inactiveImage: UIImage
    var inactiveColor: UIColor?
    
    init(isActive: Bool, activeImage: UIImage, activeColor: UIColor?, inactiveImage: UIImage, inactiveColor: UIColor?) {
        self.isActive = isActive
        self.activeImage = activeImage
        self.activeColor = activeColor
        self.inactiveImage = inactiveImage
        self.inactiveColor = inactiveColor
        super.init(frame: .zero)
        self.imageView?.contentMode = .scaleAspectFit
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 24),
            self.widthAnchor.constraint(equalToConstant: 24)
           ])
        if isActive {
            self.tintColor = activeColor
            self.setImage(activeImage, for: .normal)
        } else {
            self.tintColor = inactiveColor
            self.setImage(inactiveImage, for: .normal)
        }
        print("syppppp\(self.imageView?.image?.size)")
        print("syppppp\(self.imageView?.frame.size)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func addBlurBackground(effect: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: effect)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

