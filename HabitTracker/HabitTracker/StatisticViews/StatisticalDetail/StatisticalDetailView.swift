//
//  StatisticalDetailView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/8/13.
//

import SwiftUI
import Charts

struct StatisticalDetailView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [backgroundGradientStart, backgroundGradientEnd], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
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
                StatDetailContent()
                
                Spacer()
            }.frame(maxWidth: .infinity, maxHeight: .infinity).background(.thinMaterial)
            
            
                
            
                
            
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        
    }
}

struct StatDetailContent: View {
    var body: some View {
        ScrollView {
            HStack {
                Image(systemName: "drop")
                Text("Drink water")
                Spacer()
            }.font(.system(size: 26, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.65))
                .padding(.top, 15).padding(.bottom, 10).padding(.leading)
            
            
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
            BarChart()
                .padding(.vertical)
                .padding(.horizontal)
                .background(.regularMaterial)
                .cornerRadius(12)
                .padding(.horizontal)
            
            }
           
       
    }
}


struct BarChart: View {
    struct ToyShape: Identifiable {
        var type: String
        var count: Double
        var id = UUID()
    }
    
    var body: some View {
        var data: [ToyShape] = [
            .init(type: "Cube", count: 5),
            .init(type: "Sphere", count: 4),
            .init(type: "Pyramid", count: 4)
        ]
        Chart {
            BarMark(
                    x: .value("Shape Type", data[0].type),
                    y: .value("Total Count", data[0].count)
                )
                BarMark(
                     x: .value("Shape Type", data[1].type),
                     y: .value("Total Count", data[1].count)
                )
                BarMark(
                     x: .value("Shape Type", data[2].type),
                     y: .value("Total Count", data[2].count)
                )
        }
    }
}

struct StatisticalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticalDetailView()
    }
}
