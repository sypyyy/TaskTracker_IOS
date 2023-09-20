//
//  PickerPopupView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/6/7.
//

import Foundation
import SwiftUI

struct numberPickerPopupView: View {
    @Binding var number: Int
    @State var disableSavebtn = false
    var onDoneDidTap: (Int) -> Void
    var body: some View {
        ZStack {
            VStack {
                Picker("", selection: $number){
                    ForEach(1...999, id: \.self) { i in
                        Text("\(i)").tag(i)
                    }
                }
                .clipped()
                .pickerStyle(WheelPickerStyle())
                Divider()
                HStack{
                    Spacer()
                    Text("Done")
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if !disableSavebtn {
                        onDoneDidTap(number)
                        disableSavebtn = true
                    }
                }
                //.frame(width: 200)
                .padding(.bottom)
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .padding(.horizontal)
        }
    }
}

struct timePickerPopupView: View {
    @Binding var hour: Int
    @Binding var minute: Int
    @State var disableSavebtn = false
    var onDoneDidTap: (Int, Int) -> Void
    var body: some View {
        VStack {
            HStack{
                Picker("", selection: $hour){
                    ForEach(0..<24, id: \.self) { i in
                        Text("\(i) hours").tag(i)
                            
                    }
                }
                .frame(width: 120)
                //.compositingGroup()
                .clipped()
                .pickerStyle(WheelPickerStyle())
                Picker("", selection: $minute){
                    ForEach(0..<60, id: \.self) { i in
                        Text("\(i) min").tag(i)
                    }
                }
                .frame(width: 120)
                //.compositingGroup()
                .clipped()
                .pickerStyle(WheelPickerStyle())
            }
            Divider()
            HStack{
                Spacer()
                Text("Done")
                Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if !disableSavebtn {
                    onDoneDidTap(hour, minute)
                    disableSavebtn = true
                }
            }.padding(.bottom)
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .padding(.horizontal)
    }
}
