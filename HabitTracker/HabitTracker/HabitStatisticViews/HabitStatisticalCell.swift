//
//  HabitStatisticalCell.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/10/26.
//

import SwiftUI

@MainActor
class StatDigestImgCache {
    static var shared = StatDigestImgCache()
    
    var taskBatchId = UUID()
    
    func refreshToken() {
        taskBatchId = UUID()
    }
    
    func getToken() -> UUID {
        return taskBatchId
    }
    
    var imageCache = [String : UIImage]()
    
    func insertImageCache(id: String, img: UIImage, token: UUID) {
        if token == taskBatchId {
            imageCache[id] = img
        }
    }
    
    func invalidateSingleCache(id: String) {
        imageCache[id] = nil
    }
    
    func invalidateAllCache() {
        imageCache = [:]
    }
    
    func getImageCache(id: String) -> UIImage? {
        return imageCache[id]
    }
}

@MainActor
struct HabitStatisticalCell: View {
    
    var digestCycle: HabitStatisticShowType
    var habit: HabitModel
    var m: GeometryProxy
    @State var isShowProgress: Bool = false
    @State var graphImg: UIImage? = nil
    @State var dataOld = true
    
    func blockParameters(metricWidth: CGFloat, metricHeight: CGFloat) -> (width: CGFloat, height: CGFloat, spacing: CGFloat) {
        switch digestCycle {
        case .weekly:
            return (width: (metricWidth - 10) * 0.65 / 8, height: (metricWidth - 10) * 0.65 / 8, spacing: (metricWidth - 10) * 0.35 / 8)
        case .monthly:
            
            return (width: (metricWidth) * 0.65 / 31, height: (metricWidth) * 0.65 / 31, spacing: (metricWidth) * 0.35 / 31)
        case .annually:
            return (width: (metricWidth) * 0.85 / 53, height: (metricWidth) * 0.85 / 53, spacing: (metricWidth) * 0.15 / 53)
        }
    }
    var body: some View {
        ZStack{
            switch digestCycle {
                /*
            case .weekly:
                HStack(alignment: .center, spacing: 0) {
                    Text("\(habit.name)").frame(width: m.size.width * 0.3, alignment: .leading)
                    
                    GeometryReader { m in
                        if let image = graphImg {
                            VStack {
                                Spacer()
                                Image(uiImage: image).resizable().aspectRatio(contentMode:.fit)
                                Spacer()
                            }
                        } else {
                            //HabitStatisticFrequencyGraph(habit: habit, blockParameters: blockParameters(metricWidth: m.size.width, metricHeight: m.size.height))
                            VStack{}
                                .task {
                                    if dataOld {
                                        await updateData(metricWidth: m.size.width, metricHeight: m.size.height)
                                    }
                                }
                        }
                    }.frame(minHeight: m.size.width * 0.7 / 8)
                }
            case .monthly:
                VStack(alignment: .leading) {
                    Text("\(habit.name)").padding(.top, 7)
                    GeometryReader { m in
                        if let image = graphImg {
                            
                                
                                Image(uiImage: image).resizable().aspectRatio(contentMode:.fit)
                                
                            
                        } else {
                            VStack{}
                                .task {
                                    if dataOld {
                                        await updateData(metricWidth: m.size.width, metricHeight: m.size.height)
                                    }
                                }
                        }
                    }.frame(height: m.size.width / 31 * 1.1)

                }
                 */
            default:
                GeometryReader { m in
                    if let image = StatDigestImgCache.shared.getImageCache(id: habit.id) {
                        Image(uiImage: image).resizable().aspectRatio( contentMode: .fit)
                    
                    } else {
                        ProgressView().padding(8).background(backgroundGradientStart.opacity(0.7)).cornerRadius(6)
                            .task(priority: .high) {
                                //if dataOld {
                                    
                                    await updateData(metricWidth: m.size.width, metricHeight: m.size.height)
                                //}
                            }
                    }
                }.frame(height: m.size.width / 65 * 7)
                    
            }
            
            if isShowProgress {
                
            }
        }
        
    }
}

extension HabitStatisticalCell {
    typealias blockInfo = (Date, Double, Bool, Bool)
    
    private func updateData(metricWidth: CGFloat, metricHeight: CGFloat) async {
        let token = StatDigestImgCache.shared.getToken()
        Task.detached(priority: .background) {
            let habitId = await MainActor.run {
                habit.id
            }
            if await StatDigestImgCache.shared.getImageCache(id: habitId) == nil {
                await MainActor.run {
                    let data = getDataList(habitId: habit.id)
                    isShowProgress = true
                    let render = ImageRenderer(content: HabitStatisticFrequencyGraph(data: data, habit: habit, blockParameters: blockParameters(metricWidth: metricWidth, metricHeight: metricHeight)))
                    
                    render.scale = 3
                    let img = render.uiImage ?? UIImage()
                    Task.detached {
                        await StatDigestImgCache.shared.insertImageCache(id: habitId, img: img, token: token)
                        await updateImage()
                        
                    }
                }
                
            } else {
                await updateImage()
            }
            
            
        }
        @Sendable func updateImage() async {
            let img = await StatDigestImgCache.shared.getImageCache(id: habit.id)
            await MainActor.run {
                dataOld = false
                graphImg = img
                isShowProgress = false
            }
        }
    }
    
    private func getDataList(habitId: String) -> [(Int, Color)] {
        let viewModel = HabitTrackerStatisticViewModel.shared
        let masterModel = HabitViewModel.shared
        var res = [(Date, Double, Bool, Bool)]()
        var tempInfo = (date: Date(), rate: 0.0, isOut: false, isStopped: false)
        var targetSeries = [TargetCheckPoint]()
        var stopSeries = [StopCheckPoint]()
        var recordSeries = [HabitRecord]()
        targetSeries = masterModel.getTargetSeries(habitID: habitId)
        stopSeries = masterModel.getStopCheckPoints(habitID: habitId)
        recordSeries = viewModel.getIntervalRecords(startDate: nil, endDate: nil, habitID: habitId)
        var targetPointIdx = 0
        var stopPointIdx = 0
        var recordPointIdx = 0
        
        for date in viewModel.selectedIntervalDateList {
            appendIfNeeded(date: date)
        }
        return res.enumerated().map{ idx, info in
            (idx, getFillColor(info: info))
        }
        
        func appendIfNeeded(date: Date) {
            filterOutofInterval(date: date)
        }
        
        func filterOutofInterval(date: Date) {
            tempInfo = (date: date, rate: 0.0, isOut: false, isStopped: false)
            switch viewModel.digestChartCycle {
            case .annually:
                switch habit.cycle {
                case .daily:
                    if !date.isSameYear(viewModel.markDate ?? Date()) {
                        tempInfo.isOut = true
                    }
                case .weekly:
                    if !date.isSameYear(viewModel.markDate ?? Date()) {
                        tempInfo.isOut = true
                    }
                case .monthly:
                    if !date.isSameYear(viewModel.markDate ?? Date()) {
                        tempInfo.isOut = true
                    }
                }
            case .monthly:
                if !date.isSameMonth(viewModel.markDate ?? Date()) {
                    tempInfo.isOut = true
                }
            case .weekly:
                tempInfo.isOut = false
            }
            filterStopped(date: date)
        }
        
        func filterStopped(date: Date) {
            var stopped = false
                stopped = isStopped(date: date, idx: stopPointIdx)
            
            if stopped {
                tempInfo.isStopped = true
            }
            calculateAndAppendRate(date: date)
        }
        
        func calculateAndAppendRate(date: Date) {
            var target = 0
                target = getTarget(date: date)
            
            switch habit.cycle {
            case .daily:
                let rate = Double(getProgress(date: date)) / Double(target)
                tempInfo.rate = rate
                if viewModel.digestChartCycle != .annually && res.last?.2 == true {
                    res = []
                }
                res.append(tempInfo)
            case .weekly:
                if date.compareToByDay(date.startOfWeek()) == 0 {
                    let rate = Double(getProgress(date: date)) / Double(target)
                    tempInfo.rate = rate
                } else {
                    tempInfo.rate = res.last?.1 ?? 0
                }
                if viewModel.digestChartCycle != .annually && res.last?.2 == true {
                    res = []
                }
                res.append(tempInfo)
            case .monthly:
                if date.compareToByDay(date.startOfMonth()) == 0 {
                    let rate = Double(getProgress(date: date)) / Double(target)
                    tempInfo.rate = rate
                } else {
                    tempInfo.rate = res.last?.1 ?? 0
                }
                if viewModel.digestChartCycle != .annually && res.last?.2 == true {
                    res = []
                }
                res.append(tempInfo)
            }
        }
        
        //返回习惯在某一个日期是否已经停止或者是否开始
        func isStopped(date: Date, idx: Int) -> Bool {
            for i in idx..<stopSeries.count {
                if let nextDate = stopSeries[i].date {
                    if nextDate.compareToByDay(date) <= 0 {
                        stopPointIdx = i
                    } else {
                        break
                    }
                }
            }
            if date.compareToByDay(stopSeries[stopPointIdx].date ?? date) < 0 {
                return true
            }
            return stopSeries[stopPointIdx].type != StopPointType.go.rawValue
        }
        
        //返回在某一个日期的目标，如果是时间就转换成分钟形式的Int
        func getTarget(date: Date) -> Int {
            for i in targetPointIdx..<targetSeries.count {
                if let nextDate = targetSeries[i].date {
                    if nextDate.compareToByDay(date) <= 0 {
                        targetPointIdx = i
                    } else {
                        break
                    }
                }
            }
            switch habit.type {
            case .number:
                let res = targetSeries[targetPointIdx].numberTarget
                return Int(res)
            case .time:
                return targetSeries[targetPointIdx].timeTarget?.timeToMinutes() ?? Int.max
            default:
                return 1
            }
        }
        
        //返回在某一日期的记录，如果是时间就转换成分钟形式的Int
        func getProgress(date: Date) -> Int {
            let res = 0
            for i in recordPointIdx..<recordSeries.count {
                if let nextDate = recordSeries[i].date {
                    if nextDate.compareToByDay(date) < 0 {
                        recordPointIdx = i
                        continue
                    } else if nextDate.compareToByDay(date) == 0 {
                        recordPointIdx = i
                        switch habit.type {
                        case .number:
                            let res = recordSeries[i].numberProgress
                            return Int(res)
                        case .time:
                            return recordSeries[i].timeProgress?.timeToMinutes() ?? 0
                        case .simple:
                            return recordSeries[i].done ? 1 : 0
                        }
                    } else {
                        return res
                    }
                }
            }
            return 0
        }
    }
    
}

extension HabitStatisticalCell {
    private func getFillColor(info: ((Date, Double, isOut: Bool, isStopped: Bool))) -> Color {
        let rate = info.1
        if info.isOut {
            return .clear
        }
        else if info.isStopped {
            return .orange.lighter(by: 25)
        }
        else if rate >= 0 && rate <= 0.2 {
            return .gray.lighter(by: 40)
        }
        else if rate > 0.2 && rate <= 0.4 {
            return .green.lighter(by: 20)
        }
        else if rate > 0.4 && rate <= 0.6 {
            return .green.lighter(by: 10)
        }
        else if rate > 0.6 && rate <= 0.8 {
            return .green.lighter(by: 0)
        }
        else if rate > 0.8 {
            return .green.darker(by: 5)
        }
        return backgroundGradientStart.lighter(by: 30)
    }
}

struct HabitStatisticalCell_Preview: PreviewProvider {
    static var previews: some View {
        StatisticalView()
    }
}
