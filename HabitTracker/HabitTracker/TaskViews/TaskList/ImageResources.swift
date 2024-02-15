//
//  Resources.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/1/28.
//

import SwiftUI

@MainActor
let imageResources = ImageResources()

@MainActor
class ImageResources {
    var archiveActionButton: UIImage
    var deleteActionButton: UIImage
    var timerActionButton: UIImage
    
    init() {
        archiveActionButton = renderArchiveIcon()
        deleteActionButton = renderDeleteIcon()
        timerActionButton = renderTimerIcon()
    }
    
    func getTimerActionButton() -> UIImage {
        return timerActionButton
    }
    
    func getArchiveActionButton() -> UIImage {
        return archiveActionButton
    }
    
    func getDeleteActionButton() -> UIImage {
        return deleteActionButton
    }
}

@MainActor
func renderArchiveIcon() -> UIImage {
    let render = ImageRenderer(content: ArchiveActionButton())
    render.scale = 3
    return render.uiImage ?? UIImage()
}

@MainActor
func renderDeleteIcon() -> UIImage {
    let render = ImageRenderer(content: DeleteActionButton())
    render.scale = 3
    return render.uiImage ?? UIImage()
}

@MainActor
func renderTimerIcon() -> UIImage {
    let render = ImageRenderer(content: TimerActionButton())
    render.scale = 3
    return render.uiImage ?? UIImage()
}

struct ArchiveActionButton: View {
    var body: some View {
        VStack{
            
        }
        .frame(width: (Estimated_Task_Card_Folded_Height / 1.55), height: Estimated_Task_Card_Folded_Height / 1.1)
        .background(.blue.lighter(by: 25).opacity(0.5))
        .cornerRadius(12, corners: .allCorners)
        .overlay{
            Image(systemName: "archivebox")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 25, height: 25)
        }
        
        .padding(.trailing, 6)
        
    }
}

struct DeleteActionButton: View {
    var body: some View {
        VStack{
            
        }
        .frame(width: (Estimated_Task_Card_Folded_Height / 1.55), height: Estimated_Task_Card_Folded_Height / 1.1)
        .background(.red.lighter(by: 35).opacity(1))
        .cornerRadius(12, corners: .allCorners)
            .overlay{
                Image(systemName: "trash")
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
            }
            
            .padding(.trailing, 6)
            
    }
}

struct TimerActionButton: View {
    var body: some View {
        VStack{
            
        }
        .frame(width: (Estimated_Task_Card_Folded_Height / 1.55), height: Estimated_Task_Card_Folded_Height / 1.1)
        //.background(Color.indigo.lighter(by: 30).saturation(1.5).opacity(0.9))
        .cornerRadius(12, corners: .allCorners)
            .overlay{
                ZStack {
                    Circle()
                        .fill(Color.indigo.lighter(by: 30).opacity(0.9)).saturation(1.5)
                        .frame(width: 45, height: 45)
                    Image(systemName: "timer")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                }
                
            }
            
            .padding(.leading, 6)
    }
}

struct ImageRes_Previews_TaskTableController: PreviewProvider {
    static let overalViewModel = TaskMasterViewModel()
    
    static var previews: some View {
        //let overalViewModel = habitTrackerViewModel()
        RootView(viewModel : overalViewModel).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
