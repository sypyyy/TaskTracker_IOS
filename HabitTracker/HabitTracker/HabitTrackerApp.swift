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

/*
@main
struct HabitTrackerApp: App {

    var body: some Scene {
        WindowGroup {
            let overalViewModel = TaskMasterViewModel.shared
            //Text("djeshdfhke WTF????")
            
                RootView(viewModel : overalViewModel)
            
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
*/

class TouchWindow: UIWindow {
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        // Handle touch events here
        if let touches = event.allTouches {
            for touch in touches where touch.phase == .began {
                // Do something with the touch
                print("Touch detected at \(touch.location(in: self))")
            }
        }
    }
}

/*
@UIApplicationMain
// AppDelegate or SceneDelegate
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let overalViewModel = TaskMasterViewModel.shared
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Use TouchWindow
        window = TouchWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIHostingController(rootView: RootView(viewModel: self.overalViewModel))
        window?.makeKeyAndVisible()
        return true
    }
}
*/

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

