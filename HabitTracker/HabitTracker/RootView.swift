//
//  ContentView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/4/20.
//

import SwiftUI
import CoreData
import UIKit

let TAB_BAR_HEIGHT: CGFloat = 88

//let backgroundGradientStart = Color(hex: 0xba5370).lighter(by: 30)
//let backgroundGradientEnd = Color(hex: 0xf4e2d8)

let backgroundGradientStart = Color(red: 242.0 / 255, green: 173.0 / 255, blue: 182.0 / 255)
let backgroundGradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255).lighter(by: 15)
    
    let emptyView = Text("dskfs")
    @MainActor
    let tabView_hostingController = {
        let res = UITabBarController()
        
        res.setViewControllers([goalView_hostingController, taskView_hostingController, checkInView_hostingController, statisticalView_hostingNavigationController,
                                settingView_hostingController], animated: true)
        res.selectedIndex = 0
        res.tabBar.isHidden = true
        return res
    } ()

    let projectView = ProjectViews()
    @MainActor
    let goalView_hostingController =  {
        let res = CustomHostingViewController(rootView: projectView)
        res.view.backgroundColor = .clear
        //res.view.isHidden = false
        return res
    }()

    let taskView = InitView()
    @MainActor
    let taskView_hostingController =  {
        let res = CustomHostingViewController(rootView: taskView)
        res.view.backgroundColor = .clear
        //res.view.isHidden = false
        return res}()

    let checkInView = Text("checkIn")
    @MainActor
    let checkInView_hostingController =  {
        let res = CustomHostingViewController(rootView: checkInView)
        res.view.backgroundColor = .clear
        //res.view.isHidden = false
        return res}()

    let settingView = Text("setting")
    @MainActor
    let settingView_hostingController =  {
        let res = CustomHostingViewController(rootView: settingView)
        res.view.backgroundColor = .clear
        //res.view.isHidden = false
        return res}()
    @MainActor
    let statisticalView = StatisticalView()
    @MainActor
    let statisticalView_hostingController = {
        let res = UIHostingController(rootView: statisticalView)
        res.view.backgroundColor = .clear
        return res
    }()
    @MainActor
    let statisticalView_hostingNavigationController = {
        let res = CustomNavigationViewController(rootViewController: statisticalView_hostingController)
        res.view.backgroundColor = .clear
        res.view.isHidden = true
        return res
    }()






struct RootView: View {
    //@Environment(\.managedObjectContext) private var viewContext
/*
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
 */
    @StateObject var viewModel : TaskMasterViewModel
    //@Environment(\.scenePhase) var scenePhase
    @State private var tabIndex: AppTabShowType = .goals {
        
        didSet {
            if tabIndex == .goals {
                tabView_hostingController.selectedIndex = 0
            }
            else if tabIndex == .habits {
                tabView_hostingController.selectedIndex = 1
            }
            else if tabIndex == .checkIn {
                //statisticalView_hostingNavigationController.view.transitionView(hidden: tabIndex != .statistical)
                tabView_hostingController.selectedIndex = 2
            }
            
            else if tabIndex == .statistical {
                //statisticalView_hostingNavigationController.view.transitionView(hidden: tabIndex != .statistical)
                tabView_hostingController.selectedIndex = 3
            }
            
            else if tabIndex == .setting {
                //statisticalView_hostingNavigationController.view.transitionView(hidden: tabIndex != .statistical)
                tabView_hostingController.selectedIndex = 4
            }
            //tabView_hostingController.setViewControllers([statisticalView_hostingController, initView_hostingController,], animated: true)
            viewModel.tabIndex = tabIndex
            /*
            
            //statisticalView_hostingNavigationController.view.transitionView(hidden: tabIndex != .statistical)
            
            if tabIndex != .statistical //&& statisticalViewCache?.window != nil
            {
                if let superView = statisticalViewCache?.superview {
                    statisticalSuperViewCache = superView
                }
                statisticalViewCache?.removeFromSuperview()
            }
            else {
                if statisticalViewCache?.window == nil {
                    statisticalSuperViewCache.addSubview(statisticalViewCache ?? UILabel())
                }
            }
             */
            /*
            Task.detached(priority: .low) {
                print("dbsjdhsjhf\(await statisticalViewCache?.isUserInteractionEnabled)")
                for sub in await statisticalViewCache?.subviews ?? [] {
                    if await !sub.isUserInteractionEnabled {
                        print("dbsjdhsjhf\(await sub.isUserInteractionEnabled)")
                    }
                }
            }
        */
            /*
            statisticalView_hostingNavigationController.view.superview?.isUserInteractionEnabled = tabIndex == .statistical
            statisticalView_hostingNavigationController.view.transitionView(hidden: tabIndex != .statistical)
            statisticalView_hostingNavigationController.view.isHidden = tabIndex != .statistical
             */
        }
    }
    @State private var zoomBg: Bool = true
    //Controls the create form
    let pub = NotificationCenter.default
        .publisher(for: NSNotification.Name.NSCalendarDayChanged)
    //static let gradientStart = Color(red: 251.0 / 255, green: 231.0 / 255, blue: 223.0 / 255)
    //static let gradientEnd = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 160.0 / 255)
    
    
    var body: some View {
        
        
        VStack {
            ZStack{
                ZStack{
                    DefaultIslandBackgroundView(tabIndex: $tabIndex, zoom: $zoomBg).drawingGroup().ignoresSafeArea()
                        
                    
                    VStack{}.frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea().background(.regularMaterial).opacity(tabIndex == .statistical ? 1.0 : 0.0).animation(.easeIn(duration: 0.2), value: tabIndex)
                    
                    
                
                    TabView_Wrapper().ignoresSafeArea()
                    //.animation(.easeInOut(duration: 0.3), value: tabIndex)
                    
                    VStack(spacing: 0) {
                        Spacer()
                        Divider()
                        //Bottom Tab View
                        HStack{
                            Button{
                                hideCurrentVCAndShowNext(target: .goals)
                                zoomBg = true
                            } label: {Text("projects")}
                            Button{
                                hideCurrentVCAndShowNext(target: .habits)
                                //tabIndex = .initial
                                zoomBg = true
                                
                            } label: {Text("habits")}
                            Button{
                                hideCurrentVCAndShowNext(target: .checkIn)
                                //tabIndex = .checkIn
                                zoomBg = false
                            } label: {Text("check in")}
                            
                            Button{
                                hideCurrentVCAndShowNext(target: .statistical)
                                //tabIndex = .statistical
                                //zoomBg = true
                            } label: {Text("statistics")}
                            
                            Button{
                                hideCurrentVCAndShowNext(target: .setting)
                                //tabIndex = .setting
                                zoomBg = true
                            } label: {Text("setting")}
                        }
                        .padding()
                        .frame(height: TAB_BAR_HEIGHT)
                        .frame(maxWidth: .infinity)
                        .background(tabIndex == .habits ? backgroundGradientEnd.opacity(0.6) : Color(red: 235.0 / 255, green: 235.0 / 255, blue: 235.0 / 255).opacity(0.6))
                        .background(.ultraThinMaterial)
                        .frame(alignment: .bottom)
                        .animation(.easeInOut(duration: 1.0), value: tabIndex)
                    }
                    
                    //.cornerRadius(40, corners: [.topLeft, .topRight])
                    //.shadow(color: Color("Shadow"), radius: 5, x: 0, y: 1)
                    
                }.zIndex(1)
                    .ignoresSafeArea(edges: [.bottom])
                    .onReceive(pub) { (output) in
                        print("received")
                        viewModel.refreshDate()
                    }
                //.blur(radius: viewModel.blurEverything ? 20.0 : 0.0)
                    .disabled(viewModel.blurEverything ? true : false)
                VStack {
                    PopupView()
                }.zIndex(2)
                
                GlobalPopupView().zIndex(3) 
            }
            
        }.animation(.easeInOut(duration: 1.0), value: tabIndex)
            .animation(.easeInOut(duration: POPUP_ANIMATION_DURATION), value: viewModel.blurEverything)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
                        /*.onChange(of: scenePhase) { scenePhase in
        switch scenePhase {
            case .active: print("ScenePhase: active")
            case .background: print("ScenePhase: background")
            cashabit.timeProgress = re .inactive: print("ScenePhase: inactive")
            @unknown default: print("ScenePhase: unexpected state")
        }
    }
        */
        //.preferredColorScheme(.dark)
        
        
    
        
            
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

extension RootView {
    func hideCurrentVCAndShowNext(target: AppTabShowType) {
        if tabIndex == target {
            return
        }
        switch tabIndex {
        case .goals:
            goalView_hostingController.view.transitionView(hidden: true, completion: {
                tabIndex = target
            })
        case .habits:
            taskView_hostingController.view.transitionView(hidden: true, completion: {
                tabIndex = target
            })
        case .checkIn:
            checkInView_hostingController.view.transitionView(hidden: true, completion: {
                tabIndex = target
            })
        case .statistical:
            statisticalView_hostingNavigationController.view.transitionView(hidden: true, completion: {
                tabIndex = target
            })
        case .setting:
            settingView_hostingController.view.transitionView(hidden: true, completion: {
                tabIndex = target
            })
            
            
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static let overalViewModel = TaskMasterViewModel.shared
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        RootView(viewModel : overalViewModel)//.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


