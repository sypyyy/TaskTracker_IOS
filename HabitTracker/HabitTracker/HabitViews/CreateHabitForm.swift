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

struct CreateHabitForm: View {
    @ObservedObject var viewModel : HabitTrackerViewModel
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
    var body: some View {
        BottomSheetView{
            ZStack{
                VStack{
                    VStack{
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width:60,height:6).padding(.top, 12)
                            .foregroundColor(.primary.opacity(0.7))
                    }
                    ScrollView{
                        VStack {
                            VStack{
                                HStack{
                                    Text("Start a new habit")
                                        .font(.system(size: 25, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary.opacity(0.7))
                                        .padding()
                                    Spacer()
                                }
                                VStack{
                                    leadingTitle(title: "Habit name")
                                    inputField(title: "eg: Drink water.", text: $name).padding(.bottom)
                                    leadingTitle(title: "Detail")
                                    inputField(title: "", text: $detail)
                                        .padding(.bottom)
                                    leadingTitle(title: "Track habit by")
                                    
                                    HStack{
                                        Button3D(title: "Checkbox", image: "checkmark.square", activeTitle: $habitType).padding(.leading)
                                        Button3D(title: "Time", image: "alarm", activeTitle: $habitType)
                                        Button3D(title: "Number", image: "123.rectangle", activeTitle: $habitType)
                                        Spacer()
                                    }.padding(.bottom)
                                    leadingTitle(title: "Cycle")
                                    HStack{
                                        Button3D(title: "Daily",image: "", activeTitle: $cycle).padding(.leading)
                                        Button3D(title: "Weekly", image: "", activeTitle: $cycle)
                                        Button3D(title: "Monthly", image: "", activeTitle: $cycle)
                                        Spacer()
                                    }.padding(.bottom)
                                }
                                if habitType != "Checkbox" {
                                    VStack{
                                        HStack{
                                            Title(title: "Set a target")
                                            /*
                                            Toggle("", isOn: $setTarget)
                                                .toggleStyle(.switch).frame(maxWidth: 60).tint(indicatorColor).scaleEffect(0.8)
                                             */
                                            Spacer()
                                        }
                                        if setTarget {
                                            HStack{
                                                if(habitType == "Number") {
                                                    
                                                    Button("\(targetNumber)", action: {showNumberPicker = true}).buttonHorizontal().padding(.leading)
                                                    inputFieldPrototype(title: "Unit", text: $targetUnit).frame(maxWidth: 100).autocapitalization(.none)
                                                }
                                                else {
                                                    Button("\((targetHour * 60 + targetMinute).minutesToTime())", action: {showTimePicker = true}).buttonHorizontal().padding(.leading)
                                                    /*
                                                    
                                                    */
                                                    
                                                }
                                                switch(cycle) {
                                                case "Daily": Text("/ day")
                                                case "Weekly": Text("/ week")
                                                case "Monthly": Text("/ month")
                                                default: Text("day")
                                                }
                                                Spacer()
                                            }
                                        }
                                        //Spacer()
                                    }
                                }
                            }.padding(.bottom, 30)
                            HStack{
                                Spacer()
                                Text("Save")
                                Spacer()
                            }
                            .buttonHorizontal()
                            .onTapGesture {
                                print("tapped")
                                if name == "" {
                                    showAlert = true
                                    return
                                }
                                viewModel.saveHabit(name: name, detail: detail, habitType: HabitTracker.HabitType(rawValue: habitType) ?? .simple, cycle: cycle, targetNumber: targetNumber, targetUnit: targetUnit, targetHour: targetHour, targetMinute: targetMinute, setTarget: setTarget)
                            }
                            .padding(.bottom, 30)
                        }
                    }.foregroundColor(.primary.opacity(0.4))
                    .animation(.easeOut, value: habitType)
                    .animation(.easeOut, value: setTarget)
                    //.blur(radius: (showTimePicker || showNumberPicker) ? 2.0 : 0.0)
                    .disabled((showTimePicker || showNumberPicker))
                    
                }.onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                }
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
            }.animation(.easeOut, value: showNumberPicker)
                .animation(.easeOut, value: showTimePicker)
            
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
    
    struct Button3D : View {
        let title: String
        let image: String
        @Binding var activeTitle: String
        var chosen: Bool {
            title == activeTitle
        }
        var body: some View {
            VStack{
                Text("\(title)")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    //.padding(.horizontal)
                    //.padding(.vertical, 8.0)
                    
                
                    //.overlay(
                       // RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.6), lineWidth: chosen ? 0: 1).offset(y :1).blur(radius: 0).mask(RoundedRectangle(cornerRadius: 15))
                    //)
                 
                    //.innerShadow(using: RoundedRectangle(cornerRadius: 15), color: .black.opacity(0.7),width: chosen ? 1.7 : 0, blur: 1)
                if image != "" {
                    Text("\(Image(systemName: image))").font(.system(size: 27, weight: .thin, design: .rounded))
                }
            }.padding()
            .background(chosen ? Color(UIColor(backgroundGradientStart).darker(by: 0)) : .clear)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .shadow(color: Color("Shadow").opacity(0.3), radius: 2, x: 0, y: 0)
            .padding(.horizontal, 4.0)
            .animation(.easeInOut, value: activeTitle)
            .onTapGesture {
                activeTitle = title
            }
            
        }
    }
    
    struct leadingTitle : View {
        let title: String
        var body: some View {
            HStack{
                Text("\(title)").font(.system(size: 16, weight: .heavy, design: .rounded))
                Spacer()
            }.foregroundColor(.primary.opacity(0.6))
            .padding(.horizontal)
        }
    }
    
    struct Title : View {
        let title: String
        var body: some View {
            Text("\(title)").font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundColor(.primary.opacity(0.6))
            .padding(.horizontal)
        }
    }
    
    struct inputField : View {
        let title: String
        @Binding var text: String
        var body: some View {
            inputFieldPrototype(title: title, text: $text)
            .padding(.horizontal)
        }
    }
    
    struct inputFieldPrototype : View {
        let title: String
        @Binding var text: String
        @FocusState private var isFocused: Bool
        var body: some View {
            HStack{
                Text(" ")
                TextField("\(title)", text: $text)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .submitLabel(.done)
                    .padding(.vertical)
                    .focused($isFocused)
                Text(" ")
            }
            .innerShadow(using: RoundedRectangle(cornerRadius: 10), color: .black.opacity(0.3),width: 2, blur: 2)
            .onTapGesture {
                isFocused = true
            }
        }
    }
}

struct CreateHabitForm_Previews: PreviewProvider {
    static var previews: some View {
        CreateHabitForm(viewModel: HabitTrackerViewModel.shared)
    }
}


