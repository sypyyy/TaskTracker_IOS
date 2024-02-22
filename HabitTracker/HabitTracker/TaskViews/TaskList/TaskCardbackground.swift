//
//  TaskCardbackground.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/21.
//

import UIKit

class CustomCardBackgroundView: UIView {
    private let backgroundView = UIView()
    private let strokeView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        
        
        // Stroke View
        strokeView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(strokeView)
        strokeView.fillSuperview(padding: UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 0)) // Adjust padding as needed
        strokeView.layer.cornerRadius = 15
        strokeView.layer.borderWidth = 2
        strokeView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        strokeView.backgroundColor = .clear
        strokeView.clipsToBounds = true
        strokeView.layer.masksToBounds = true
        
        // Background View
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        backgroundView.fillSuperview() // Assuming a helper extension is used
        backgroundView.layer.cornerRadius = 15
        backgroundView.clipsToBounds = true
        if #available(iOS 13.0, *) {
            backgroundView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = backgroundView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backgroundView.insertSubview(blurEffectView, at: 0)
        }
    }
}

extension UIView {
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: padding.top),
            leftAnchor.constraint(equalTo: superview.leftAnchor, constant: padding.left),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding.bottom),
            rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -padding.right)
        ])
    }
}
