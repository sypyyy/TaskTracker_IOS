//
//  CustomSegmentedControl.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/23.
//

import UIKit

class TaskViewSegmentedControl: UIView {
    private var buttons = [UIButton]()
    
    private var selectedIndex: Int = 0 {
        didSet {
            updateButtonStyles()
        }
    }
    
    var selectionCallback: ((Int) -> Void)
    private let options: [String]
    init(options: [String], callback: @escaping (Int) -> Void) {
        self.options = options
        self.selectionCallback = callback
        
        super.init(frame: .zero)
        setupStyle()
        setupButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        layer.cornerRadius = 8
        self.clipsToBounds = true
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
    
    private func setupButtons() {
        for (index, option) in options.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.tag = index
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let buttonHeight = bounds.height
        let buttonWidth = bounds.width / CGFloat(buttons.count)
        for (index, button) in buttons.enumerated() {
            button.frame = CGRect(x: CGFloat(index) * buttonWidth, y: 0, width: buttonWidth, height: buttonHeight)
        }
        updateButtonStyles()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        selectedIndex = sender.tag
        selectionCallback(selectedIndex)
        
        UIView.animate(withDuration: 0.4, animations: {
            self.updateButtonStyles()
        })
    }
    
    private func updateButtonStyles() {
        for (index, button) in buttons.enumerated() {
            let isSelected = index == selectedIndex
            button.backgroundColor = isSelected ? .systemPink : UIColor.clear
            button.setTitleColor(isSelected ? .darkGray : .gray, for: .normal)
        }
    }
}
