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
 final class TodoFastCreatViewController: UIViewController {
     var layoutCount = 0
     var hideSubTodoFunctionality = true
     let mode: TodoCreationMode
     let persistenceController = PersistenceController.preview
     let masterViewModel = MasterViewModel.shared
     var listenerID = UUID().uuidString
     let TEXT_FIELD_BACKGROUND_COLOR = UIColor.lightGray.withAlphaComponent(0.15)
     let SECTION_CORNER_RADIUS: CGFloat = 12
     let FORM_HORIZONTAL_PADDING: CGFloat = 14
     
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
     
     var combinedTodoView: CombinedTodoTextView!
     var combinedViewHeightConstraint: NSLayoutConstraint!
    
     
     //Sub Todo
     var subTodoView: TodoCheckListView!
     var subTodoWrapper = UIView()
    
     
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
     
     override func viewDidLayoutSubviews() {
         layoutCount += 1
         print("fastTodoController Layout pass #\(layoutCount)")
         super.viewDidLayoutSubviews()
         guard let combinedTodoView = self.combinedTodoView else {return}
        
         //combinedTodoView.updateHeight()
         
         
     }
     
     
     
     private func configureViews() {
         addNavBar()
         addScrollview()
         setupCombinedTodoView()
         
         
         configureConstraints()
         //setupTodoAccessoryView()
         configureAccessoryViews()
     }
     
     private func addNavBar() {
         let navController = UIHostingController(rootView: TodoEditOrCreateNavBarView(todoCreatController: self))
         navController.view.backgroundColor = .clear
         self.navController = navController
         addChild(navController)
         view.addSubview(navController.view)
         
         navController.didMove(toParent: self)
     }
     
     private func addScrollview() {
         view.addSubview(scrollView)
         scrollView.addSubview(scrollContentView)
         
         subTodoWrapper.backgroundColor = .clear
         scrollContentView.addSubview(subTodoWrapper)
         subTodoView.backgroundColor = TEXT_FIELD_BACKGROUND_COLOR
         subTodoView.layer.cornerRadius = SECTION_CORNER_RADIUS
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
         
         subTodoWrapper.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
            subTodoWrapper.topAnchor.constraint(equalTo: combinedTodoView.bottomAnchor, constant: 0),
             subTodoWrapper.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: FORM_HORIZONTAL_PADDING),
             subTodoWrapper.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -FORM_HORIZONTAL_PADDING),
         ])
         /*
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
         */
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
     
     /*
     func textViewDidBeginEditing(_ textView: UITextView) {
         if textView == combinedTodoView {
             //combinedViewHeightConstraint.constant = TODO_DESCRIPTION_MIN_HEIGHT
             //todoDescriptView.isScrollEnabled = true
             setEditingSectionType(.description)
         }
         
     }
        */
     /*
     func textViewDidChange(_ textView: UITextView) {
         
         if textView == combinedTodoView {
             
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
      */
     
     /*
     func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField == combinedTodoView {
             self.setEditingSectionType(.todo)
         }
     }
      */
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
    func todoStateChanged() {
        switch mode {
        case .create:
            // Because we only save when user tap on save button in todo creation mode
            return
        case .edit( _):
            break
        }
        persistenceController.modifyTodo(dataModel: self.editingTodo)
        masterViewModel.didReceiveChangeMessage(msg: .taskStateChanged)
    }
    @objc func saveNewTodo() {
        switch self.mode {
        case .create:
            persistenceController.createTodo(dataModel: self.editingTodo)
            masterViewModel.didReceiveChangeMessage(msg: .taskCreated)
        case .edit(_):
            break
        }
        
    }
}

