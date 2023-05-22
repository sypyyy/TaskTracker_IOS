//
//  CreateHabitForm.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/14.
//

import SwiftUI
import Combine

struct CreateHabitForm: View {
    @ObservedObject var viewModel : habitTrackerViewModel
    @State var name: String = ""
    @State var detail: String = ""
    @State var habitType: String = "Time"
    @State var cycle: String = "Daily"
    @State var targetNumber: String = ""
    @State var targetUnit: String = ""
    @State var targetHour: Int = 1
    @State var targetMinute: Int = 31
    @State var dummy : String = ""
    var body: some View {
        BottomSheetView{
            VStack{
                VStack{
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width:60,height:6).padding(.top, 12)
                }
                ScrollView{
                    
                    VStack{
                        HStack{
                            Text("Start a new habit")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.primary.opacity(0.8))
                                .padding()
                            Spacer()
                        }
                        VStack{
                            Title(title: "Habit name")
                            inputField(title: "eg: Drink water.", text: $name).padding(.bottom)
                            Title(title: "Detail")
                            inputField(title: "", text: $detail)
                                .padding(.bottom)
                            Title(title: "Based on")
                            
                            HStack{
                                Button3D(title: "Time", activeTitle: $habitType)
                                Button3D(title: "Number", activeTitle: $habitType)
                            }
                            Title(title: "Cycle")
                            HStack{
                                Button3D(title: "Daily", activeTitle: $cycle)
                                Button3D(title: "Weekly", activeTitle: $cycle)
                                Button3D(title: "Monthly", activeTitle: $cycle)
                            }.padding(.bottom)
                            
                        }
                        VStack{
                            Title(title: "Target")
                            HStack{
                                if(habitType == "Number") {
                                    inputNumberField(title: "Number", text: $targetNumber)
                                        .frame(maxWidth: 100)
                                        .padding(.leading)
                                    
                                    inputFieldPrototype(title: "Unit", text: $targetUnit).frame(maxWidth: 100).autocapitalization(.none)
                                }
                                else {
                                    Picker("", selection: $targetHour){
                                        ForEach(0..<24, id: \.self) { i in
                                            Text("\(i) hours").tag(i)
                                        }
                                    }
                                    .frame(width: 120)
                                    .compositingGroup()
                                    .clipped()
                                    .pickerStyle(WheelPickerStyle())
                                    
                                    .padding(.leading)
                                    
                                    Picker("", selection: $targetMinute){
                                        ForEach(0..<60, id: \.self) { i in
                                            Text("\(i) min").tag(i)
                                        }
                                    }
                                    .frame(width: 120)
                                    .compositingGroup()
                                    .clipped()
                                    .pickerStyle(WheelPickerStyle())
                                    
                                }
                                Text("/").font(.system(size: 16, weight: .bold, design: .rounded))
                                switch(cycle) {
                                case "Daily": Text("day")
                                case "Weekly": Text("week")
                                case "Monthly": Text("month")
                                default: Text("day")
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                        
                    }.foregroundColor(.primary.opacity(0.4))
                        .animation(.easeOut, value: habitType)
                    Text("save")
                        .onTapGesture{
                            print("tapped")
                            viewModel.saveHabit(name: name, detail: detail, habitType: habitType, cycle: cycle, targetNumber: targetNumber, targetUnit: targetUnit, targetHour: targetHour, targetMinute: targetMinute)
                        }
                }
            }
        }
    }
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
    
    struct Button3D : View {
        let title: String
        @Binding var activeTitle: String
        var chosen: Bool {
            title == activeTitle
        }
        var body: some View {
            Text("\(title)")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .padding(.horizontal)
                .padding(.vertical, 8.0)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .shadow(color: Color("Shadow"), radius: chosen ? 0 : 2, x: 0, y: 0)
                .overlay(
                    RoundedRectangle(cornerRadius: 15).stroke(.white.opacity(0.6), lineWidth: chosen ? 0: 1).offset(y :1).blur(radius: 0).mask(RoundedRectangle(cornerRadius: 15))
                )
                .innerShadow(using: RoundedRectangle(cornerRadius: 15), color: .black.opacity(0.7),width: chosen ? 1.7 : 0, blur: 1)
                .animation(.easeIn, value: activeTitle)
                .onTapGesture {
                    activeTitle = title
                }
        }
    }
    
    struct Title : View {
        let title: String
        var body: some View {
            HStack{
                Text("\(title)").font(.system(size: 16, weight: .heavy, design: .rounded))
                Spacer()
            }.foregroundColor(.primary.opacity(0.7))
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
        var body: some View {
            HStack{
                Text(" ")
                TextField("\(title)", text: $text)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .submitLabel(.done)
                Text(" ")
            }
            .padding(.vertical)
            .innerShadow(using: RoundedRectangle(cornerRadius: 10), color: .black.opacity(0.7),width: 2, blur: 2)
        }
    }
    
    
}

struct CreateHabitForm_Previews: PreviewProvider {
    static var previews: some View {
        CreateHabitForm(viewModel: habitTrackerViewModel()).background(.blue)
    }
}


