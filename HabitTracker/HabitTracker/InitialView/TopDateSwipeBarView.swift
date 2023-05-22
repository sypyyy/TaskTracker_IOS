//
//  TopDateSwipeBarView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/13.
//

import SwiftUI

struct DateSwipeBar : View {
    @ObservedObject var viewModel : habitTrackerViewModel
    var dates : [Date] {
        var date = viewModel.getStartDate() // first date
        let endDate = Calendar.current.date(byAdding: .day, value: 4, to: viewModel.getTodayDate())! // last date
        var res : [Date] = []
        while date <= endDate {
            date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            res.append(date)
        }
        return res
    }
    
    var fmt : DateFormatter {
        let res = DateFormatter()
        res.dateFormat = "yyyy/MM/dd"
        return res
    }
    var fmt1 : DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = "E"
        return fmt
    }
    var fmt2 : DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = "dd"
        return fmt
    }
    var dummy : Bool {
        //print("animation1")
        return true
    }
        
    var body : some View {
            
            VStack{
                HStack{
                    Button(action: {viewModel.showCreateForm.toggle()}) {
                        Text("-").font(.system(size: 16, weight: .heavy, design: .rounded))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6.0)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .shadow(color: Color("Shadow"), radius: 2, x: 0, y: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.6), lineWidth: 1).offset(y :1).blur(radius: 0).mask(RoundedRectangle(cornerRadius: 15))
                    )
                    .padding(.horizontal)
                    Spacer()
                    Text("Today").font(.system(size: 16, weight: .heavy, design: .rounded))
                    Spacer()
                    Button(action: {viewModel.showCreateForm.toggle()}) {
                        Text("+").font(.system(size: 16, weight: .heavy, design: .rounded))
                    }
                    .sheet(isPresented: $viewModel.showCreateForm){
                        BottomSheetView{CreateHabitForm(viewModel: viewModel)}
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6.0)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    .shadow(color: Color("Shadow"), radius: 2, x: 0, y: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(1), lineWidth: 1).offset(y :1).blur(radius: 0).mask(RoundedRectangle(cornerRadius: 15))
                    )
                    .padding(.horizontal)
                }.foregroundColor(.primary.opacity(0.6))
                ScrollViewReader{ v in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: -7) {
                            ForEach(dates,id: \.self) {date in
                                let isToday = fmt.string(from: date) == fmt.string(from: viewModel.getTodayDate())
                                VStack(spacing: 0.0){
                                    Text("\(fmt1.string(from: date))").font(.system(size: 16, weight: isToday ? .heavy : .bold, design: .rounded))
                                    Text("\(fmt2.string(from: date))").font(.system(size: 16, weight: isToday ? .regular : .light, design: .rounded))
                                }.foregroundColor(isToday ? .primary.opacity(0.7) : .secondary)
                                .padding()
                                .background {
                                    if(fmt.string(from: date) == fmt.string(from: viewModel.getTodayDate()) && dummy){
                                        withAnimation(){
                                            RoundedRectangle(cornerRadius: 20, style: .circular).fill(.pink.opacity(0.15)).shadow(color: .black.opacity(0.5), radius: 5)
                                             
                                        }
                                    }
                                }
                                .foregroundColor(.black)
                                
                                .frame(height: 50)
                                .onAppear(){
                                    /*
                                     if(dates[numbers.count - 1] == number) {
                                     numbers.append(numbers.count + 1)
                                     }
                                     print(numbers.count)
                                     */
                                    //print("date",date)
                                    
                                }
                                .onTapGesture {
                                    //print("animation2")
                                    withAnimation(){
                                        v.scrollTo(date, anchor: .center)
                                    }
                                }
                            }
                        }
                        
                    }
                    .frame(maxHeight: 90)
                    .onAppear{
                        v.scrollTo(viewModel.getTodayDate(), anchor: .center)
                    }
                    .onDisappear{
                    }
                   
                    
                }
                
            
            }
    }
    
}

func dum() -> Void {
    print("ds")
}


struct DateSwipeView_Previews: PreviewProvider {
    static let overalViewModel = habitTrackerViewModel()
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        ContentView(viewModel : overalViewModel).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
