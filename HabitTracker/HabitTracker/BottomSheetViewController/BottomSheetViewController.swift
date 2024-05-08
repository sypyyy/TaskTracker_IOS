//
//  BottomSheetViewController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/3/26.
//

import UIKit
import SwiftUI

enum BSBackground {
    case blur(style: UIBlurEffect.Style)
    case color(color: UIColor)
}

enum BSPresentView {
    case swiftUI(view: AnyView)
    case viewController(UIViewController)
    case UIView(UIView)
}

final class BottomSheetViewController: UIViewController {
    
    private var bottomConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    private var shadowColor: UIColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.05)
    private var sheetView = UIView()
    private var tempViews = [UIView]()
    private var blurSheetBackgroundView: UIView?
    
    var screenHeight: CGFloat {
        view.frame.height
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
       //MARK: So far no use case to escape keyboard
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            UIView.animate(withDuration: 0.3) {
                // Adjust the bottom constraint of the view. Add any additional offset if needed.
                self.bottomConstraint.constant = -keyboardHeight
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //sheetView.roundTopCorners(cornerRadius: 12)
        //blurSheetBackgroundView?.roundTopCorners(cornerRadius: 12)
    }

    private func configureView() {
        view.backgroundColor = .clear
        view.frame.origin.y = screenHeight
        addSubviews()
        configureConstraints()
        configureTapGesture()
    }

    private func addSubviews() {
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.backgroundColor = .clear
        view.addSubview(sheetView)
    }
    
    private func addMaterialBackgroundToSheet() {
       
    }

    private func configureConstraints() {
        bottomConstraint = sheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: screenHeight)
        bottomConstraint.isActive = true
        heightConstraint = sheetView.heightAnchor.constraint(equalToConstant: screenHeight)
        heightConstraint.isActive = true
        NSLayoutConstraint.activate([
            sheetView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tap)
        tap.delegate = self
    }

    @objc private func tapped() {
        hide()
    }
        
    func show(snapPoints: [CGFloat], background: BSBackground = .blur(style: .systemUltraThinMaterialLight), viewType: BSPresentView) {
        self.view.frame.origin.y = 0
        switch viewType {
        case .swiftUI(let view):
            let hostingController = BottomSheetContentHostingController(rootView: view)
            hostingController.bottomSheetViewController = self
            //hostingController.sizingOptions = .intrinsicContentSize
            hostingController.view.backgroundColor = .clear
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            addChild(hostingController)
            sheetView.addSubview(hostingController.view)
            hostingController.didMove(toParent: self)
            
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: sheetView.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: sheetView.bottomAnchor)
            ])
             
        case .viewController(let vc):
            addChild(vc)
            sheetView.addSubview(vc.view)
            vc.didMove(toParent: self)
            
        case .UIView(let v):
            sheetView.addSubview(v)
        }
        
        switch background {
        case .blur(let style):
            let blurEffect = UIBlurEffect(style: style)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            blurView.layer.cornerRadius = 12
            blurView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            blurView.clipsToBounds = true
            view.insertSubview(blurView, at: 0)
            tempViews.append(blurView)
            blurSheetBackgroundView = blurView
            NSLayoutConstraint.activate([
                blurView.topAnchor.constraint(equalTo: sheetView.topAnchor),
                //I did this because there is a bug that UIHostingViewController does not follow NSLayoutConstraints(bottom), leading to sheetView's bottom changed, so I put up this ugly fix for now. which is, tie the blur view bottom to root view's bottom. And a extra 10 to avoid conflict when sheet is disappearing.
                blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: screenHeight),
                blurView.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor),
                    ])
        case .color(let color):
            sheetView.backgroundColor = color
        }
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = self.shadowColor
            self.bottomConstraint.constant = 0
            self.heightConstraint.constant = (snapPoints.first ?? 0.5) * self.screenHeight
            self.view.layoutIfNeeded()
        }
    }
    

    func hide() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = .clear
            self.bottomConstraint.constant = self.sheetView.frame.height
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.sheetView.subviews.forEach{
                $0.removeFromSuperview()
            }
            self.children.forEach { $0.removeFromParent() }
            self.tempViews.forEach {
                $0.removeFromSuperview()
            }
            self.view.frame.origin.y = self.screenHeight
            self.bottomConstraint.constant = self.screenHeight
        }
    }
    
    /*
    func executeWithAnimation(task: @escaping () -> Void) {
        print("Did change height \(bottomConstraint.constant)")
        task()
        UIView.animate(withDuration: 0.3) {
            self.hostingController?.view.setNeedsLayout()
            self.hostingController?.view.layoutIfNeeded()
            self.hostingController?.view.invalidateIntrinsicContentSize()
            self.view.layoutIfNeeded()
        }
    }
   */
    
    func onSwipeEnded() {
       
        
    }
}

extension BottomSheetViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false }
        if view.isDescendant(of: sheetView) {
            return false
        }
        if view == sheetView {
            return false
        }
        return true
    }
}


extension UIView {
    func roundTopCorners(cornerRadius: CGFloat) {
        // Create a CAShapeLayer
        let maskLayer = CAShapeLayer()
        
        // Define the path using UIBezierPath
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        
        // Apply the mask to the layer
        layer.mask = maskLayer
    }
}

class BottomSheetContentHostingController<Content>: UIHostingController<Content> where Content: View {
    weak var bottomSheetViewController: BottomSheetViewController?
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
