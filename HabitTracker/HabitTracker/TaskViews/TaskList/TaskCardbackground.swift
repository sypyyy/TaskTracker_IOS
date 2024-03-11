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
        
        
        
        
        // Background View
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        backgroundView.fillSuperview()
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
        
        // Stroke View
        strokeView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(strokeView)
        strokeView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: -2, right: -2)) // Adjust padding as needed
        strokeView.layer.cornerRadius = 15
        strokeView.layer.borderWidth = 1
        strokeView.layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        strokeView.backgroundColor = .clear
        strokeView.clipsToBounds = true
        strokeView.layer.bounds = backgroundView.layer.bounds
        strokeView.layer.masksToBounds = true
    }
}

/*
class CustomBorderedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear // Make background clear to see the border
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Define the rounded rectangle path
        let roundedRectPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 15, height: 15))
        
        // Define the path for the border
        let borderPath = UIBezierPath()
        borderPath.move(to: CGPoint(x: 0, y: 0)) // Start from the top-left corner
        borderPath.addLine(to: CGPoint(x: bounds.width, y: 0)) // Top edge
        //borderPath.addLine(to: CGPoint(x: bounds.width, y: 10)) // Small vertical line to make corner appear rounded
        borderPath.move(to: CGPoint(x: 0, y: 0)) // Move back to top-left
        borderPath.addLine(to: CGPoint(x: 0, y: bounds.height)) // Left edge
        
        UIColor.clear.setFill() // Set fill color to clear
        roundedRectPath.fill() // Fill the rounded rectangle path
        
        UIColor.black.setStroke() // Set stroke color for the border
        borderPath.lineWidth = 2 // Set border width
        borderPath.stroke() // Draw the border
    }
}
*/

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



