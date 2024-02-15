//
//  GlobalPopupView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/2/10.
//

import SwiftUI

struct GlobalPopupView: View {
    @StateObject var popupMgr = GlobalPopupManager.shared
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
            VStack {
                if let popupPosition = popupMgr.popupPosition, let srcPosition = popupMgr.sourceFrame?.origin {
                    popupMgr.popupView
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: .gray.opacity(0.3), radius: 24)
                        .scaleEffect(popped ? 1 : 0.3, anchor: scaleAnchor)
                    //This position modifier should always follow scaleEffect, otherwise the anchor will be messed up.
                        .position(popupPosition)
                        .opacity(popped ? 1 : 0)
                        .onAppear {
                            popped = true
                        }
                        .onChangeCustom(of: popupMgr.showPopup) {
                            popped = popupMgr.showPopup
                        }
                        .animation(.spring(duration: 0.3, bounce: 0.5), value: popped)
                        .allowsHitTesting(popupMgr.showPopup)
                }
            }.ignoresSafeArea()
            GeometryReader {frame in
                VStack{}.onAppear{
                    popupMgr.setContainerFrame(frame.frame(in: .global))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
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

struct FramePreferenceKey: PreferenceKey {
    typealias Value = CGRect
    static var defaultValue: Value = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}


class PopupBackgroundViewController: UIViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        GlobalPopupManager.shared.hidePopup(reason: "touched outside")
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
