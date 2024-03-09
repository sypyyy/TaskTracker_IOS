//
//  LeftSideBarViewModel.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/29.
//

import Foundation


class LeftSideBarViewModel: ObservableObject {
    static var shared = LeftSideBarViewModel()
    @Published var isShowLeftSideBar = false
}
