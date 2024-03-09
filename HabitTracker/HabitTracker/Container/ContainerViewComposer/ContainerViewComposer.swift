//
//  ContainerViewComposer.swift
//  SideMenu
//
//  Created by Errol DMello on 29/09/21.
//

import UIKit

final class ContainerViewComposer {
    @MainActor static func makeContainer() -> ContainerViewController {
        let homeViewController = HomeViewController(rootView: RootView())
        let settingsViewController = SettingsViewController(rootView: RootView())
        let aboutViewController = AboutViewController()
        let myAccountViewController = MyAccountViewController()
        let sideMenuItems = [
            SideMenuItem(icon: UIImage(systemName: "house.fill"),
                         name: "All Habits",
                         viewController: .callback({
                             TaskMasterViewModel.shared.tappedTaskId = nil
                             TaskMasterViewModel.shared.objectWillChange.send()
                         })),
            /*
            SideMenuItem(icon: UIImage(systemName: "house.fill"),
                         name: "Home",
                         viewController: .embed(homeViewController)),
            SideMenuItem(icon: UIImage(systemName: "gear"),
                         name: "Settings",
                         viewController: .embed(settingsViewController)),
            SideMenuItem(icon: UIImage(systemName: "info.circle"),
                         name: "About",
                         viewController: .push(aboutViewController)),
            SideMenuItem(icon: UIImage(systemName: "person"),
                         name: "My Account",
                         viewController: .modal(myAccountViewController))
             */
        ]
        let sideMenuViewController = SideMenuViewController(sideMenuItems: sideMenuItems)
        let container = ContainerViewController(sideMenuViewController: sideMenuViewController,
                                                rootViewController: rootViewController)

        return container
    }
}
