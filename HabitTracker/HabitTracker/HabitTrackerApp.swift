//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/4/20.
//

import SwiftUI

private struct MainWindowSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var mainWindowSize: CGSize {
        get { self[MainWindowSizeKey.self] }
        set { self[MainWindowSizeKey.self] = newValue }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            let configuration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            if connectingSceneSession.role == .windowApplication {
                configuration.delegateClass = SceneDelegate.self
            }
            return configuration
        }

    // MARK: UISceneSession Lifecycle
/*
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
*/
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

class TouchWindow: UIWindow {
    var isTouchBeganInsidePopup = false
    var waitListedEvents = [UIEvent]()
    
    override func sendEvent(_ event: UIEvent) {
        // Handle touch events here
        let popupMgr = GlobalPopupManager.shared
        if let touches = event.allTouches {
            for touch in touches where touch.phase == .began {
                // Do something with the touch
                print("Touch detected at \(touch.location(in: self))")
                if popupMgr.showPopup {
                    guard let popupPos = popupMgr.popupPosition, let popupSize = popupMgr.popupSize else {continue}
                    let popupOrigin = CGPoint(x: (popupPos.x - popupSize.width / 2), y: (popupPos.y - popupSize.height / 2))
                    let popupFrame = CGRect(origin: popupOrigin, size: popupSize)
                    let touchLocation = touch.location(in: self)
                    isTouchBeganInsidePopup = popupFrame.contains(touchLocation)
                    print("began inside pop \(isTouchBeganInsidePopup)")
                }
            }
            
            for touch in touches where touch.phase == .moved || touch.phase == .ended || touch.phase == .cancelled {
                // Do something with the touch
                print("Touch detected at \(touch.location(in: self))")
                if popupMgr.showPopup {
                    guard let popupPos = popupMgr.popupPosition, let popupSize = popupMgr.popupSize else {continue}
                    let popupOrigin = CGPoint(x: (popupPos.x - popupSize.width / 2), y: (popupPos.y - popupSize.height / 2))
                    let popupFrame = CGRect(origin: popupOrigin, size: popupSize)
                    let touchLocation = touch.location(in: self)
                    print("popFrame \(popupFrame)")
                    if !popupFrame.contains(touchLocation) && !isTouchBeganInsidePopup {
                        popupMgr.hidePopup(reason: "moved OutSide Popup")
                    }
                }
                
            }
            
        }
        super.sendEvent(event)
    }
}
