//
//  HabitCalendarCell.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/7/9.
//

import SwiftUI

@MainActor
struct HabitStatisticFrequencyGraph: View {
    
    var data : [(Int, Color)]
    var habit: HabitModel
    var blockParameters: (width: CGFloat, height: CGFloat, spacing: CGFloat)
        //let spacing = 0.0
    //row height
    var viewModel: HabitTrackerStatisticViewModel = HabitTrackerStatisticViewModel.shared
    var masterModel: HabitViewModel = HabitViewModel.shared
    private var rows: [GridItem] {
        switch viewModel.digestChartCycle {
        case .weekly:
            return [GridItem(.fixed(blockParameters.height), spacing: blockParameters.spacing)]
        case .monthly:
            return [GridItem(.fixed(blockParameters.height), spacing: blockParameters.spacing)]
        case .annually:
            return [
                    GridItem(.fixed(blockParameters.height), spacing: blockParameters.spacing), GridItem(.fixed(blockParameters.height), spacing: blockParameters.spacing), GridItem(.fixed(blockParameters.height), spacing: blockParameters.spacing), GridItem(.fixed(blockParameters.height), spacing: blockParameters.spacing), GridItem(.fixed(blockParameters.height), spacing: blockParameters.spacing),
                    GridItem(.fixed(blockParameters.height), spacing: blockParameters.spacing),
                    GridItem(.fixed(blockParameters.height), spacing: blockParameters.spacing)]
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
    
    private var recordSeries: [HabitRecord] {
        return viewModel.getIntervalRecords(startDate: nil, endDate: nil, habitID: habit.id)
    }
    
    var body: some View {
        
            
                VStack(alignment: .center) {
                    VStack {
                        LazyHGrid(rows: rows, spacing: blockParameters.spacing) {
                            ForEach(data, id: \.0) {tuple in
                                RoundedRectangle(cornerRadius: blockParameters.width / 5).fill(tuple.1).frame(width: blockParameters.width,height: blockParameters.height)
                            }
                        }
                        //.frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            
        
    }
}


extension HabitStatisticFrequencyGraph {
    private func getFillColor(info: ((Date, Double, isOut: Bool, isStopped: Bool))) -> Color {
        let rate = info.1
        if info.isOut {
            return .clear
        }
        else if info.isStopped {
            return .gray.lighter(by: 35)
        }
        else if rate >= 0 && rate <= 0.2 {
            return backgroundGradientStart.lighter(by: 30)
        }
        else if rate > 0.2 && rate <= 0.4 {
            return backgroundGradientStart.lighter(by: 20)
        }
        else if rate > 0.4 && rate <= 0.6 {
            return backgroundGradientStart.lighter(by: 10)
        }
        else if rate > 0.6 && rate <= 0.8 {
            return backgroundGradientStart.lighter(by: 0)
        }
        else if rate > 0.8 {
            return backgroundGradientStart.darker(by: 5)
        }
        return backgroundGradientStart.lighter(by: 30)
    }
}

struct HabitCalendarCell_Previews: PreviewProvider {
    static var previews: some View {
        StatisticalView()
    }
}
