//
//  GlobalPopupView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/10.
//

import SwiftUI



struct SwiftUIGlobalPopupView: View {
    static let ANIMATION_DURATION = 0.3
    @StateObject var popupMgr = SwiftUIGlobalPopupManager.shared
    @State var popped = false
    var scaleAnchor: UnitPoint {
        switch popupMgr.popupSide {
        case .down:
                .top
        case .up:
                .bottom
        case .center:
                .center
        }
    }
    var body: some View {
        ZStack {
            //I used this instead of just a VStack with onTapGesture because: SwiftUI detects I am using a transparent view, and it auto pass the touch down. Which is not what I want. If were to switch back to swiftui, I need to address this and also enable long tap and drag gesture to cancel the popUp as well.
            if popupMgr.showPopup {
                PopupBackground_Wrapper()
            }
            
            GeometryReader {frame in
                VStack{}.onAppear{
                    popupMgr.setContainerFrame(frame.frame(in: .global))
                }
            }
            //.background(.red)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .contentShape(Rectangle())
            .onTapGesture {
                let popupMgr = SwiftUIGlobalPopupManager.shared
                // Centered Popup will have its own close button, so we don't need to close it here.
                if popupMgr.popupSide != .center {
                    popupMgr.hidePopup(reason: "touched outside")
                }
            }
            
            VStack {
                if popupMgr.popupSide == .center, let popupPosition = popupMgr.popupPosition {
                    popupMgr.popupView
                        .padding(POPUP_PADDING / 2)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: .gray.opacity(0.4), radius: 48)
                        .offset(x: 0, y: (!popped) ? 150 : 0)
                        .position(popupPosition)
                        .opacity(popped ? 1 : 0)
                        .onAppear {
                            popped = true
                        }
                        .onChangeCustom(of: popupMgr.showPopup) {
                            popped = popupMgr.showPopup
                        }
                        .animation(.default, value: popped)
                        .allowsHitTesting(popupMgr.showPopup)
                } else {
                    let spacerBGColor = Color.clear
                    //Color.red
                    if let popupPosition = popupMgr.popupPosition, let srcPosition = popupMgr.sourceFrame?.origin, let popupSize = popupMgr.popupSize {
                        if(popupMgr.popupSide == .down) {
                            Spacer()
                                .frame(width:10, height: popupPosition.y - popupSize.height / 2)
                                .background(spacerBGColor)
                        } else {
                            Spacer()
                        }
                        HStack {
                            Spacer()
                                .frame(width: popupPosition.x - popupSize.width / 2, height: 10)
                                .background(spacerBGColor)
                            SwiftUIPopupWrapper{
                                popupMgr.popupView
                            }
                            .onTapGesture {
                                //This is just to prevent the tap gesture inside popup from being passed to the background view.
                            }
                                //.contentShape(Rectangle())
                                .scaleEffect(!popped ? 0.3 : 1, anchor: scaleAnchor)
                                //This position modifier should always follow scaleEffect, otherwise the anchor will be messed up.
                                .opacity(popped ? 1 : 0)
                                .onAppear {
                                    popped = true
                                }
                                .onChangeCustom(of: popupMgr.showPopup) {
                                    popped = popupMgr.showPopup
                                }
                                .animation(.spring(duration: SwiftUIGlobalPopupView.ANIMATION_DURATION, bounce: 0.5), value: popped)
                                .allowsHitTesting(popupMgr.showPopup)
                                
                            Spacer()
                        }
                        
                        if(popupMgr.popupSide == .up) {
                            Spacer()
                                .frame(width: 10, height: popupMgr.containerFrame.maxY - popupPosition.y - popupSize.height / 2)
                                .background(spacerBGColor)
                        } else {
                            Spacer()
                        }
                    }
                }
            }.ignoresSafeArea()
        }
        //This is to destroy the popupView when it is not shown, AFTER the animation is done. Because I ran into a bug, when the popup trigger and dismiss keyboard, if it is still there, then when it disappears, it will dismiss keyboard again even it is not the first responder.
        .onChangeCustom(of: popped) {
            if(!popped) {
                DispatchQueue.main.asyncAfter(deadline: .now() + SwiftUIGlobalPopupView.ANIMATION_DURATION) {
                    if(!popped) {
                        popupMgr.popupView = AnyView(EmptyView())
                        popupMgr.objectWillChange.send()
                    }
                }
            }
        }
    }
}


struct MeasuredButton<Content: View>: View {
    typealias Action = (CGRect) -> Void
    @State private var frame: CGRect = .zero
    let callback: Action
    let content: Content
    
    init(action:@escaping Action, @ViewBuilder content: () -> Content) {
        self.callback = action
        self.content = content()
    }
    
    var body: some View {
        return Button(action: {
            self.callback(self.frame)
        }) {
            content
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .preference(key: FramePreferenceKey.self,
                                value: geo.frame(in: CoordinateSpace.global))
            }
        )
        .onPreferenceChange(FramePreferenceKey.self) { value in
            self.frame = value
        }
    }
}

class PopupBackgroundViewController: UIViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let popupMgr = SwiftUIGlobalPopupManager.shared
        // Centered Popup will have its own close button, so we don't need to close it here.
        if popupMgr.popupSide != .center {
            popupMgr.hidePopup(reason: "touched outside uikit")
        }
    }
}


@MainActor
struct PopupBackground_Wrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = PopupBackgroundViewController()
        vc.view.backgroundColor = .clear
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //uiViewController.view.isHidden = HabitTrackerViewModel.shared.tabIndex != .initial
    }
    
    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        uiViewController.view.isHidden = true
    }
}

struct GlobalPopupView_Previews: PreviewProvider {
    static let overalViewModel = TaskMasterViewModel.shared
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        RootView(viewModel : overalViewModel)//.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
