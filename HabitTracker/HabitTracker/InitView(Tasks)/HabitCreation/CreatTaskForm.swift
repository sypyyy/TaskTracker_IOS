//
//  CreateHabitForm.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/14.
//

import SwiftUI
import Combine



extension UIPickerView {
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric , height: 150)
    }
}

struct CreatTaskForm: View {
    @StateObject var viewModel : HabitViewModel

    @State var name: String = ""
    @State var detail: String = ""
    @State var habitType: String = "Checkbox"
    @State var cycle: String = "Daily"
    @State var targetNumber: Int = 1
    @State var targetUnit: String = ""
    @State var targetHour: Int = 1
    @State var targetMinute: Int = 0
    @State var setTarget: Bool = true
    @State var indicatorColor: Color = Color(UIColor(backgroundGradientStart).darker(by: 0))
    @State var showNumberPicker: Bool = false
    @State var showTimePicker: Bool = false
    @State var showAlert = false
    @State var taskType: TaskType = .todo
    var body: some View {
        BottomSheetView{
            ZStack{
                VStack{
                    MeasuredButton(action: {frame in
                        let view = CreateNewOptionPopup()
                        print("source frame\(frame)")
                        SwiftUIGlobalPopupManager.shared.showPopup(view: AnyView(view), sourceFrame: frame, center: false)
                    }) {
                        Image(systemName: "plus").navBarSystemImageButtonModifier()
                            
                    
                    }
                    VStack{
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width:60,height:6).padding(.top, 12)
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    
                    ScrollView{
                        VStack{
                            HStack(spacing: 0){
                                Text("Add a new ")
                                    .padding(.vertical)
                                    .padding(.leading)
                                
                                CustomSegmentedControl(optionLabels: [{ selected in
                                    Text("to-do")
                                }, { selected in
                                    Text("habit")
                                }]) {selectionInt in
                                    if selectionInt == 0 {
                                        taskType = .todo
                                    }
                                    if selectionInt == 1 {
                                        taskType = .habit
                                    }
                                }
                                .frame(maxWidth: 150)
                                .padding(.trailing, 6)
                                Image(systemName: "questionmark.circle").font(.system(size: 18))
                                    .foregroundColor(.primary.opacity(0.3))
                                Spacer()
                                
                            }.font(.system(size: 22, weight: .bold, design: .rounded))
                                .foregroundColor(.primary.opacity(0.7))
                            
                            Spacer()
                        }
                        
                        if(taskType == .habit) {
                            CreatHabitForm(viewModel: viewModel,  targetNumber: $targetNumber, targetHour: $targetHour, targetMinute: $targetMinute, indicatorColor: $indicatorColor, showNumberPicker: $showNumberPicker,
                                           showTimePicker: $showTimePicker,
                                           showAlert: $showAlert)
                        }
                        
                        if(taskType == .todo) {
                            CreatTodoForm()
                        }
                        
                    }.scrollIndicators(.hidden)
                    
                }.foregroundColor(.primary.opacity(0.4))
                    .animation(.easeOut, value: habitType)
                    .animation(.easeOut, value: setTarget)
                //.blur(radius: (showTimePicker || showNumberPicker) ? 2.0 : 0.0)
                    .disabled((showTimePicker || showNumberPicker))
                /*
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                    }
                 */
                //.adaptsToKeyboard()
                if(showNumberPicker) {
                    numberPickerPopupView(title: "Set target to", minimum: 1, number: $targetNumber, onDoneDidTap: {_ in
                        showNumberPicker = false
                    })
                }
                
                if(showTimePicker) {
                    timePickerPopupView(title: "Set target to", hour: $targetHour, minute: $targetMinute, onDoneDidTap: { _,_ in
                        showTimePicker = false
                    })
                }
                AlertWrapperView(show: $showAlert){
                    Text("Please enter habit's name")
                }
            }
        }.animation(.easeOut, value: showNumberPicker)
            .animation(.easeOut, value: showTimePicker)
            .animation(.easeOut, value: taskType)
        
    }
}
    
    
    
    
    /*
    struct inputNumberField : View {
        let title: String
        @Binding var text: String
        var body: some View {
            HStack{
                Text(" ")
                TextField("\(title)", text: $text)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .keyboardType(.numberPad)
                                .onReceive(Just(text)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        self.text = filtered
                                    }
                                }
                Text(" ")
            }
            .padding(.vertical)
            .innerShadow(using: RoundedRectangle(cornerRadius: 10), color: .black.opacity(0.7),width: 2, blur: 2)
        }
    }
     */
    
    

struct CreatTaskForm_Previews: PreviewProvider {
    static var previews: some View {
        CreatTaskForm(viewModel: HabitViewModel.shared)
    }
}


