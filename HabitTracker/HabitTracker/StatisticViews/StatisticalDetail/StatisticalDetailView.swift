//
//  StatisticalDetailView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/13.
//

import SwiftUI
import Charts

struct StatisticalDetailView: View {
    @Namespace var animation
    @Binding var isActive: Bool
    @State var appeared = false
    let habit: HabitModel?
    let enteringChartCycle: HabitStatisticShowType
    let shrinkedRect: CGRect?
    let screenWidth: CGFloat
    let screenHeight: CGFloat
    let SPACE_SCROLL_VIEW = "HabitDetailScrollViewSpace"
    let animationDuration = 0.4
    
    var body: some View {
        
        GeometryReader { reader in
            let safePaddingTop = reader.safeAreaInsets.top
            let safePaddingBottom = reader.safeAreaInsets.bottom
            let safePaddingVertical = safePaddingTop + safePaddingBottom
            let render = print("detail view rendered!!!!!!")
            let t = print("detail view shrinkedRectMidY: \(shrinkedRect?.midY)")
            let t1 = print("detail view isActive: \(isActive)")
            let t2 = print("detail view appeared: \(appeared)")
            if let habit = habit, let shrinkedRect = shrinkedRect {
                ZStack {
                    VStack{}.frame(maxWidth: .infinity, maxHeight: .infinity).background(.white.opacity(0.5)).ignoresSafeArea()
                    
                    
                    LinearGradient(colors: [backgroundGradientStart, backgroundGradientEnd], startPoint: .top, endPoint: .bottom).ignoresSafeArea().opacity(appeared ? 1.0 : 0.0)
                        .animation(.easeIn(duration: animationDuration), value: appeared)
                    VStack{}.frame(maxWidth: .infinity, maxHeight: .infinity).background(.thinMaterial).ignoresSafeArea().opacity(appeared ? 1.0 : 0.0)
                        .animation(.easeIn(duration: animationDuration), value: appeared)
                    VStack(spacing: 0){
                        HStack{
                            Button{} label: {
                                Image(systemName: "arrow.backward").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.5)).padding(.leading)
                            }
                            Spacer()
                            Text("Stats").font(.system(size: 20, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.65)).padding(.leading)
                            Spacer()
                            Button{} label: { Image(systemName: "square.and.arrow.up").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.5)).padding(.trailing)
                            }
                        }
                        .padding(.bottom)
                        .background(.regularMaterial)
                        ScrollView{
                            
                            HStack {
                                Image(systemName: "drop")
                                
                                if(appeared) {
                                    Text("\(habit.name)")
                                        .minimumScaleFactor(0.1)
                                        .matchedGeometryEffect(id: "detailTitle\(habit.id)", in: animation, properties: .frame, isSource: false)
                                }
                                
                                Spacer()
                            }
                            
                            .font(.system(size: 26, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.65))
                            .padding(.top, 15).padding(.bottom, 10).padding(.leading)
                            StatDetailContent(habit: habit, enteringChartCycle: enteringChartCycle).offset(x: 0, y: appeared ? 0 : screenHeight).opacity(appeared ? 1 : 0)
                                .animation(.easeIn(duration: animationDuration), value: appeared)
                            Spacer()
                            
                            
                        }
                    }
                    VStack {
                        VStack(alignment: .leading) {
                            NavigationLink{} label: {
                                if(!appeared) {
                                    Text("\(habit.name)")
                                        .matchedGeometryEffect(id: "detailTitle\(habit.id)", in: animation, properties: .frame, isSource: true)
                                        .foregroundColor(.primary.opacity(0.5))
                                        .fontWeight(.bold)
                                }
                                
                            }.disabled(true)
                                .padding(.top, 7)
                            HabitStatisticalCell(digestCycle: .annually, habit: habit, m: reader, isShowProgress: false)
                                .opacity(appeared ? 0 : 1)
                                //.offset(x: 0, y: appeared ? shrinkedRect.height : 0)
                                .animation(.easeInOut(duration: animationDuration / 2), value: appeared)
                        }.padding()
                    }.clipShape(RoundedRectangle(cornerRadius: 18.0))
                        .frame(width: shrinkedRect.size.width, height: shrinkedRect.size.height).position(x: screenWidth / 2, y: shrinkedRect.midY - safePaddingTop)
                        
                    
                }
                .coordinateSpace(name: SPACE_SCROLL_VIEW)
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                .mask {RoundedRectangle(cornerRadius: 18.0).frame(width: appeared ? screenWidth : shrinkedRect.size.width, height: appeared ? (screenHeight + safePaddingVertical) : shrinkedRect.size.height).position(x: screenWidth / 2, y: appeared ? screenHeight / 2 - (safePaddingTop - safePaddingBottom) / 2 : shrinkedRect.midY - safePaddingTop)}
                // ignoreSafeEdgeMidY = screenH / 2
                // MidY = safeT + (screenH - safeT - safeB) / 2 = (safeT - safeB) / 2 + screenH / 2
                
                .animation(.easeInOut(duration: animationDuration), value: appeared)
                
                .onAppear {
                    if(isActive) {
                        print("detail view onAppear!!!!")
                        appeared = true
                    }
                }
                .onChangeCustom(of: isActive) {
                    //DispatchQueue.main.async {
                    print("detail view onchange!!!!")
                        appeared = isActive
                    //}
                    
                }
                
                
            }
        }
        .opacity(appeared ? 1 : 0)
        .animation(.easeInOut(duration: 0.01).delay(appeared ? 0 : animationDuration), value: appeared)
    }
}


struct StatDetailContent: View {
    
    let habit: HabitModel
    let enteringChartCycle: HabitStatisticShowType
    
    var body: some View {
        
                HStack {
                    VStack {
                       
                        ZStack {
                            Circle().stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .miter)).fill(Color("Background").opacity(0.8)).frame(width: 100.0, height: 100.0, alignment: .center).rotationEffect(Angle(degrees: -90))
                            Circle().trim(from: 0, to: 0.4)
                                .stroke(style: StrokeStyle(lineWidth: 12.0, lineCap: .round, lineJoin: .miter)).fill(backgroundGradientStart).frame(width: 100.0, height: 100.0, alignment: .center).rotationEffect(Angle(degrees: -90))
                          
                                Text("60%").font(.system(size: 23, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.65))
                            
                        }.padding(.bottom, 6)
                        Text("Overal Completeness").font(.system(size: 12, weight: .medium, design: .rounded)).foregroundColor(.primary.opacity(0.65))
                    }.padding(.trailing, 10)
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        HStack{
                            Text("Best Streak: ").foregroundColor(.primary.opacity(0.45))
                            Spacer()
                            Text("2")
                            Text("days").foregroundColor(.primary.opacity(0.45))
                        }
                        Spacer()
                        HStack{
                            Text("Current Streak: ").foregroundColor(.primary.opacity(0.45))
                            Spacer()
                            Text("2")
                            Text("days").foregroundColor(.primary.opacity(0.45))
                        }
                        Spacer()
                        HStack{
                            Text("Avg. Per Day: ").foregroundColor(.primary.opacity(0.45))
                            Spacer()
                            Text("999")
                            Text("cups").foregroundColor(.primary.opacity(0.45))
                        }
                        Spacer()
                        Spacer()
                        Spacer()
                    }.font(.system(size: 15, weight: .medium, design: .rounded)).foregroundColor(.primary.opacity(0.75))
                        .frame(maxHeight: .infinity).minimumScaleFactor(0.7)
                        .frame(height: 100).padding(.bottom)
                    
                }.padding(.horizontal)
                //.frame(height: 130)
                //.background(.red)
            
            Text("Yearly Stats")
        
            BarChart(viewModel: HabitTrackerStatisticDetailViewModel(habit: habit, markDate: Date(), chartType: enteringChartCycle))
                .padding(.vertical)
                .padding(.horizontal)
                .background(.regularMaterial)
                .cornerRadius(12)
                .padding(.horizontal)
            
        
    }
}

extension StatDetailContent {
    
    struct BarChart: View {
        @StateObject var viewModel: HabitTrackerStatisticDetailViewModel
        
        var body: some View {
            //let data: [(String, Int, Int)] = viewModel.cachedRegularChartData
            let test = print("BarChart Drawn")
            let data: [(String, Int, Int)] = [("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2), ("dsds", 1, 2)]
            Chart {
                ForEach(data, id: \.0) { dot in
                   LineMark(
                            x: .value("Shape Type", dot.0),
                            y: .value("Total Count", dot.1)
                        )
                }
            }
            .task {
                await viewModel.getDataList()
                await MainActor.run{
                    viewModel.objectWillChange.send()
                }
            }
        }
    }
}

struct ViewPositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct StatisticalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { m in
            StatisticalDetailView(isActive: .constant(true), appeared: false, habit: HabitViewModel.shared.getOngoingHabitViewModels()[0], enteringChartCycle: .annually, shrinkedRect: CGRect(x: 30, y: 150, width: 300, height: 50), screenWidth:m.size.width, screenHeight: m.size.height)
        }
    }
}

/*
struct TextTransitionModifier: ViewModifier {
    let isAfterTransition: Bool
    let positionBeforeInGlobal: CGRect?
    let positionAfterInGlobal: CGRect?
    
    var shouldShow: Bool {
        positionBeforeInGlobal != nil && positionAfterInGlobal != nil
    }
    
    var xBefore: CGFloat {
        (positionBeforeInGlobal?.midX ?? 0)
    }
    
    var yBefore: CGFloat {
        (positionBeforeInGlobal?.midY ?? 0)
    }
    
    var xAfter: CGFloat {
        positionAfterInGlobal?.midX ?? 0
    }
    
    var yAfter: CGFloat {
        positionAfterInGlobal?.midY ?? 0
    }
    
    func body(content: Content) -> some View {
        content
        .opacity(shouldShow ? 1 : 0)
        
        .font(.system(size: isAfterTransition ? 26 : 18, weight: .bold, design: .rounded))
        .globalPosition(CGPoint(x: isAfterTransition ? xAfter : xBefore, y: isAfterTransition ? yAfter : yBefore))
           // .position(x: isAfterTransition ? xAfter : xBefore, y: isAfterTransition ? yAfter : yBefore)
        
    }
}
 */

struct StatisticalDetailAnimation_Previews: PreviewProvider {
    static var previews: some View {
         
        StatisticalView().background(.pink.opacity(0.1))
    }
}
