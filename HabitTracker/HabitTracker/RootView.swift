//
//  ContentView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/4/20.
//

import SwiftUI
import CoreData



struct RootView: View {
    //@Environment(\.managedObjectContext) private var viewContext
/*
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
 */
    //custom added code
    
    init(viewModel: habitTrackerViewModel){
        self.viewModel = viewModel
        print("fjksjfjs")
    }
    @ObservedObject var viewModel : habitTrackerViewModel
    //@Environment(\.scenePhase) var scenePhase
    @State private var tabIndex: Int = 1
    @State private var zoomBg: Bool = true
    @State private var blurEverything: Bool = false
    //Controls the create form
    let pub = NotificationCenter.default
        .publisher(for: NSNotification.Name.NSCalendarDayChanged)
    //static let gradientStart = Color(red: 251.0 / 255, green: 231.0 / 255, blue: 223.0 / 255)
    //static let gradientEnd = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 160.0 / 255)
    var body: some View {
        ZStack{
            ZStack{
                DefaultIslandBackgroundView(tabIndex: $tabIndex, zoom: $zoomBg)
                    //.ignoresSafeArea(edges: [.bottom,.top])
                    .zIndex(0)
                
                VStack(spacing: 0){
                    VStack{
                        DateSwipeBar(viewModel: viewModel)
                        if tabIndex == 1 {
                                //.transition(.slide)
                            TaskListView(viewModel: viewModel)
                                //.transition(.slide)
                        }
                        if tabIndex == 2 {
                            //Example3()
                            Spacer()
                        }
                        //Divider().padding().frame(height: 4.0)
                        //Spacer()
                        
                        //Spacer()
                    }
                    .animation(.easeInOut(duration: 0.3), value: tabIndex)
                    
                    Divider()
                    //Bottom Tab View
                    HStack{
                        Button{tabIndex = 1
                            zoomBg = true} label: {Text("habits")}
                        Button{tabIndex = 2
                            zoomBg = false
                        } label: {Text("check in")}
                    }
                    .frame(idealWidth: .infinity, maxWidth: .infinity)
                    .padding()
                    .frame(height: 88)
                    .background(tabIndex == 1 ? Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255).opacity(0.6) : Color(red: 235.0 / 255, green: 235.0 / 255, blue: 235.0 / 255).opacity(0.6))
                    
                    .background(.ultraThinMaterial)
                    .frame(alignment: .bottom)
                    .animation(.easeInOut(duration: 1.0), value: tabIndex)
                    //.cornerRadius(40, corners: [.topLeft, .topRight])
                    //.shadow(color: Color("Shadow"), radius: 5, x: 0, y: 1)
                    
                }.zIndex(1)
                .ignoresSafeArea(edges: [.bottom])
                .onReceive(pub) { (output) in
                    print("received")
                    viewModel.refreshDate()
                }
            }.blur(radius: blurEverything ? 3.0 : 0.0)
            PopupView().zIndex(2)
        }.animation(.easeInOut(duration: 0.4), value: tabIndex)
                        /*.onChange(of: scenePhase) { scenePhase in
        switch scenePhase {
            case .active: print("ScenePhase: active")
            case .background: print("ScenePhase: background")
            case .inactive: print("ScenePhase: inactive")
            @unknown default: print("ScenePhase: unexpected state")
        }
    }
             */
               
            
        //.preferredColorScheme(.dark)
        }
        
    
        
            
        /*NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }*/
        
    }







struct ContentView_Previews: PreviewProvider {
    static let overalViewModel = habitTrackerViewModel()
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        RootView(viewModel : overalViewModel)//.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

