//
//  CustomViewControllers.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/16.
//

import Foundation
import UIKit
import SwiftUI

class CustomHostingViewController<Content: View>: UIHostingController<Content> {
    override func viewWillAppear(_ animated: Bool) {
        print("willappear\(self.view.superview?.isHidden)")
        //self.view.isHidden = true
        //self.view.transitionView(hidden: false)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.view.isHidden = true
        self.view.transitionView(hidden: false)
        print("didappear\(self.view.superview?.isHidden)")
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("willdisappear\(self.view.superview?.isHidden)")
        //self.view.isHidden = false
        //self.view.transitionView(hidden: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("diddisappear\(self.view.superview?.isHidden)")
        //self.view.isHidden = false
        //self.view.transitionView(hidden: true)
    }
    
    
   
}

class CustomNavigationViewController: UINavigationController {
    override func viewWillAppear(_ animated: Bool) {
        print("willappear\(self.view.isHidden)")
        //self.view.isHidden = true
        //self.view.transitionView(hidden: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        //self.view.isHidden = true
        
        print("didappear\(self.view.isHidden)")
        self.view.transitionView(hidden: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        //self.view.isHidden = false
        //self.view.transitionView(hidden: true)
    }
}

class iOS18_TabViewController: UIViewController {
    private var hostingControllers: [UIHostingController<AnyView>] = []
    private var containerView: UIView!
    private var currentIndex: Int = 0

    init(views: [AnyView]) {
        super.init(nibName: nil, bundle: nil)
        setupHostingControllers(with: views)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupContainerView()
        displayTab(at: currentIndex)
    }

    private func setupContainerView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
    }

    private func setupHostingControllers(with views: [AnyView]) {
        hostingControllers = views.map { UIHostingController(rootView: $0) }
        hostingControllers.forEach{ vc in
            vc.view.backgroundColor = .clear
        }
    }

    func setTabIndex(_ index: Int) {
        guard index >= 0, index < hostingControllers.count else { return }
        displayTab(at: index)
    }

    private func displayTab(at index: Int) {
        // Remove current view controller
        if currentIndex < hostingControllers.count {
            let currentVC = hostingControllers[currentIndex]
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }

        // Add new view controller
        let newVC = hostingControllers[index]
        addChild(newVC)
        newVC.view.frame = containerView.bounds
        containerView.addSubview(newVC.view)
        newVC.didMove(toParent: self)
        currentIndex = index
    }
}




