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

enum SnapPoint: Double {
    case AlmostFull = 0.93
    case top = 0.8
    case middle = 0.5
    case low = 0.3
}


/*
 目前这个类只支持单个snappoint，有强需要再植入多个的逻辑吧
 */


class BottomSheetHandleView: UIView {
   // static let paddingVertical: CGFloat = 6
    static let width: CGFloat = 40
    static let height: CGFloat = 6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        // Set the background color to gray
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Apply rounded corners
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
}

final class BottomSheetViewController: UIViewController {
    
    static let shared = BottomSheetViewController()
    static let defaultSnapPoint = SnapPoint.top
    
    static let defaultDragOffset: CGFloat = 180
    
    private var isMovingSheetThroughScrollviewDrag = false
    private var isScrollViewDragging = false
    private var snapPoints = [SnapPoint]()
    private var currentSnapPoint: SnapPoint = BottomSheetViewController.defaultSnapPoint
    private var bottomConstraint: NSLayoutConstraint!
    private var heightConstraint: NSLayoutConstraint!
    private var shadowColor: UIColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.05)
    private var sheetView = UIView()
    //private var handleView = BottomSheetHandleView()
    private var backgroundViews = [UIView]()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let scrollView = findScrollView(in: self.view) {
            scrollView.delegate = self
        }
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

    private func configureView() {
        view.backgroundColor = .clear
        view.frame.origin.y = screenHeight
        addSubviews()
        configureConstraints()
        configureTapGesture()
    }

    private func addSubviews() {
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        //handleView.translatesAutoresizingMaskIntoConstraints = false
        sheetView.backgroundColor = .clear
        view.addSubview(sheetView)
        //view.addSubview(handleView)
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
        /*
        NSLayoutConstraint.activate([
            handleView.bottomAnchor.constraint(equalTo: sheetView.topAnchor, constant: BottomSheetHandleView.paddingVertical),
            handleView.heightAnchor.constraint(equalToConstant: BottomSheetHandleView.height),
            handleView.widthAnchor.constraint(equalToConstant: BottomSheetHandleView.width),
            handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
         */
    }

    private func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        view.addGestureRecognizer(tap)
        tap.delegate = self
    }

    @objc private func tapped() {
        hide()
    }
        
    func show(snapPoints: [SnapPoint], background: BSBackground = .blur(style: .systemUltraThinMaterialLight), viewType: BSPresentView) {
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
            backgroundViews.append(blurView)
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
        
        self.snapPoints = snapPoints.sorted(by: { $0.rawValue < $1.rawValue })
        if let currentSnapPoint = snapPoints.first {
            self.currentSnapPoint = currentSnapPoint
        }
        let maxSnapPoint = snapPoints.last ?? BottomSheetViewController.defaultSnapPoint
        let sheetHeight = (maxSnapPoint.rawValue) * self.screenHeight
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = self.shadowColor
            self.bottomConstraint.constant = (maxSnapPoint.rawValue - self.currentSnapPoint.rawValue) * self.screenHeight
            self.heightConstraint.constant = sheetHeight
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
            self.backgroundViews.forEach {
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
        print("Swipe ended")
        let bottomConstraint = self.bottomConstraint.constant
        if bottomConstraint >= BottomSheetViewController.defaultDragOffset {
            hide()
        } else {
            UIView.animate(withDuration: 0.3) {
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            } completion: { success in
                
            }
        }
    }
}

extension BottomSheetViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrollViewDragging = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        //finger moving down
        if((y < 0) && isScrollViewDragging) {
            print("the contentOffset is\(y)")
            isMovingSheetThroughScrollviewDrag = true
        }

        if isMovingSheetThroughScrollviewDrag && isScrollViewDragging {
            scrollView.contentOffset.y = 0
            let newBottomConstriant = self.bottomConstraint.constant - y
            if(newBottomConstriant < 0) {
                self.bottomConstraint.constant = 0
                isMovingSheetThroughScrollviewDrag = false
            } else {
                self.bottomConstraint.constant -= y
            }
        }
    }
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isScrollViewDragging = false
        if(isMovingSheetThroughScrollviewDrag) {
            let currentOffset = scrollView.contentOffset
            scrollView.setContentOffset(currentOffset, animated: false)
        }
        isMovingSheetThroughScrollviewDrag = false
        self.onSwipeEnded()
    }
    
     /*
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //self.onSwipeEnded()
    }
      */
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
