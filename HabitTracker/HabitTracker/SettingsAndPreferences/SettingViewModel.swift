//
//  SettingViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/7/24.
//

import Foundation

enum BackGroundMode: Int, Codable {
    case color = 0, gradient = 1, photo = 2
}

let appVerison = "1.0.0"
extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: "group.sypyyy.github.io.WidgetFacts") ?? UserDefaults.standard
}

/*
struct LocalSettingsData: Decodable, Encodable {
    var appBgStyle: AppBackgroundStyleData
    //var appFontStyle: AppBackgroundStyleData
}

struct AppBackgroundStyleData: Decodable, Encodable {
    var color: Color
    var gradientStart: Color
    var gradientEnd: Color
    var photoName: String
    var mode: BackGroundMode
}
*/

@MainActor
class SettingsViewModel: ObservableObject {
    static var shared = SettingsViewModel()
    
    let masterViewModel = MasterViewModel.shared
    //var localSettingData: LocalSettingsData?
    @Published var startOfWeek: Weekday = .sunday
    var purchased = true
    init() {
        migrateFromOlderVersions()
        initBasics()
    }
}

extension SettingsViewModel {
    func setPreferredStartOfWeek(weekday: Weekday) {
        let container = UserDefaults.appGroup
        container.set(weekday.rawValue, forKey: "startOfWeek")
        self.startOfWeek = weekday
        masterViewModel.didReceiveChangeMessage(msg: .startOfWeekChanged)
    }
}

extension SettingsViewModel {
    private func initBasics() {
        initSettingKeys()
    }
    
    private func initSettingKeys() {
        let container = UserDefaults.appGroup
    }
}

/*
//iCloud Sync Toggle
extension SettingsViewModel {
    func getICloudIsSyncing() -> Bool {
        let container = UserDefaults.appGroup
        let sync = container.bool(forKey: KeyForAppICloudSync)
        return sync
    }
    
    func setIcloudIsSyncing(isSync: Bool) {
        if isSync {
            if !purchased {
                return
            }
        }
        let container = UserDefaults.appGroup
        container.set(isSync, forKey: KeyForAppICloudSync)
    }
}
*/
extension SettingsViewModel {
    func getAvailableFonts() -> [String] {
        return ["Default","Raleway"]
    }
}


extension SettingsViewModel {
    func migrateFromOlderVersions() {
        
    }
}

