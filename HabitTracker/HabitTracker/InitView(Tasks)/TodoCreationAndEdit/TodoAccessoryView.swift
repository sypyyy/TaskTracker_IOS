//
//  TodoAccessoryView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2025/2/5.
//

import UIKit

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
        if(hideSubTodoFunctionality) {
            return AccessoryView(buttons: [priorityButton, dateAndTimeButton, goalButton])
        }
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
