//
//  PickerPopupView.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/6/7.
//

import Foundation
import SwiftUI

struct numberPickerPopupView: View {
    let title: String
    let minimum: Int
    @Binding var number: Int
    @State var disableSavebtn = false
    var onDoneDidTap: (Int) -> Void
    var body: some View {
        ZStack {
                VStack(spacing: 0) {
                    Text("\(title)").padding(.top, 20).font(.system(size: 20, weight: .medium, design: .rounded))
                    Picker("", selection: $number){
                        ForEach(minimum...999, id: \.self) { i in
                            Text("\(i)").tag(i)
                        }
                    }
                    .clipped()
                    .pickerStyle(WheelPickerStyle())
                    Divider()
                    Button (action:{
                        if !disableSavebtn {
                        onDoneDidTap(number)
                        disableSavebtn = true
                    }}){
                            HStack(alignment: .center){
                                Spacer()
                                Text("Done").fontWeight(.medium)
                                Spacer()
                            }
                            .padding(.top, 12)
                            .padding(.bottom, 15)
                        }
                }
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                .padding(.horizontal, 30)
            }
    }
}

struct timePickerPopupView: View {
    let title: String
    @Binding var hour: Int
    @Binding var minute: Int
    @State var disableSavebtn = false
    var onDoneDidTap: (Int, Int) -> Void
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("\(title)").padding(.top, 20).font(.system(size: 20, weight: .medium, design: .rounded))
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
            }
            .frame(maxWidth: .infinity)
            Divider()
        Button (action:{if !disableSavebtn {
                onDoneDidTap(hour, minute)
                disableSavebtn = true
            }}){
                HStack(alignment: .center){
                    Spacer()
                    Text("Done").fontWeight(.medium)
                    Spacer()
                }
                .padding(.top, 12)
                .padding(.bottom, 15)
            }
        }
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        
        .padding(.horizontal, 30)
    }
}
