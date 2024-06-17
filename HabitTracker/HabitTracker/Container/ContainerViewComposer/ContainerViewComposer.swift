//
//  ContainerViewComposer.swift
//  SideMenu
//
//  Created by Errol DMello on 29/09/21.
//

import UIKit

final class ContainerViewComposer {
    @MainActor static var sharedContainerVC = makeContainer()
    @MainActor static private func makeContainer() -> ContainerViewController {
        let sideMenuViewController = SideMenuViewController.shared
        let bottomSheetViewController = BottomSheetViewController.shared
        let popupViewController = UIkitPopupViewController.shared
        let container = ContainerViewController(sideMenuViewController: sideMenuViewController, bottomSheetViewController: bottomSheetViewController, popupViewController: popupViewController,
                                                rootViewController: rootViewController)

        return container
    }
}
