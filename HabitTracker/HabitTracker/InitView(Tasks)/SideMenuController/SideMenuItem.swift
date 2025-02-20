
import UIKit

class SideMenuItem {
    let icon: UIImage?
    let name: String
    let viewController: SideMenuTappedActions
    
    init(icon: UIImage?, name: String, viewController: SideMenuTappedActions) {
        self.icon = icon
        self.name = name
        self.viewController = viewController
    }
}

class SideMenuHeaderItem {
    let icon: UIImage?
    let name: String
    let viewController: SideMenuTappedActions
    
    init(icon: UIImage?, name: String, viewController: SideMenuTappedActions) {
        self.icon = icon
        self.name = name
        self.viewController = viewController
    }
}

class SideMenuSection: AnyTreeNode {
    var hasHeader: Bool {
        headerItem != nil
    }
    
    var headerItem: SideMenuHeaderItem? = nil
    var dummyRootNode: (AnyTreeNode)? = nil
    let items: [SideMenuItem]
    var sumOfItemsDisplayed: Int {
        items.count + (hasHeader ? 1 : 0)
    }
    
    init(title: String, headerItem: SideMenuHeaderItem? = nil, rootNode: (AnyTreeNode)? = nil) {
        self.headerItem = headerItem
        self.items = []
        self.dummyRootNode = rootNode
        super.init()
    }
    
}
