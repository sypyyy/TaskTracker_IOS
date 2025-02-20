//
//  CreateNewOptionPopup.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/12/23.
//

import SwiftUI

struct CreateNewOptionPopup: View {
    var options: [CreateOptions] = [.task, .event, .habit]
    
    var body: some View {
        let width: CGFloat = 150
        ZStack {
            /*
            VStack(spacing: 0){
                RoundedRectangle(cornerRadius: 10)
                    //.fill(selectedPriority.color.opacity(0.2))
                    .frame(width: width, height: rowHeight)
                    //.offset(y: rowHeight * CGFloat(options.firstIndex(of: selectedPriority) ?? 0))
                Spacer()
            }
            */
            VStack(spacing: 0) {
                ForEach(options, id: \.self.rawValue) { option in
                    Button(action: {
                        switch option {
                        case .task:
                            
                            ContainerViewComposer.sharedContainerVC.showBottomSheet(snapPoints: [.AlmostFull], background: .blur(style: .systemThinMaterialLight), viewType: .viewController(TodoFastCreatViewController(mode: .create)))
                        case .event:
                            break
                        case .habit:
                            break
                        }
                        SwiftUIGlobalPopupManager.shared.hidePopup(reason: "moved on to create new")
                    }, label: {
                        HStack {
                            option.iconImage
                            /*
                            Group {
                                if(priority == .none) {
                                    Image(systemName: "flag.slash.fill")
                                } else {
                                    Image(systemName: "flag.fill")
                                }
                            }
                            .foregroundColor(priority.color)
                            
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                            
                            */
                            Text(option.description)
                               
                            Spacer()
                        }
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.primary.opacity(0.6))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 12)
                        //.frame(height: rowHeight)
                        
                    })
                }
            }
        }
        .frame(width: width)
        //.frame(height: rowHeight * CGFloat(options.count))
       
    }
}

struct CreateNewOptionPopup_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            CreateNewOptionPopup()
                .background(.thinMaterial)
        }
    }
}
