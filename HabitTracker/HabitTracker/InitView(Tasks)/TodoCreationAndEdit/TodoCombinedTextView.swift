//
//  TodoCombinedTextView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2025/2/5.
//

import UIKit

class CombinedTodoTextView: UITextView {
    
    weak var viewController: TodoFastCreatViewController?
    
    private let titleAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 17, weight: .medium),
        .foregroundColor: UIColor.label.lighter(by: 24)
    ]
    
    private let descriptionAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 15, weight: .regular),
        .foregroundColor: UIColor.darkGray
    ]
    
    private var placeholderLabel: UILabel?
    
    private var todoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private var previousWidth: CGFloat = 0
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupView()
        self.addObserver(self, forKeyPath: "bounds", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "bounds" {
                DispatchQueue.main.async {
                    if(abs(self.bounds.width - self.previousWidth) > 0.1) {
                        self.previousWidth = self.bounds.width
                        self.updateHeight()
                    }
                    
                }
            }
        }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTodoStatus() {
        guard let todo = viewController?.editingTodo else {return}
        
        let text = todo.note.isEmpty ? todo.name : (todo.name + "\n" + todo.note)
        self.text = text
        styleTextAndUpdateHeight()
        self.setTodoBtnCompleted(todo.done)
    }
    
    // Call this to update the todo completion status
    func setTodoBtnCompleted(_ completed: Bool) {
        let imageName = completed ? "checkmark.circle.fill" : "circle"
        todoButton.setImage(UIImage(systemName: imageName), for: .normal)
        todoButton.tintColor = completed ? .gray : .gray
    }
    
    private func setupView() {
        // Configure text view
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.15)
        layer.cornerRadius = 12
        textContainerInset = UIEdgeInsets(top: 12, left: 36, bottom: 0, right: 12)
        
        // Set default font (will be overridden by attributed text)
        font = UIFont.systemFont(ofSize: 17)
        
        // Setup placeholder
        setupPlaceholder()
        
        setupTodoButton()
    }
    
    private func setupTodoButton() {
        // Add todo button
        addSubview(todoButton)
        todoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            todoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            todoButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            todoButton.widthAnchor.constraint(equalToConstant: 20),
            todoButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTodoButton))
        todoButton.addGestureRecognizer(tap)
    }
    
    @objc private func didTapTodoButton() {
        viewController?.editingTodo.done.toggle()
        setTodoBtnCompleted(viewController?.editingTodo.done ?? false)
        viewController?.todoStateChanged()
    }
    
    private func setupPlaceholder() {
        let placeholder = UILabel()
        placeholder.text = "What do you want to do?"
        placeholder.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        placeholder.textColor = .gray
        placeholder.numberOfLines = 1
        addSubview(placeholder)
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 44),
            placeholder.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            placeholder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
        self.placeholderLabel = placeholder
    }
    
    
    private func userDidModifyTodo() {
        let currentText = text ?? ""
        let lines = currentText.components(separatedBy: .newlines)
        
        // Extract first line (title)
        let title = lines.first ?? ""
        
        // Extract remaining text (description)
        let description: String
        if lines.count > 1 {
            // Join all lines after the first line
            description = lines[1...].joined(separator: "\n")
        } else {
            description = ""
        }
        viewController?.editingTodo.name = title
        viewController?.editingTodo.note = description
        
        viewController?.todoStateChanged()
        
    }
    
    
    private func styleTextAndUpdateHeight() {
        // Handle placeholder visibility'
        placeholderLabel?.isHidden = !text.isEmpty
        
        
        //selectedRange = currentSelectedRange
        let currentText = text ?? ""

        // Convert to NSString for safer range calculations with emojis
        let nsString = currentText as NSString

        // Find range of first line using NSString methods which handle emojis correctly
        let newlineRange = nsString.range(of: "\n")
        if newlineRange.location != NSNotFound {
            let firstLineRange = NSRange(location: 0, length: newlineRange.location)
            
            // Apply title attributes safely using attributed string methods
            textStorage.beginEditing()
            
            // First line styling
            textStorage.setAttributes(titleAttributes, range: firstLineRange)
            
            // Remaining text styling
            let remainingTextRange = NSRange(
                location: newlineRange.location + 1, // +1 to skip the newline
                length: nsString.length - (newlineRange.location + 1)
            )
            
            if remainingTextRange.location + remainingTextRange.length <= nsString.length {
                textStorage.setAttributes(descriptionAttributes, range: remainingTextRange)
            }
            textStorage.endEditing()
        } else {
            // No newline - style entire text as title
            textStorage.beginEditing()
            let fullRange = NSRange(location: 0, length: nsString.length)
            textStorage.setAttributes(titleAttributes, range: fullRange)
            textStorage.endEditing()
        }
        
        updateTypingAttrs()
        updateHeight()
        
        
    }
    
    private func updateHeight() {
        //Update the text view's height
        let size: CGSize = self.sizeThatFits(CGSizeMake(self.frame.size.width, CGFloat.greatestFiniteMagnitude));
        let insets: UIEdgeInsets = self.textContainerInset;
        
        viewController?.combinedViewHeightConstraint.constant = size.height + (12 - insets.bottom)
        
    }
    
}

extension CombinedTodoTextView: UITextViewDelegate {
    func updateTypingAttrs() {
        let currentText = text ?? ""
        let lines = currentText.components(separatedBy: .newlines)
        let firstLineLength = (lines.first?.count ?? 0) + 1 // +1 for newline
            
        
            // Set typing attributes based on whether we're in first line or not
        typingAttributes = selectedRange.location < firstLineLength ? titleAttributes : descriptionAttributes
        //Found out that after setting the typingattr, the height of the textview is still not changed after the size calculation and setting heightConstraint for autolayout. So calling layoutIfneeded to force a layout actually worked. however this is bad for performance.
        layoutIfNeeded()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        userDidModifyTodo()
        styleTextAndUpdateHeight()
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateTypingAttrs()
    }
}


extension TodoFastCreatViewController {
    func setupCombinedTodoView() {
        // Create and configure combined view
        let combinedView = CombinedTodoTextView()
        combinedView.viewController = self
        
        self.combinedTodoView = combinedView
        print("fjdrkjfjrkd combinedTodoView added!!!!")
        combinedView.delegate = combinedView
        combinedView.isEditable = true
        combinedView.isSelectable = true
        combinedView.isScrollEnabled = false
        scrollContentView.addSubview(combinedView)
        combinedViewHeightConstraint = combinedTodoView.heightAnchor.constraint(equalToConstant: 40)
        combinedViewHeightConstraint.isActive = true
        // Configure constraints
        combinedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            combinedView.topAnchor.constraint(equalTo: scrollContentView.topAnchor),
            combinedView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: FORM_HORIZONTAL_PADDING),
            combinedView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -FORM_HORIZONTAL_PADDING),
            //combinedView.heightAnchor.constraint(greaterThanOrEqualToConstant: TODO_DESCRIPTION_MIN_HEIGHT),
            combinedView.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: -20),
        ])
        
        switch mode {
        case .create:
            break
        case .edit(let _):
            combinedView.setupTodoStatus()
        }
    }
}
