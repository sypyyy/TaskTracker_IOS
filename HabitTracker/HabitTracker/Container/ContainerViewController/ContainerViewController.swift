//
//  ContainerViewController.swift
//  SideMenu
//
//  Created by Errol DMello on 29/09/21.
//

import UIKit

final class ContainerViewController: UIViewController {
    private var sideMenuViewController: SideMenuViewController!
    private var navigator: UINavigationController!
    private var rootViewController: ContentViewController! {
        didSet {
            rootViewController.delegate = self
            navigator.setViewControllers([rootViewController], animated: false)
        }
    }

    convenience init(sideMenuViewController: SideMenuViewController, rootViewController: ContentViewController) {
        self.init()
        self.sideMenuViewController = sideMenuViewController
        self.rootViewController = rootViewController
        self.navigator = UINavigationController(rootViewController: rootViewController)
        navigator.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        addChildViewControllers()
        configureDelegates()
        configureGestures()
    }

    private func configureDelegates() {
        sideMenuViewController.delegate = self
        rootViewController.delegate = self
    }

    private func configureGestures() {
        let swipeLeftGesture = UIPanGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeftGesture.cancelsTouchesInView = false
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        sideMenuViewController.view.addGestureRecognizer(panGesture)

        let rightSwipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(swipedRight))
        rightSwipeGesture.cancelsTouchesInView = false
        rightSwipeGesture.edges = .left
        view.addGestureRecognizer(rightSwipeGesture)
    }

    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
           switch gesture.state {
           case .changed:
               self.sideMenuViewController.translateLeft(by: -translation.x)
               gesture.setTranslation(.zero, in: self.sideMenuViewController.view)
           case .ended:
                self.sideMenuViewController.onSwipeEnded()
           default:
               break
           }
       }
    @objc private func swipedLeft() {
        sideMenuViewController.hide()
    }

    @objc private func swipedRight() {
        sideMenuViewController.show()
    }

    func updateRootViewController(_ viewController: ContentViewController) {
        rootViewController = viewController
    }

    private func addChildViewControllers() {
        addChild(navigator)
        view.addSubview(navigator.view)
        navigator.didMove(toParent: self)

        addChild(sideMenuViewController)
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController.didMove(toParent: self)
    }
}

extension ContainerViewController: SideMenuDelegate {
    func menuButtonTapped() {
        sideMenuViewController.show()
    }

    func itemSelected(item: ContentViewControllerPresentation) {
        switch item {
        case let .embed(viewController):
            updateRootViewController(viewController)
            sideMenuViewController.hide()
        case let .push(viewController):
            sideMenuViewController.hide()
            navigator.pushViewController(viewController, animated: true)
        case let .modal(viewController):
            sideMenuViewController.hide()
            navigator.present(viewController, animated: true, completion: nil)
        case let .callback(callback):
            callback()
        }
    }
}
