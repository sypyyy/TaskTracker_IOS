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
        print("didappear\(self.view.superview?.isHidden)")
        self.view.transitionView(hidden: false)
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


