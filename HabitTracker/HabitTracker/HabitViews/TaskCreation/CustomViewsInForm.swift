//
//  CustomDivider.swift
//  HabitTracker
//
//  Created by 施炎培 on 2024/1/7.
//

import SwiftUI

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

struct leadingLongTitle : View {
    let title: String
    var body: some View {
        HStack{
            Text("\(title)").font(.system(size: 16, weight: .heavy, design: .rounded))
            Spacer()
        }.foregroundColor(.primary.opacity(0.6))
        .padding(.horizontal)
    }
}

struct leadingTitle : View {
    let title: String
    var body: some View {
        Text("\(title)").font(.system(size: 16, weight: .heavy, design: .rounded)).foregroundColor(.primary.opacity(0.6))
        .padding(.leading)
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

struct titleWithToggle : View {
    let title: String
    @Binding var isOn: Bool
    var body: some View {
        HStack(spacing: 0){
            leadingTitle(title: title)
            Spacer()
             Toggle("", isOn: $isOn)
                .toggleStyle(.switch).frame(maxWidth: 50).tint(backgroundGradientStart).scaleEffect(0.8)
        }.padding(.trailing)
    }
}

struct customDatePicker : View {
    @Binding var date: Date
    let isHourAndMin: Bool
    var body: some View {
        let dateFormater = isHourAndMin ? fmt11 : fmt10
        
        HStack{
            DatePicker(
                selection: $date,displayedComponents: [isHourAndMin ? .hourAndMinute : .date], label: {
                    
                }
            )
            .contentShape(Rectangle())
            .datePickerStyle(.compact).fixedSize()
            .padding(.leading, -8)
            .mask(RoundedRectangle(cornerRadius: 12))
            .overlay {
                    Text("\(dateFormater.string(from: date))")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(RoundedRectangle(cornerRadius: 8).fill(.gray.lighter(by: 40)))
                        .allowsHitTesting(false)
                
            }
            Spacer()
            
        }.padding(.leading)
    }
}

struct Line:Shape{
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

struct DashLine: View {
    let color: Color
    let height: CGFloat
    var body: some View {
        Line()
            .stroke(style: .init(dash: [20]))
            .foregroundStyle(color)
            .frame(height: height)
    }
}

struct CustomDivider: View {
    let height: CGFloat = 2
    var isSecondary = false
    var body: some View {
        if !isSecondary {
            DashLine(color: .gray.opacity(0.24), height: height)
        } else {
            VStack{
            }
            .frame(maxWidth: .infinity).frame(height: 2)
            .background(.gray.opacity(isSecondary ? 0.12 : 0.24))
            .cornerRadius(1, corners: .allCorners)
            .padding(.horizontal)
            .padding(.leading, isSecondary ? 24 : 0)
        }
    }
}




struct CustomFormViews_Previews: PreviewProvider {
    static var previews: some View {
        CreatTaskForm(viewModel: HabitViewModel.shared)
    }
}