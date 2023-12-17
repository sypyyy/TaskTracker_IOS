//
//  TaskListView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/11.
//

import Foundation
import SwiftUI


struct TaskListView : View {
    @StateObject var viewModel: HabitTrackerViewModel = HabitTrackerViewModel.shared
    let cardIdealHeight = 230
    let cardMaxHeight = 230
    @State var tappedOne: Int64?
    @State var scaleRatio: CGFloat = 1.0
    //@State var thisDayRecords: [Record] = habitTrackerViewModel.shared.get
    
    init(viewModel: HabitTrackerViewModel) {
        print("init11111")
        print("syppp\(Date())")
        print("syppp\(Date().startOfWeek())")
        print("syppp\(Date().startOfMonth())")
    }
    var body : some View {
        VStack{
            GeometryReader{ metric in
                ScrollView(showsIndicators : false) {
                    LazyVStack{
                        ForEach(viewModel.getOngoingHabitViewModels(), id: \.self.id) { habit in
                            VStack{
                                
                                HStack {
                                    VStack {
                                        HStack(alignment: .center){
                                            HStack{
                                                ZStack {
                                                    Circle().stroke(lineWidth: 2).fill(.white)
                                                        
                                                        .frame(width: 28, height: 28)
                                                        .onTapGesture {
                                                            
                                                        }
                                                    CheckMarkShape().foregroundColor(habit.getProgressPercent() == 1 ? .pink.opacity(0.5) : .clear).frame(width: 26, height: 21).offset(x: -1, y: 0).mask(Circle().frame(width: 28, height: 28))
                                                }
                                                Text("\(habit.name)")
                                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                                    .foregroundColor(.primary.opacity(0.6))
                                                    .lineLimit(tappedOne  == habit.id ? 20 : 2)
                                                    //.multilineTextAlignment(TextAlignment.leading)
                                                Spacer()
                                            }.frame(maxWidth: metric.size.width * 0.7)
                                            
                                            Spacer()
                                        }.frame(maxHeight: tappedOne != habit.id ? CGFloat(cardMaxHeight): CGFloat(cardIdealHeight))
                                            
                                        //.fixedSize()
                                        
                                        HStack{
                                            Text("\(habit.cycle.rawValue)")
                                            if habit.type == .number {
                                                Text("|").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                                                Text("\(habit.numberProgress ?? 0)\(habit.numberTarget == nil ? "" : " / \(habit.numberTarget ?? 0)") \(habit.unit)").font(.system(size: 18, weight: .regular, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                                            }
                                            
                                            if habit.type == .time {
                                                Text("|").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                                                Text("\(habit.timeProgress ?? "0:00")\(habit.timeTarget == nil ? "" : " / \(habit.timeTarget ?? "0:00")")").font(.system(size: 18, weight: .regular, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                                            }
                                           
                                        Spacer()
                                        }.font(.system(size: 18, weight: .regular, design: .rounded)).foregroundColor(.primary.opacity(0.6))
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    withAnimation(.spring){
                                        if tappedOne == habit.id {
                                            tappedOne = nil
                                        } else {
                                            tappedOne = habit.id
                                        }
                                    }
                                }
                                
                                //MARK: the detail view
                                //
                                if(tappedOne == habit.id) {
                                    HabitDetailView(habit: habit)
                                }
                                
                                //Spacer()
                                
                            }
                            
                                .padding()
                                //.background(.white.opacity(0.6))
                            
                                .background(
                                    Color.clear.background(.regularMaterial).environment(\.colorScheme, .light))
                             
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                //.shadow(color: Color("Shadow"), radius: 2, x: 0, y: 1)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.6), lineWidth: 2).offset(y :1.5).blur(radius: 0).mask(RoundedRectangle(cornerRadius: 15))
                                )
                                .padding()
                                
                                
                                
                        }
                    }.padding(.bottom, 88)
                        
                    
                }
            }
           
        }.font(.title)
    }
}

/*
struct editNumberView: View {
    var body: some View {
        
    }
}
 */

struct ContentView_Previews1: PreviewProvider {
    static let overalViewModel = HabitTrackerViewModel()
    
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        RootView(viewModel : overalViewModel).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

