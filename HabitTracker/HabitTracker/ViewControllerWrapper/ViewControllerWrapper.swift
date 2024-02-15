//
//  ViewControllerWrapper.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/9.
//

import Foundation
import UIKit
import SwiftUI


struct TabView_Wrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        //let swiftUIView = InitView()
        //let hostingController = UIHostingController(rootView: swiftUIView)
        //hostingController.view.backgroundColor = .clear
        //hostingController.view.isHidden = true
        tabView_hostingController.view.backgroundColor = .clear
        tabView_hostingController.view.isHidden = false
        return tabView_hostingController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //uiViewController.view.isHidden = HabitTrackerViewModel.shared.tabIndex != .initial
        //tabView_hostingController.present(initView_hostingController, animated: true)
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        tabView_hostingController.view.isHidden = true
    }
    
    typealias UIViewControllerType = UIViewController
}



struct InitView_Wrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        //let swiftUIView = InitView()
        //let hostingController = UIHostingController(rootView: swiftUIView)
        //hostingController.view.backgroundColor = .clear
        //hostingController.view.isHidden = true
        taskView_hostingController.view.backgroundColor = .clear
        taskView_hostingController.view.isHidden = false
        return taskView_hostingController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //uiViewController.view.isHidden = HabitTrackerViewModel.shared.tabIndex != .initial
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        uiViewController.view.isHidden = true
    }
    
    typealias UIViewControllerType = UIViewController
}

struct StatisticalView_Wrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        //let swiftUIView = InitView()
        //let hostingController = UIHostingController(rootView: swiftUIView)
        //hostingController.view.backgroundColor = .clear
        //hostingController.view.isHidden = true
        statisticalView_hostingNavigationController.view.backgroundColor = .clear
        statisticalView_hostingController.view.backgroundColor = .clear
        statisticalView_hostingNavigationController.view.isHidden = true
        return statisticalView_hostingNavigationController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //uiViewController.view.isHidden = HabitTrackerViewModel.shared.tabIndex != .initial
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        statisticalView_hostingController.view.isHidden = true
    }
    
    typealias UIViewControllerType = UIViewController
}

