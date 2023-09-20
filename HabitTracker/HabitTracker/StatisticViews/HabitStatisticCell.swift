//
//  HabitCalendarCell.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/7/9.
//

import SwiftUI

struct HabitStatisticCell: View {
    @State var tabIndex = 0
    @State var zoomBg = true
    var habit: habitViewModel = HabitTrackerViewModel.shared.getOngoingHabitViewModels().first!
    let spacing = 4.0
    let size = 15.0
    @StateObject var viewModel: HabitTrackerStatisticViewModel = HabitTrackerStatisticViewModel.shared
    @StateObject var masterModel: HabitTrackerViewModel = HabitTrackerViewModel.shared
    private var rows: [GridItem] {
        switch viewModel.statisticalChartType {
        case .weekly:
            return [GridItem(.adaptive(minimum: size), spacing: spacing)]
        case .monthly:
            return [GridItem(.adaptive(minimum: size), spacing: spacing)]
        case .annually:
            return [GridItem(.fixed(size), spacing: spacing),GridItem(.fixed(size), spacing: spacing),GridItem(.fixed(size), spacing: spacing),GridItem(.fixed(size), spacing: spacing),GridItem(.fixed(size), spacing: spacing),GridItem(.fixed(size), spacing: spacing),GridItem(.fixed(size), spacing: spacing)]
        }
    }
    
    private var targetSeries: [TargetCheckPoint]? {
        switch habit.type {
        case .simple:
            return nil
        default:
            return masterModel.getTargetSeries(habitID: habit.id)
        }
    }
    
    private var stopSeries: [StopCheckPoint] {
        return masterModel.getStopCheckPoints(habitID: habit.id)
    }
    
    var body: some View {
        ZStack {
            DefaultIslandBackgroundView(tabIndex: $tabIndex, zoom: $zoomBg)
            GeometryReader { metric in
                VStack {
                    VStack {
                        Text("Drink water").frame(maxWidth: .infinity, alignment: .leading)
                        LazyHGrid(rows: rows, spacing: spacing) {
                            
                            //Rectangle().fill(.pink).frame(width: size,height: size).cornerRadius(2, corners: .allCorners)
                            ForEach( viewModel.getIntervalRecords(startDate: nil, endDate: nil, habitID: habit.id),id: \.self.date) {record in
                                Rectangle().fill(.pink).frame(width: size,height: size).cornerRadius(2, corners: .allCorners)
                            }
                            
                        }.frame(height: 160)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.thinMaterial)
            }
        }
    }
}

extension HabitStatisticCell

struct HabitCalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        HabitStatisticCell()
    }
}
