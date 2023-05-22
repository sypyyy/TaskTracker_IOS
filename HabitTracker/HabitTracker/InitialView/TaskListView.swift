//
//  TaskListView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/11.
//

import Foundation
import SwiftUI

struct TaskListView : View {
    @ObservedObject var viewModel : habitTrackerViewModel
    let cardIdealHeight = 80
    let cardMaxHeight = 160
    @State var tappedOne : String = ""
    var body : some View {
        VStack{
            GeometryReader{ metric in
                ScrollView(showsIndicators : false) {
                    LazyVStack{
                        ForEach(viewModel.getHabits(), id: \.self.name) { habit in
                            VStack{
                                HStack(alignment: .top){
                                        Circle().fill(Color("ListIndicatorColor"))
                                            .frame(width: 32, height: 32)
                                            .onTapGesture {
                                                withAnimation(.spring()){
                                                    tappedOne = ""
                                                }
                                            }
                                            .innerShadow(using: Circle(),width: 1, blur: 1.3)
                                    
                                    Text("\(habit.name)")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary.opacity(0.6))
                                        .lineLimit(2)
                                        .frame(idealWidth: metric.size.width * 0.7, maxWidth: metric.size.width * 0.7, alignment: .leading)
                                    Spacer()
                                }
                                if(tappedOne == habit.name) {
                                    Divider()
                                }
                                Spacer()
                                
                            }
                            .frame(maxWidth: .infinity, idealHeight: tappedOne != habit.name ? CGFloat(cardIdealHeight) : CGFloat(cardIdealHeight * 2), maxHeight: tappedOne != habit.name ? CGFloat(cardMaxHeight) :
                                CGFloat(cardMaxHeight * 2))
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: Color("Shadow"), radius: 2, x: 0, y: 1)
                                .onTapGesture {
                                    //print("animation4")
                                    withAnimation(.spring()){
                                        tappedOne = habit.name
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.6), lineWidth: 1).offset(y :1).blur(radius: 0).mask(RoundedRectangle(cornerRadius: 15))
                                )
                                .padding()
                                
                        }
                    }
                    
                }
            }
        }.font(.title)
    }
}

struct ContentView_Previews1: PreviewProvider {
    static let overalViewModel = habitTrackerViewModel()
    
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        ContentView(viewModel : overalViewModel).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

