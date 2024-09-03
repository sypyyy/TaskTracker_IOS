//
//  TodoFastCreatViewController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/3/28.
//

import UIKit
import SwiftUI

enum EditingViewType {
    case todo, subtodo(CheckListItemView), description
}

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

extension TodoFastCreatViewController: ChangeListener {
    
    var listenerId: String {
        get {
            self.listenerID
        }
    }
    
    func didUpdate(msg: ChangeMessage) {
        switch msg {
        case .taskGoalSet:
            if let todo = persistenceController.getTodoById(id: editingTodo.id) {
                editingTodo = TodoModel(todo: todo)
            }
        default:
            break
        }
    }
}

enum TodoCreationMode {
    case create, edit(todo: TodoModel)
}

@MainActor
final class TodoFastCreatViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    let mode: TodoCreationMode
    let persistenceController = PersistenceController.preview
    var listenerID = UUID().uuidString
    let TEXT_FIELD_BACKGROUND_COLOR = UIColor.lightGray.withAlphaComponent(0.15)
    let SECTION_CORNER_RADIUS: CGFloat = 12
    let FORM_HORIZONTAL_PADDING: CGFloat = 14
    let TODO_DESCRIPTION_MIN_HEIGHT: CGFloat = 200
    
    var scrollView: UIScrollView = {
        let res = UIScrollView()
        res.alwaysBounceVertical = true
        return res
    }()
    var navController: UIHostingController<TodoEditOrCreateNavBarView>? = nil
    var scrollContentView: UIView = UIView()
    
    var editingTodo: TodoModel
    
    var keyBoardHeight: CGFloat = 0
    
    init(mode: TodoCreationMode = .create) {
        self.mode = mode
        switch mode {
        case .create:
            self.editingTodo = TodoModel.getInitialTodoModel()
        case .edit(let todo):
            self.editingTodo = todo
        }
        super.init(nibName: nil, bundle: nil)
        MasterViewModel.shared.registerListener(listener: self)
    }
    
    deinit {
        DispatchQueue.main.async {
            MasterViewModel.shared.removeListener(targetId: self.listenerID)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //related to accesssoryView
    var accessoryView: AccessoryView? {
        didSet {
            //To prevent the accessory view from being dismissed when the accessoryView is tapped
            accessoryView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        }
    }
    var shouldHideAccessoryForGood: Bool = false
    var editingViewType: EditingViewType = .todo
    var editingCheckListItem: CheckListItemView?
    func setEditingSectionType(_ type: EditingViewType) {
        editingViewType = type
        switch editingViewType {
        case .todo:
            break
        case .subtodo(let checkListItemView):
            editingCheckListItem = checkListItemView
        case .description:
            break
        }
    }
    
    var todoDescriptView = UITextView()
    var todoNameView = {
        let res = InsetTextField()
        res.tintColor = .darkGray
        return res
    }()
    
    //Sub Todo
    var subTodoView: TodoCheckListView!
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
        subTodoView = TodoCheckListView(frame: .zero, style: .plain, delegate: self)
        configureViews()
        configureGestures()
    }
    
    private func configureViews() {
        addNavBar()
        addSubviews()
        configureConstraints()
        //setupTodoAccessoryView()
        configureAccessoryViews()
    }
    
    private func addNavBar() {
        let navController = UIHostingController(rootView: TodoEditOrCreateNavBarView())
        navController.view.backgroundColor = .clear
        self.navController = navController
        addChild(navController)
        view.addSubview(navController.view)
        
        navController.didMove(toParent: self)
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        todoNameView.backgroundColor = TEXT_FIELD_BACKGROUND_COLOR
        todoNameView.layer.cornerRadius = SECTION_CORNER_RADIUS
        todoNameView.placeholder = "To-Do"
        todoNameView.delegate = self
        scrollContentView.addSubview(todoNameView)
        subTodoWrapper.backgroundColor = .clear
        scrollContentView.addSubview(subTodoWrapper)
        subTodoView.backgroundColor = TEXT_FIELD_BACKGROUND_COLOR
        subTodoView.layer.cornerRadius = SECTION_CORNER_RADIUS
        todoDescriptView.backgroundColor = TEXT_FIELD_BACKGROUND_COLOR
        todoDescriptView.isEditable = true
        //todoDescriptView.isScrollEnabled = false
        todoDescriptView.layer.cornerRadius = SECTION_CORNER_RADIUS
        todoDescriptView.delegate = self
        todoDescriptView.contentInset = UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 2)
        scrollContentView.addSubview(todoDescriptView)
        
        
    }

    
    private func configureConstraints() {
        navController?.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        if let navController = navController {
            NSLayoutConstraint.activate([
                navController.view.topAnchor.constraint(equalTo: view.topAnchor),
                navController.view.heightAnchor.constraint(equalToConstant: TodoEditOrCreateNavBarView.HEIGHT),
                navController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FORM_HORIZONTAL_PADDING),
                navController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FORM_HORIZONTAL_PADDING),
                scrollView.topAnchor.constraint(equalTo: navController.view.bottomAnchor)
            ])
        }
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),  // for vertical scrolling
            // contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),  // for horizontal scrolling
        ])
        todoNameView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todoNameView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            todoNameView.heightAnchor.constraint(equalToConstant: 40),
            todoNameView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: FORM_HORIZONTAL_PADDING),
            todoNameView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -FORM_HORIZONTAL_PADDING),
        ])
        subTodoWrapper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTodoWrapper.topAnchor.constraint(equalTo: todoNameView.bottomAnchor, constant: 0),
            subTodoWrapper.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: FORM_HORIZONTAL_PADDING),
            subTodoWrapper.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -FORM_HORIZONTAL_PADDING),
        ])
        todoDescriptView.translatesAutoresizingMaskIntoConstraints = false
        todoDescriptionHeightConstraint = todoDescriptView.heightAnchor.constraint(equalToConstant: TODO_DESCRIPTION_MIN_HEIGHT)
        todoDescriptionHeightConstraint.isActive = true
        NSLayoutConstraint.activate([
            todoDescriptView.topAnchor.constraint(equalTo: subTodoWrapper.bottomAnchor, constant: 20),
            todoDescriptView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: FORM_HORIZONTAL_PADDING),
            todoDescriptView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -FORM_HORIZONTAL_PADDING),
            todoDescriptView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20),
        ])
        //scrollContentView.backgroundColor = .red
        
    }
    
   func insertSubTodoView() {
        self.subTodoView.alpha = 0
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else {return}
            subTodoView.alpha = 1
            subTodoWrapper.addSubview(subTodoView)
            subTodoView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == todoDescriptView {
            todoDescriptionHeightConstraint.constant = TODO_DESCRIPTION_MIN_HEIGHT
            todoDescriptView.isScrollEnabled = true
        }
        setEditingSectionType(.description)
    }
        
    func textViewDidChange(_ textView: UITextView) {
        
        if textView == todoDescriptView {
            let textHeight = todoDescriptView.sizeThatFits(.init(width: todoDescriptView.frame.width, height: .greatestFiniteMagnitude)).height + 5
            todoDescriptionHeightConstraint.constant = min(TODO_DESCRIPTION_MIN_HEIGHT, textHeight)
                // This method is called every time the text changes.
                print("Text view content changed: \(textView.text!)")
        }
         
        
        
        /*
        if textView == subTodoView {
            let textHeight = subTodoView.sizeThatFits(.init(width: subTodoView.frame.width, height: .greatestFiniteMagnitude)).height + 5
            subTodoHeightConstraint?.constant = max(SUB_TODO_MIN_HEIGHT, textHeight)
                // This method is called every time the text changes.
                print("Text view content changed: \(textView.text!)")
        }
        */
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == todoNameView {
            self.setEditingSectionType(.todo)
        }
    }
}

//User Action callbacks
extension TodoFastCreatViewController {
    @objc func toggleSubTodoView(_ sender: UIButton) {
        if !hasSubTodo {
            insertSubTodoView()
        } else {
            removeSubTodoView()
        }
        (sender as? AccessoryButton)?.isActive = hasSubTodo
    }
    
    @objc func presentPriorityPopup(_ sender: UIButton) {
        let sourceFrame = sender.convert(sender.bounds, to: sender.window)
        print("sourceFrame: \(sourceFrame)")
        SwiftUIGlobalPopupManager.shared.showPopup(view: AnyView(PriorityPopupView(editingTodo: editingTodo ?? TodoModel())), sourceFrame: sourceFrame, preferredSide: .up)
    }
    
    @objc func presentDateAndTimeSheet(_ sender: UIButton) {
        let sourceFrame = sender.convert(sender.bounds, to: sender.window)
        print("sourceFrame: \(sourceFrame)")
        let sheetViewController = UIHostingController(rootView: DateAndTimeSelectionView())
                
                // Present it w/o any adjustments so it uses the default sheet presentation.
        present(sheetViewController, animated: true, completion: nil)
    }
    
    @objc func presentGoalPickingSheet(_ sender: UIButton) {
        let sourceFrame = sender.convert(sender.bounds, to: sender.window)
        print("sourceFrame: \(sourceFrame)")
            print("the goal is currently \(editingTodo.goal?.name)")
            let sheetViewController = UIHostingController(rootView: TaskGoalPickingSheetView(preselectedGoal: editingTodo.goal, mode: .todo(todo: editingTodo)))
            
            // Present it w/o any adjustments so it uses the default sheet presentation.
            present(sheetViewController, animated: true, completion: nil)
        
    }
    
}

//MARK: Keyboard actions
extension TodoFastCreatViewController {
    func configureAccessoryViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            self.keyBoardHeight = keyboardHeight + AccessoryView.ACCESSORY_HEIGHT
            var accessoryViewWasShowing = accessoryView?.window != nil
            shouldHideAccessoryForGood = !accessoryViewWasShowing
            if accessoryViewWasShowing {
                accessoryView?.removeFromSuperview()
            }
            switch editingViewType {
            case .todo:
                accessoryView = getTodoAccessoryView()
            case .subtodo(_):
                accessoryView = getSubTodoAccessoryView()
            case .description:
                accessoryView = getTodoAccessoryView()
            }
            if let accessoryView = self.accessoryView, let window = view.window {
                view.addSubview(accessoryView)
                NSLayoutConstraint.activate([
                    accessoryView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                    accessoryView.widthAnchor.constraint(equalToConstant: window.bounds.width),
                    //Using width anchor because there is a bug with trailing anchor, when keyboard is gone, the trailing anchor will be 0
                    accessoryView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -keyboardHeight),
                ])
                //let accessoryViewBottomConstraint = accessoryView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: 0)
                //accessoryViewBottomConstraint.isActive = true
                print("viewFrame: \(self.view.frame)")
                if !accessoryViewWasShowing {
                    accessoryView.alpha = 0
                    self.view.layoutIfNeeded()
                    UIView.animate(withDuration: 0.3) {
                        accessoryView.alpha = 1
                       // accessoryViewBottomConstraint.constant = -keyboardHeight
                       // self.view.layoutIfNeeded()
                    }
                }
            }
            
        }
        //letResponderEscapeKeyboard()
    }
        
    @objc func keyboardWillHide(notification: NSNotification) {
       
        shouldHideAccessoryForGood = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if !self.shouldHideAccessoryForGood {
                return
            }
            else {
                
                UIView.animate(withDuration: 0) {
                    self.accessoryView?.alpha = 0
                } completion: { _ in
                    self.accessoryView?.removeFromSuperview()
                }
            }
        }
    }
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        if let accessoryView = accessoryView, accessoryView.window != nil {
            accessoryView.removeFromSuperview()
            view.addSubview(accessoryView)
            
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let window = view.window {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                self.keyBoardHeight = keyboardHeight + AccessoryView.ACCESSORY_HEIGHT
                UIView.animate(withDuration: 0.1) {
                    accessoryView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -keyboardHeight).isActive = true
                    self.view.layoutIfNeeded()
                }
                
            }
        }
    }
    
    private func letResponderEscapeKeyboard() {
        //self.view.findFirstResponder()
        UIView.animate(withDuration: 0.2) {
            //self.scrollView.contentInset.bottom = self.keyBoardHeight
            //self.view.layoutIfNeeded()
        }
        
    }
    
}

extension TodoFastCreatViewController {
    /*
    func setupTodoAccessoryView() {
        // Setup the custom input accessory view
        let todoAccessorySubView = UIView()
        todoAccessorySubView.translatesAutoresizingMaskIntoConstraints = false
        todoAccessorySubView.backgroundColor = .clear
        //todoNameView.inputAccessoryView = getTodoAccessoryView()
        //todoDescriptView.inputAccessoryView = getTodoAccessoryView()
    
    }
     */
    
    func getTodoAccessoryView() -> AccessoryView {
        let listButton = AccessoryButton(isActive: hasSubTodo, activeImage: UIImage(systemName: "checklist") ?? UIImage(), activeColor: .systemBlue, inactiveImage: UIImage(systemName: "checklist") ?? UIImage(), inactiveColor: nil)
        listButton.addTarget(self, action: #selector(toggleSubTodoView(_:)), for: .touchUpInside)
        let priorityButton = AccessoryButton(isActive: false, activeImage: UIImage(systemName: "flag") ?? UIImage(), activeColor: .systemBlue, inactiveImage: UIImage(systemName: "flag") ?? UIImage(), inactiveColor: nil)
        priorityButton.addTarget(self, action: #selector(presentPriorityPopup(_:)), for: .touchUpInside)
        let dateAndTimeButton = AccessoryButton(isActive: false, activeImage: UIImage(systemName: "calendar.badge.clock") ?? UIImage(), activeColor: .systemBlue, inactiveImage: UIImage(systemName: "calendar.badge.clock") ?? UIImage(), inactiveColor: nil)
        dateAndTimeButton.addTarget(self, action: #selector(presentDateAndTimeSheet(_:)), for: .touchUpInside)
        //return AccessoryView(buttons: [listButton, priorityButton, dateAndTimeButton])
        let goalButton = AccessoryButton(isActive: false, activeImage: UIImage(systemName: "scope") ?? UIImage(), activeColor: .systemBlue, inactiveImage: UIImage(systemName: "scope") ?? UIImage(), inactiveColor: nil)
        goalButton.addTarget(self, action: #selector(presentGoalPickingSheet(_:)), for: .touchUpInside)
        return AccessoryView(buttons: [listButton, priorityButton, dateAndTimeButton, goalButton])
    }
    
    func getSubTodoAccessoryView() -> AccessoryView {
        let subTaskButton = AccessoryButton(isActive: true, activeImage: UIImage(resource: .subtask) ?? UIImage(), activeColor: .systemBlue, inactiveImage: UIImage(resource: .subtask) ?? UIImage(), inactiveColor: nil)
        subTaskButton.addTarget(self, action: #selector(addSubTodoItemToCurrentEditingItem), for: .touchUpInside)
        return AccessoryView(buttons: [subTaskButton])
    }
    
    @objc func addSubTodoItemToCurrentEditingItem() {
        editingCheckListItem?.addItem()
    }
    
    /*
    func getChecklistAccessoryView() -> AccessoryView {
        let listButton = AccessoryButton(isActive: hasSubTodo, activeImage: UIImage(systemName: "checklist") ?? UIImage(), activeColor: .systemBlue, inactiveImage: UIImage(systemName: "checklist") ?? UIImage(), inactiveColor: nil)
        listButton.addTarget(self, action: #selector(toggleSubTodoView(_:)), for: .touchUpInside)
        let subTaskButton = AccessoryButton(isActive: true, activeImage: UIImage(resource: .subtask) ?? UIImage(), activeColor: .systemBlue, inactiveImage: UIImage(resource: .subtask) ?? UIImage(), inactiveColor: nil)
        subTaskButton.addTarget(self, action: #selector(toggleSubTodoView(_:)), for: .touchUpInside)
        return AccessoryView(buttons: [listButton, subTaskButton])
    }
     */
}


class AccessoryView: UIView {
    //accessory
    static let ACCESSORY_HEIGHT: CGFloat = 40
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
        self.autoresizingMask = [.flexibleHeight]
        self.translatesAutoresizingMaskIntoConstraints = false
        //self.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: AccessoryView.ACCESSORY_HEIGHT)
        ])
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

/*
class InputAccessoryView: UIView, UITextViewDelegate {
    let textView = UITextView()
    override init(frame: CGRect) {
        super.init(frame: frame)

        // This is required to make the view grow vertically
        self.autoresizingMask = UIView.AutoresizingMask.flexibleHeight

        // Setup textView as needed
        self.addSubview(self.textView)
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[textView]|", options: [], metrics: nil, views: ["textView": self.textView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[textView]|", options: [], metrics: nil, views: ["textView": self.textView]))

        self.textView.delegate = self

        // Disabling textView scrolling prevents some undesired effects,
        // like incorrect contentOffset when adding new line,
        // and makes the textView behave similar to Apple's Messages app
        self.textView.isScrollEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        // Calculate intrinsicContentSize that will fit all the text
        let textSize = self.textView.sizeThatFits(CGSize(width: self.textView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        return CGSize(width: self.bounds.width, height: textSize.height)
    }

    // MARK: UITextViewDelegate

    func textViewDidChange(_ textView: UITextView) {
        // Re-calculate intrinsicContentSize when text changes
        self.invalidateIntrinsicContentSize()
    }

}
*/


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

