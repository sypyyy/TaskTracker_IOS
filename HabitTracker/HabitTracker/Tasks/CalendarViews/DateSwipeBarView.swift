//
//  TopDateSwipeBarView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/13.
//

import SwiftUI

@MainActor
class dateListManager: ObservableObject {
    static var shared = dateListManager()
    let viewModel: MasterViewModel
    var dates: [Date]
    
    init() {
        self.viewModel = MasterViewModel.shared
        let date = viewModel.getStartDate()
        dates = [viewModel.getStartDate()]
        for i in 1...400 {
            dates.append((Calendar.current.date(byAdding: .day, value: i, to: date)!))
        }
        print("restarted here")
    }
    
    func forceUpdate() {
        objectWillChange.send()
    }
    func addMoreDates() {
        let date = dates.last!
        for i in 1...7 {
            dates.append((Calendar.current.date(byAdding: .day, value: i, to: date)!))
        }
        print(dates)
        forceUpdate()
    }
    
}


struct DateSwipeBar : View {
    @StateObject var viewModel : MasterViewModel = MasterViewModel.shared
    @StateObject var dateListMgr = dateListManager.shared
    @State var chosenDate = MasterViewModel.shared.selectedDate
    @State var loaded = false
    
    
   
   /*
    init(viewModel: habitTrackerViewModel) {
        self.viewModel = viewModel
        if dates.isEmpty {
            var res = [Date]()
            var date = viewModel.getStartDate() // first date
            let endDate = Calendar.current.date(byAdding: .day, value: 4, to: viewModel.getTodayDate())! // last date
            while date <= endDate {
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                res.append(date)
            }
            dates = res
            
        }
    }
*/
    
    private func isToday(_ date: Date) -> Bool {
        fmt.string(from: viewModel.getTodayDate()) == fmt.string(from: date)
    }
    
    private func isYesterday(_ date: Date) -> Bool {
        if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: viewModel.getTodayDate()) {
            return fmt.string(from: yesterday) == fmt.string(from: date)
        }
        return false
    }
    
    private func isTomorrow(_ date: Date) -> Bool {
        if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: viewModel.getTodayDate()) {
            return fmt.string(from: tomorrow) == fmt.string(from: date)
        }
        return false
    }
   
    private func isThisYear(_ date: Date) -> Bool {
        return fmt3.string(from: viewModel.getTodayDate()) == fmt3.string(from: date)
    }
    
    private func getTopDateText(_ date: Date) -> String {
        if(isToday(date)) {
            return "Today"
        }
        if(isYesterday(date)) {
            return "Yesterday"
        }
        if(isTomorrow(date)) {
            return "Tomorrow"
        }
        if(isThisYear(date)) {
            return fmt4.string(from: date)
        }
        return fmt5.string(from: date)
    }
        
    var body : some View {
            VStack{
                HStack{
                    Button(action: {
                        //viewModel.showCreateForm.toggle()
                        //LeftSideBarViewModel.shared.isShowLeftSideBar.toggle()
                        SideMenuViewController.shared.show()
                    }) {
                        Image(systemName: "line.3.horizontal").navBarSystemImageButtonModifier()
                    }
                    
                    //.shadow(color: Color("Shadow"), radius: 2, x: 0, y: 0)
                    //.overlay(
                        //RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.6), lineWidth: 1).offset(y :1).blur(radius: 0).mask(RoundedRectangle(cornerRadius: 15))
                    //)
                    .padding(.horizontal)
                    Spacer()
                    Text("\(getTopDateText(chosenDate))").font(.system(size: 16, weight: .heavy, design: .rounded))
                    Spacer()
                    Button(action: {viewModel.showCreateForm.toggle()}) {
                        Text("...").font(.system(size: 16, weight: .heavy, design: .rounded))
                            .padding(.horizontal)
                            .padding(.vertical, 6.0)
                            .background(.regularMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                            .shadow(color: Color("Shadow"), radius: 2, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(1), lineWidth: 1).offset(y :1).blur(radius: 0).mask(RoundedRectangle(cornerRadius: 15))
                            )
                            .padding(.horizontal)
                    }
                    .sheet(isPresented: $viewModel.showCreateForm){
                        //Text("just testing")
                        BottomSheetView{CreatTaskForm(viewModel: HabitViewModel.shared)}
                    }
                }.foregroundColor(.primary.opacity(0.6))
                HStack{
                    if loaded {
                        ScrollViewReader { v in
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: -7) {
                                    ForEach(dateListMgr.dates, id: \.self) {date in
                                        let isToday = fmt.string(from: date) == fmt.string(from: viewModel.getTodayDate())
                                        VStack(spacing: 0.0){
                                            Text("\(fmt1.string(from: date))").font(.system(size: 16, weight: isToday ? .heavy : .bold, design: .rounded))
                                            Text("\(fmt2.string(from: date))").font(.system(size: 16, weight: isToday ? .regular : .light, design: .rounded))
                                        }.foregroundColor(isToday ? .primary.opacity(0.6) : .secondary)
                                            .padding()
                                            
                                        .background {
                                            /*
                                             fmt.string(from: date) == fmt.string(from: viewModel.getTodayDate())
                                             */
                                            if fmt.string(from: date) == fmt.string(from: chosenDate) {
                                                
                                                    RoundedRectangle(cornerRadius: 20, style: .circular)
                                                    .fill(backgroundGradientStart.darker(by: 6))
                                                        .saturation(1.2)
                                                        
                                                
                                            }
                                            
                                        }
                                        .frame(height: 50)
                                        .onAppear(){
                                            let idx: Int = dateListMgr.dates.count - 2
                                            if idx >= 0 {
                                                let last = dateListMgr.dates[idx]
                                                if(fmt.string(from: last) == fmt.string(from: date)) {
                                                    dateListMgr.addMoreDates()
                                                 }
                                            } else if let last = dateListMgr.dates.last {
                                                print("this is last\(last)")
                                                print("this is last\(date)")
                                                if(fmt.string(from: last) == fmt.string(from: date)) {
                                                    dateListMgr.addMoreDates()
                                                 }
                                            }
                                        }
                                        .onTapGesture {
                                            let x = date.startOfWeek()
                                            let y = date.endOfWeek()
                                            print("dsdsddsede\(fmt5.string(from: x))")
                                            print("dsdsddsede\(fmt6.string(from: x))")
                                            print("dsdsddsede\(fmt5.string(from: y))")
                                            print("dsdsddsede\(fmt6.string(from: y))")
                                            //print("animation2")
                                            withAnimation(){
                                                v.scrollTo(date, anchor: .center)
                                                chosenDate = date
                                            }
                                                viewModel.selectDate(date: date)
                                            
                                        }
                                    }
                                }
                            }
                            .frame(maxHeight: 90)
                            .onAppear{
                                v.scrollTo(viewModel.getTodayDate(), anchor: .center)
                                print("sypppfdfsfsfdfdfs1")
                            }
                            .onDisappear{
                                print("kdskfmslkfslkfsmklfmms")
                            }
                        }
                    }
                    else {
                        HStack{}.frame(height: 90).task {
                            await loadDates()
                        }
                    }
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                    })
                }
                
                
                HStack {
                    
                    /*
                    HStack{
                        Text("Habits").foregroundColor(.primary.opacity(0.8)).font(.system(size: 18, weight: .medium, design: .rounded)).padding(.leading)
                        Text("|")
                        Text("To-do").padding(.trailing)
                    }
                    .frame(height: 40)
                    .background(.thinMaterial)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    Spacer()
                     */
                    
                }
                
                
                
                .foregroundColor(.primary.opacity(0.4)).font(.system(size: 16, weight: .regular, design: .rounded))
            }
    }
    
}


extension DateSwipeBar {
    func loadDates() async {
        Task.detached(priority: .background) { @MainActor in
            //try await Task.sleep(for: .milliseconds(100))
            loaded = true
        }
    }
}


struct DateSwipeView_Previews: PreviewProvider {
    static let overalViewModel = MasterViewModel()
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        RootView(viewModel : overalViewModel).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct InitialViewCustomSegmentedControl: View {
    @StateObject var viewModel = TaskViewSegmentedControlViewModel.shared
    @State var preselectedIndex: Int = 0
    var options: [String]
    var selectionCallBack: (Int) -> Void
    func getOpacity() -> Double {
        return 1.0 - viewModel.TaskContentOffset * 0.015
    }
    func getHeight() -> CGFloat {
        return 40 - viewModel.TaskContentOffset * 4
    }
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(.white.opacity(0.01))
                        .onTapGesture {
                            withAnimation(.easeIn(duration: 0.4)) {
                                preselectedIndex = index
                                selectionCallBack(index)
                            }
                        }
                    Rectangle()
                        .fill(backgroundGradientStart.darker(by: 6).opacity(index == preselectedIndex ? 1 : 0.0))
                        .saturation(1.2)
                        .overlay(
                            /*
                            Text(options[index]).foregroundColor(.primary.opacity(index == preselectedIndex ? 0.7 : 0.2))
                             */
                            Image(systemName: options[index]).foregroundColor(.primary.opacity(index == preselectedIndex ? 0.7 : 0.2))
                        )
                }
            }
        }
        .background(.thinMaterial)
        //.foregroundColor(.primary.opacity(0.4))
        .fontWeight(.medium)
        .frame(height: getHeight())
        .cornerRadius(10)
        .padding(.horizontal)
        .opacity(getOpacity())
    }
}

class TaskViewSegmentedControlViewModel: ObservableObject {
    static var shared = TaskViewSegmentedControlViewModel()
    @Published var TaskContentOffset: CGFloat = 0
}
