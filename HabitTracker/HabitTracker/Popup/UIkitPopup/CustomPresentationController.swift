//
//  CustomPresentationController.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/5/13.
//

import UIKit
import SwiftUI

class CustomPresentationController: UIPresentationController {
    private var dim: Bool
    private var dimmingView: UIView!
    private var frameOfPresentedView: CGRect
    private weak var delegateVC: UIkitPopupViewController?
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, frameOfPresentedView: CGRect, delegateVC: UIkitPopupViewController?, dim: Bool) {
        self.dim = dim
        self.delegateVC = delegateVC
        self.frameOfPresentedView = frameOfPresentedView
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
        
        
    }

    private func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.backgroundColor = UIColor.black.withAlphaComponent(dim ? 0.05 : 0)
        dimmingView.alpha = 0.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:)))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    @objc func dimmingViewTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: containerView)
        if !frameOfPresentedView.contains(location) {
        
        }
    }

    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        dimmingView.frame = containerView!.bounds
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        // Adjust frame to your needs
        return frameOfPresentedView
    }
}

class CustomPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3 // Duration of the animation
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let containerView = transitionContext.containerView
        toViewController.view.backgroundColor = .clear
        containerView.addSubview(toViewController.view)
        //toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        toViewController.view.frame.origin = CGPoint(x: 100, y: 300)
        toViewController.view.frame.size = transitionContext.finalFrame(for: toViewController).size
        print("container frame: \(containerView.frame)")
        //toViewController.view.translatesAutoresizingMaskIntoConstraints = false
        //toViewController.view.translatesAutoresizingMaskIntoConstraints = false
        // Start with the view off-screen or in a scaled down state
        toViewController.view.alpha = 0
        toViewController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

        // Animate to full size
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toViewController.view.alpha = 1
            toViewController.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

class CustomDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.alpha = 0
            fromViewController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }) { finished in
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(finished)
        }
    }
}

class CustomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let frameOfPresentedView: CGRect
    let dim: Bool
    weak var delegateVC: UIkitPopupViewController?
    
    init(frameOfPresentedView: CGRect, delegateVC: UIkitPopupViewController, dim: Bool) {
        self.frameOfPresentedView = frameOfPresentedView
        self.delegateVC = delegateVC
        self.dim = dim
        super.init()
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting, frameOfPresentedView: frameOfPresentedView, delegateVC: delegateVC, dim: dim)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return CustomPresentationAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return CustomDismissalAnimator()
    }
}


