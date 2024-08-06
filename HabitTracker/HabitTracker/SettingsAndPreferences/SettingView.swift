//
//  SettingView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/7/24.
//

import SwiftUI
//import Combine

struct SettingView: View {
    @StateObject var settingViewModel = SettingsViewModel.shared
    @State var iCloudSync = false
    var body: some View {
        GeometryReader { m in
            NavigationStack{
                List{
                    Section{
                        NavigationLink("App Style"){
                            /*
                            AppThemeEdit(halfScreenHeight: m.size.height / 2, yOffset: m.size.height / 2)
                             */
                        }
                        NavigationLink("Widget Style"){
                            Text("")
                        }
                    } header: {
                        Text("Themes").textCase(.none)
                    }
                    
                    Section{
                        HStack {
                            Text("iCloud Syncing")
                            Toggle(isOn: $iCloudSync, label: {
                                
                            })
                            /*
                            .onReceive(Just(iCloudSync)) { _ in
                                if !settingViewModel.purchased {
                                    iCloudSync = false
                                }
                                
                                /*
                                DataController.shared.setupDataContainer(iCloud: settingViewModel.getICloudIsSyncing())
                                 */
                            }
                             */
                        }
                    } header: {
                        Text("iCloud").textCase(.none)
                    }
                    
                    Section{
                        HStack {
                            Text("Start of the week")
                            Spacer()
                            Menu {
                                ForEach(Weekday.allCases, id: \.self) {weekday in
                                    Button("\(weekday.localizedName)") {
                                        settingViewModel.setPreferredStartOfWeek(weekday: weekday)
                                    }
                                }
                            } label: {
                                Text("\(settingViewModel.startOfWeek.localizedName)")
                                
                            }

                            /*
                            .onReceive(Just(iCloudSync)) { _ in
                                if !settingViewModel.purchased {
                                    iCloudSync = false
                                }
                                
                                /*
                                DataController.shared.setupDataContainer(iCloud: settingViewModel.getICloudIsSyncing())
                                 */
                            }
                             */
                        }
                    } header: {
                        Text("Preference").textCase(.none)
                    }
                }.navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }.ignoresSafeArea()
        
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}

