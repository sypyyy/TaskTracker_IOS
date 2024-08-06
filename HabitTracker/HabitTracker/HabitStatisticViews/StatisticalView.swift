//
//  StatisticalView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/7/22.
//

import SwiftUI


//
//  HabitCalendarCell.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/7/9.
//

import SwiftUI



struct StatisticalView: View, Sendable {
    @State var tabIndex: AppTabShowType = .checkIn
    
    var habits: [HabitModel?] = HabitViewModel.shared.getAllHabits().map(HabitModel.init)
    @StateObject var statsViewModel: HabitTrackerStatisticViewModel = HabitTrackerStatisticViewModel.shared
    var masterModel: MasterViewModel = MasterViewModel.shared
    @State var detailHabit: HabitModel? = nil
    @State var isDetailViewActive = false
    @State var detailListRowFrame: CGRect? = nil
    @State var notifyDetailViewAnimationFlag = false
    var shouldShowDetailHabit: Bool {
        detailHabit != nil && detailListRowFrame != nil && isDetailViewActive
    }
    var body: some View {
        VStack {
            GeometryReader { m in
                ZStack {
                    
                    VStack {
                        
                        Text("Digest")
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                            .foregroundColor(.primary.opacity(0.7)).padding(.bottom, 2)
                        HStack {
                            Button{intervalChange(goback: true)} label: {Image(systemName: "arrowtriangle.backward.fill")}
                            Text("\(statsViewModel.selectedInterval.str)")
                            Button{intervalChange(goback: false)} label: {Image(systemName: "arrowtriangle.forward.fill")}
                        }
                        .transaction { transaction in
                            transaction.animation = nil
                        }.padding(.bottom)
                        
                        
                        HStack {
                            /*
                             Picker("Statistic period", selection: $viewModel.statisticalChartType) {
                             Text("Weekly").tag(HabitStatisticShowType.weekly)
                             Text("Monthly").tag(HabitStatisticShowType.monthly)
                             Text("Yearly").foregroundColor(.red).tag(HabitStatisticShowType.annually)
                             }
                             .pickerStyle(.segmented)
                             
                             .frame(width: 250)
                             */
                            CustomSegmentedControl( optionLabels:  [{selected in
                                Text("Weekly")
                            },{selected in
                                Text("Monthly")
                            }, {selected in
                                Text("Yearly")
                            }]) {preselectedIndex in
                                var type: HabitStatisticShowType = .weekly
                                if preselectedIndex == 1 {
                                    type = .monthly
                                }
                                else if preselectedIndex == 2 {
                                    type = .annually
                                }
                                HabitTrackerStatisticViewModel.shared.digestChartCycle = type
                                HabitTrackerStatisticViewModel.shared.markDate = Date()
                                Task.detached(priority: .userInitiated) {
                                    await StatDigestImgCache.shared.invalidateAllCache()
                                    await MainActor.run {
                                        HabitTrackerStatisticViewModel.shared.objectWillChange.send()
                                    }
                                }
                                
                            }.padding(.horizontal)
                                .fontWeight(.medium)
                            
                        }.padding(.horizontal)
                        
                        
                        
                        switch statsViewModel.digestChartCycle {
                        case .weekly:
                            List() {
                                Section {
                                    ForEach(filterHabits().compactMap{$0},  id:\.id) {habit in
                                        
                                        NavigationLink{Text("dbesj").onTapGesture {
                                            statisticalView_hostingNavigationController.popViewController(animated: true)
                                        }} label: {
                                            HabitStatisticalCell(digestCycle: .weekly, habit: habit, m: m, isShowProgress: true)
                                                .listRowSeparator(.hidden)
                                                .listRowBackground(Color.clear)
                                        }
                                    }
                                } /* header: {
                                   HStack {
                                   Text("0%")
                                   RoundedRectangle(cornerRadius: 4).fill(.gray).frame(width: 13,height: 13)
                                   RoundedRectangle(cornerRadius: 4).fill(.gray).frame(width: 13,height: 13)
                                   RoundedRectangle(cornerRadius: 4).fill(.gray).frame(width: 13,height: 13)
                                   RoundedRectangle(cornerRadius: 4).fill(.gray).frame(width: 13,height: 13)
                                   RoundedRectangle(cornerRadius: 4).fill(.gray).frame(width: 13,height: 13)
                                   Text("100%   ")
                                   
                                   RoundedRectangle(cornerRadius: 4).fill(.gray).frame(width: 13,height: 13)
                                   Text("Inactive").textCase(.none)
                                   }
                                   }
                                   */
                                Section{VStack{}}.frame(height: 20).listRowBackground(Color.clear)
                            }
                            
                            .foregroundColor(.primary.opacity(0.5))
                            .fontWeight(.bold)
                            .scrollContentBackground(.hidden)
                            .id(UUID())
                            .task {
                                
                                
                            }
                            
                            //.navigationTitle("")
                            .toolbar(.hidden)
                            //.navigationBarHidden(true)
                            
                        case .monthly:
                            List {
                                ForEach(filterHabits().compactMap{$0},  id:\.id) {habit in
                                    NavigationLink{Text("dbesj").onTapGesture {
                                        statisticalView_hostingNavigationController.popViewController(animated: true)
                                    }} label: {
                                        HabitStatisticalCell(digestCycle: .monthly,habit: habit, m: m)
                                            .listRowSeparator(.hidden)
                                            .listRowBackground(Color.clear)
                                    }
                                }
                                Section{VStack{}}.frame(height: 20).listRowBackground(Color.clear)
                            }
                            .foregroundColor(.primary.opacity(0.5))
                            .fontWeight(.bold)
                            .scrollContentBackground(.hidden)
                            .id(UUID())
                            .task {
                                
                            }
                            
                            
                        default:
                            
                            List {
                                ForEach(filterHabits().compactMap{$0}, id:\.id) {habit in
                                    let s = print("cfdsccfdrf")
                                    
                                    Section{
                                        
                                        
                                            VStack {
                                                VStack(alignment: .leading) {
                                                    NavigationLink{} label: {
                                                        
                                                        Text("\(habit.name)")
                                                            .padding(.top, 7).disabled(true)
                                                        
                                                        
                                                    }
                                                    
                                                    HabitStatisticalCell(digestCycle: .annually,habit: habit, m: m)
                                                        .listRowSeparator(.hidden)
                                                        .listRowBackground(Color.clear)
                                                    
                                                    
                                                }.padding()
                                                
                                            }.contentShape(Rectangle())
                                            .onTapGesture {
                                                detailHabit = habit
                                                isDetailViewActive = true
                                            }
                                        
                                        //.buttonStyle(ListButtonStyle())
                                        .overlay{
                                            GeometryReader{reader in
                                                
                                                if isDetailViewActive, let detailId = detailHabit?.id, detailId == habit.id {
                                                    VStack{}.onAppear{
                                                        detailListRowFrame = reader.frame(in: .global)
                                                    }
                                                }
                                            }.id(UUID())
                                            
                                        }
                                    }
                                    
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                    //.background(.regularMaterial)
                                    .background(Color.white.opacity(0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                                    .listRowBackground(Color.clear)
                                    //.opacity(shouldShowDetailHabit && detailHabit?.id == habit.id ? 0 : 1)
                                }
                                Section{VStack{}}.frame(height: 20).listRowBackground(Color.clear)
                                
                            }
                            .foregroundColor(.primary.opacity(0.5))
                            .fontWeight(.bold)
                            .scrollContentBackground(.hidden)
                            //syppp test
                            .id(1)
                            
                            
                        }
                    }
                    
                    
                    
                    StatisticalDetailView(isActive: $isDetailViewActive, habit: detailHabit, enteringChartCycle: .annually, shrinkedRect: $detailListRowFrame, screenWidth: m.size.width, screenHeight: m.size.height).onTapGesture{
                        isDetailViewActive = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            detailHabit = nil
                            detailListRowFrame = nil
                        }
                        //detailHabit = nil
                        //detailListRowFrame = nil
                    }
                    //.background(.red.opacity(0.2))
                    .disabled(!isDetailViewActive)
                    
                }//.animation(.easeInOut(duration: 0.6), value: isDetailViewActive)
                    //.animation(.easeInOut(duration: 0.6), value: detailListRowFrame)
            }
        }
        
    }
}



struct ListButtonStyle: ButtonStyle {

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            //.background(configuration.isPressed ? Color.gray.opacity(0.1) : Color.clear)
            //.scaleEffect(configuration.isPressed ? 1.05 : 1)
            //.animation(.snappy(duration: 0), value: configuration.isPressed)
    }
}



extension StatisticalView {
    private func intervalChange(goback: Bool) {
        var newMarkDate: Date?
        switch statsViewModel.digestChartCycle {
        case .weekly:
            newMarkDate = statsViewModel.markDate?.addByDay(goback ? -7 : 7)
        case .monthly:
            newMarkDate = statsViewModel.markDate?.addByMonth(goback ? -1 : 1)
        case .annually:
            newMarkDate = statsViewModel.markDate?.addByYear(goback ? -1 : 1)
        }
        statsViewModel.markDate = newMarkDate
        Task.detached {
            await StatDigestImgCache.shared.invalidateAllCache()
            await MainActor.run {
                statsViewModel.objectWillChange.send()
            }
        }
    }
}
    

extension StatisticalView {
    private func filterHabits() -> [HabitModel?] {
        var res = habits
        res.enumerated().forEach() { index, habit in
            switch habit?.cycle {
            case .monthly:
                if statsViewModel.digestChartCycle == .weekly {
                    res[index] = nil
                }
            default:
                break
            }
        }
        return res
    }
}

/*
extension StatisticalView {
    typealias blockInfo = (Date, Double, Bool, Bool)
    
    
    func blockParameters(metricWidth: CGFloat, metricHeight: CGFloat) -> (width: CGFloat, height: CGFloat, spacing: CGFloat) {
        switch statsViewModel.digestChartCycle {
        case .weekly:
            return (width: (metricWidth - 10) * 0.65 / 8, height: (metricWidth - 10) * 0.65 / 8, spacing: (metricWidth - 10) * 0.35 / 8)
        case .monthly:
            
            return (width: (metricWidth) * 0.65 / 31, height: (metricWidth) * 0.65 / 31, spacing: (metricWidth) * 0.35 / 31)
        case .annually:
            return (width: (metricWidth) * 0.85 / 53, height: (metricWidth) / 70, spacing: (metricWidth) * 0.15 / 53)
        }
    }
    
    private func updateData(m: GeometryProxy) async {
        Task.detached(priority: .background) {
            for habit in await filterHabits().compactMap({$0}) {
                await getDataList(habit: habit)
                let render = await ImageRenderer(content: HabitStatisticFrequencyGraph(habit: habit, blockParameters: blockParameters(metricWidth: m.size.width - 60, metricHeight: 144)))
                await MainActor.run{
                    render.scale = 3.0
                }
                imageCache[habit.id] =  await render.uiImage
            }
            await MainActor.run {
                dataOld = false
                statsViewModel.objectWillChange.send()
            }
        }
    }
    
    private func getDataList(habit: habitViewModel) {
        let viewModel = HabitTrackerStatisticViewModel.shared
        let masterModel = HabitTrackerViewModel.shared
        var res = [(Date, Double, Bool, Bool)]()
        var tempInfo = (date: Date(), rate: 0.0, isOut: false, isStopped: false)
        let targetSeries = masterModel.getTargetSeries(habitID: habit.id)
        let stopSeries = masterModel.getStopCheckPoints(habitID: habit.id)
        let recordSeries = viewModel.getIntervalRecords(startDate: nil, endDate: nil, habitID: habit.id)
        var targetPointIdx = 0
        var stopPointIdx = 0
        var recordPointIdx = 0
        
        for date in viewModel.selectedIntervalDateList {
            appendIfNeeded(date: date)
        }
        
        viewModel.cachedData[habit.id] = res.enumerated().map{ idx, info in
            (idx, getFillColor(info: info))
        }
        
        func appendIfNeeded(date: Date) {
            filterOutofInterval(date: date)
            //res.append((date, 0, false, false))
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
            let isStopped = isStopped(date: date, idx: stopPointIdx)
            if isStopped {
                tempInfo.isStopped = true
            }
            calculateAndAppendRate(date: date)
        }
        
        func calculateAndAppendRate(date: Date) {
            let target = getTarget(date: date)
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
*/
extension StatisticalView {
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
 



struct StatisticalView_Previews: PreviewProvider {
    static var previews: some View {
        RootView(viewModel: MasterViewModel.shared)
    }
}


