

import UIKit
import SwiftUI

enum SideMenuRowInfo: Equatable {
    case defaultRow(SideMenuDefaultRowType)
  
    case CustomFilter(id: String)
    case Label(id: String)
}

class SideMenuViewController: UIViewController {
    static var shared: SideMenuViewController = SideMenuViewController()
    var activeRowInfo: SideMenuRowInfo = .defaultRow(.today)
    var activeRowId: String?
    
    let persistenceController = PersistenceController.preview
    //一个可以放头像之类的section，现在没用，是空的

    private var sideMenuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var sideMenuHostingController = UIHostingController(rootView: SideMenuView())

    private var screenWidth: CGFloat {
        view.frame.size.width
    }

    private var leadingConstraint: NSLayoutConstraint!
    private var shadowColor: UIColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.2)
    
    private var tableData: SideMenuTableViewDatas = SideMenuTableViewDatas()
    
    internal var nodeArray: [AnyTreeNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureView()
    }
    
    private func loadData() {
        dummyRootNode.removeAllChildren()
        nodeArray = []
        //Put default rows in (Today, inbox blablabla)
        defaultSideMenuRows.forEach {node in
            dummyRootNode.addChild(node)
        }
        
        for node in dummyRootNode.children {
            traverse(node: node)
        }
        func traverse(node: AnyTreeNode) {
            nodeArray.append(node)
            if(node.isExpanded) {
                node.children.forEach{ child in
                    traverse(node: child)
                }
            }
        }
    }
    
    private func configureView() {
        view.backgroundColor = .clear
        view.frame.origin.x = -screenWidth

        addSubviews()
        configureTapGesture()
    }

    private func addSubviews() {
        view.addSubview(sideMenuView)
        self.addChild(sideMenuHostingController)
        sideMenuView.addSubview(sideMenuHostingController.view)
        sideMenuHostingController.view.backgroundColor = .clear
        sideMenuHostingController.didMove(toParent: self)
        addMaterialBackgroundToSideMenu()
        configureConstraints()
    }
    
    private func addMaterialBackgroundToSideMenu() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = sideMenuView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideMenuView.insertSubview(blurEffectView, at: 0)
    }

    private func configureConstraints() {
        sideMenuView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingConstraint = sideMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -view.frame.size.width)
        leadingConstraint.isActive = true
        sideMenuView.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.8).isActive = true
        sideMenuView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        sideMenuHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sideMenuHostingController.view.topAnchor.constraint(equalTo: sideMenuView.topAnchor),
            sideMenuHostingController.view.leadingAnchor.constraint(equalTo: sideMenuView.leadingAnchor),
            sideMenuHostingController.view.trailingAnchor.constraint(equalTo: sideMenuView.trailingAnchor),
            sideMenuHostingController.view.bottomAnchor.constraint(equalTo: sideMenuView.bottomAnchor)
        ])
         
    }


    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.delegate = self
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func tapped() {
        hide()
    }

    func show() {
        self.view.frame.origin.x = 0
        UIView.animate(withDuration: 0.35) {
            self.view.backgroundColor = self.shadowColor
            self.leadingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }

    func hide() {
        
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = .clear
            self.leadingConstraint.constant = -self.screenWidth
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.view.frame.origin.x = -self.screenWidth
        }
    }
    
    func translateLeft(by: CGFloat) {
        if(leadingConstraint.constant - by > 0) {
            leadingConstraint.constant = 0
            return
        }
        leadingConstraint.constant -= by
    }
    
    func onSwipeEnded() {
        if(leadingConstraint.constant < -100) {
            self.hide()
        } else {
            show()
        }
        
    }
}

extension SideMenuViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view else { return false }
        if view === sideMenuView || view.isDescendant(of: sideMenuView) {
            return true
        }
        return true
    }
}


//这边开始是关于tableViewDelegate的
class SideMenuTableViewDatas {
    var dummyRoot: AnyTreeNode = AnyTreeNode()
    var indexPath2SideMenuRowInfoMapping: [IndexPath: SideMenuRowInfo] = [:]
}

extension SideMenuViewController: TreeBasedTableViewController {
    
    var dummyRootNode: AnyTreeNode {
        get {
            return tableData.dummyRoot
        }
        set {
            self.tableData.dummyRoot = newValue
        }
    }

}



