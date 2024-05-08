//
//  SwiftUIViewForDrawTest.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/16.
//

import SwiftUI



struct DefaultIslandBackgroundView: View {
    let IslandHeightOffSet = 100.0
    let IslandHeightFraction = 1.0
    static var whiteWaveCycle = 3
    //static let BackgroundGradientStart = Color(red: 242.0 / 255, green: 173.0 / 255, blue: 182.0 / 255)
    //static let gradientEnd1 = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    static let gradientStart = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 225.0 / 255, blue: 110.0 / 255)
    static let islandBottom = Color(red: 237.0 / 255, green: 179.0 / 255, blue: 150.0 / 255)
    static let islandTop = Color(red: 255.0 / 255, green: 198.0 / 255, blue: 171.0 / 255)
    static let water = Color(red: 15.0 / 255, green: 77.0 / 255, blue: 142.0 / 255)
    //static let water = Color(red: 242.0 / 255, green: 172.0 / 255, blue: 182.0 / 255)
    static let wave = Color(red: 206.0 / 255, green: 230.0 / 255, blue: 249.0 / 255)
    @Binding var tabIndex: AppTabShowType
    @Binding var zoom: Bool
    struct particle: Hashable {
        var x: Double
        var y: Double
        var angle: Double
        var life: Int
    }
    //Hashable?????????????????????
    var particleSet: Set<particle> = []
    var waveLine: [(x1: Double, y1: Double, x2: Double, y2: Double)] = []
    
    var particleCounter = 0
    var body: some View {
            //let width: CGFloat = metric.size.width
            //let height: CGFloat = metric.size.height
            /*
            Path { path in
                path.move(
                    to: CGPoint(
                        x: width * 0.5,
                        y: height * 0.4
                    )
                )
                path.addArc(center: CGPoint(
                    x: tabIndex == 1 ? width * 0.9 : width * 0.4,
                    y: tabIndex == 1 ? height * 0.4 : height * 0.6
                ), radius: width * 0.25, startAngle: Angle(degrees: 360.0), endAngle: Angle(degrees:0.0), clockwise: true)
            }
            */
        ZStack{
            LinearGradient(colors: [backgroundGradientStart, backgroundGradientEnd], startPoint: .top, endPoint: .bottom)
            if true {
                sunShape(x: !zoom ? 0.7 : 0.9, y: 0.4)
                    .fill(Color(UIColor(Self.gradientEnd).lighter(by: !zoom ? 20 : 25)))
                    .blur(radius: !zoom ? 50 : 20)
                /*
                 sunShape(x: tabIndex == 2 ? 0.4 : 0.9, y: tabIndex == 2 ? 0.25 : 0.4)
                 .fill(Color(UIColor(Self.gradientEnd).lighter(by: 20)))
                 .blur(radius: 50)
                 
                 sunShape(x: tabIndex == 2 ? 0.4 : 0.9, y: tabIndex == 2 ? 0.25 : 0.4)
                 .fill(Color(UIColor(Self.gradientEnd).lighter(by: 20)))
                 .blur(radius: 50)
                 
                 sunShape(x: tabIndex == 2 ? 0.4 : 0.9, y: tabIndex == 2 ? 0.25 : 0.4)
                 .fill(Color(UIColor(Self.gradientEnd).lighter(by: 20)))
                 .blur(radius: 50)
                 sunShape(x: tabIndex == 2 ? 0.4 : 0.9, y: tabIndex == 2 ? 0.25 : 0.4)
                 .fill(Color(UIColor(Self.gradientEnd).lighter(by: 20)))
                 .blur(radius: 50)
                 */
                sunShape(x: !zoom ? 0.7 : 0.9, y: 0.4)
                    .fill(Color(UIColor(Self.gradientEnd).lighter(by: !zoom ? 20 : 25)))
                    .blur(radius: 50)
                sunShape(x: !zoom ? 0.7 : 0.9, y: 0.4)
                    .fill(Color(UIColor(!zoom  ? Self.gradientEnd : Self.gradientStart).lighter(by: !zoom ? 40 : 25)))
                
                /*
                 VStack{
                 Spacer()
                 
                 MountainShape().fill(Color(UIColor(Self.gradientEnd1).darker(by: 30))).frame(height: 200).scaleEffect()
                 .opacity(0.5)
                 //.brightness(0.01).saturation(1.5)
                 Spacer().frame(height: 100)
                 }
                 */
                /*
                 VStack{
                 Spacer()
                 Rectangle()
                 .fill(Color(UIColor(Self.water).lighter(by: 50)))
                 .frame(height:450)
                 }
                 VStack{
                 HStack{
                 IslandShape()
                 .fill(Color(UIColor(Self.gradientEnd1).darker(by: 10))).frame(height: 200).scaleEffect()
                 .frame(width: 300, height:10)
                 
                 Spacer()
                 }
                 }
                 */
                GeometryReader{ metric in
                    Canvas { context, size in
                        let IslandHeightFraction = 1.0 * size.width / 320.0
                        let IslandHeightOffSet = IslandHeightOffSet + size.height * 0.25
                        print(IslandHeightFraction)
                        //IslandHeightFraction = 1.0
                        print(IslandHeightFraction)
                        //print(size.width)
                        
                        for _ in 0...0 {
                            /*
                             let rect = CGRect(x:0, y:0, width: size.width, height: 270).insetBy(dx: 0, dy: 0)
                             var context = context
                             context.translateBy(x: 20 , y: 20)
                             context.draw(Text("\(x)"), in: rect)
                             context.translateBy(x: 0 , y: 40)
                             context.draw(Text("\(now.remainder(dividingBy: 3))"), in: rect)
                             */
                        }
                        //MARK: Water Shape
                        for _ in 0...0 {
                            let waterHeight = (0.0 + IslandHeightOffSet)
                            let rect = CGRect(x:0, y:0, width: size.width, height: waterHeight).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: 0 , y: size.height - waterHeight)
                            if let mark = context.resolveSymbol(id: 2) {
                                context.draw(mark, in: rect)
                            }
                        }
                        /*
                         for _ in 0...0 {
                         let rect = CGRect(x:0, y:0, width:300, height: 100).insetBy(dx: 0, dy: 0)
                         var context = context
                         context.translateBy(x: 0 , y: size.height - 225)
                         if let mark = context.resolveSymbol(id: 1) {
                         context.draw(mark, in: rect)
                         }
                         }
                         */
                        /*
                         for _ in 0...0 {
                         let rect = CGRect(x:0, y:0, width: 30, height: 50).insetBy(dx: 0, dy: 0)
                         let point = CGPoint(x: 50, y: size.height - 300)
                         var context = context
                         context.translateBy(x: 0 , y: size.height - 320)
                         context.draw(Image("house1"), in: rect)
                         }
                         */
                        //MARK: Island Bottom Shape
                        for _ in 0...0 {
                            
                            let height = 130 * IslandHeightFraction
                            let width = height * (283 / 130.0)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: 0 , y: size.height + 54 - IslandHeightOffSet + (IslandHeightFraction - 1.0) * 54) // ???????????????
                            context.fill(IslandShape().path(in: rect), with: GraphicsContext.Shading.color(DefaultIslandBackgroundView.islandBottom))
                            
                        }
                        //MARK: Island Top Shape
                        for _ in 0...0 {
                            let height = 85.11 * IslandHeightFraction
                            let width = height * (273.5 / 85.11)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: 0, y: size.height - 0 - IslandHeightOffSet)
                            context.fill(IslandShapeTop().path(in: rect), with: GraphicsContext.Shading.color(DefaultIslandBackgroundView.islandTop))
                        }
                        
                        //MARK: Tree1
                        for _ in 0...0 {
                            let originWidth = 29.0
                            let originHeight = 48.0
                            let originX = -397.0
                            let originY = 32.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction, y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("tree1"), in: rect)
                        }
                        //MARK: Tree2
                        for _ in 0...0 {
                            let originWidth = 21.89
                            let originHeight = 54.0
                            let originX = -419.0
                            let originY = 25.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction, y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("tree2"), in: rect)
                        }
                        //MARK: Tree3
                        for _ in 0...0 {
                            let originWidth = 29.0
                            let originHeight = 55.0
                            let originX = -358.0
                            let originY = 36.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction, y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("tree1"), in: rect)
                        }
                        
                        //MARK: Tree3
                        for _ in 0...0 {
                            let originWidth = 22.0
                            let originHeight = 71.76
                            let originX = -377.0
                            let originY = 10.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction, y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("tree3"), in: rect)
                        }
                        
                        //MARK: house1
                        for _ in 0...0 {
                            let originWidth = 40.62
                            let originHeight = 46.0
                            let originX = -335.0
                            let originY = 49.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction , y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("house1"), in: rect)
                        }
                        
                        //MARK: house1
                        for _ in 0...0 {
                            let originWidth = 40.62
                            let originHeight = 46.0
                            let originX = -417.0
                            let originY = 64.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction , y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("house1"), in: rect)
                        }
                        
                        //MARK: Tree4
                        for _ in 0...0 {
                            let originWidth = 23.0
                            let originHeight = 56.0
                            let originX = -285.0
                            let originY = 39.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction, y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("tree4"), in: rect)
                        }
                        
                        //MARK: house2
                        for _ in 0...0 {
                            let originWidth = 43.0
                            let originHeight = 66.0
                            let originX = -376.0
                            let originY = 47.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction , y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("house2"), in: rect)
                        }
                        
                        //MARK: lightHouse Top
                        for _ in 0...0 {
                            let originWidth = 28.0
                            let originHeight = 29.0
                            let originX = -244.5
                            let originY = -57.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction , y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("lightHouseTop"), in: rect)
                        }
                        
                        //MARK: lightHouse
                        for _ in 0...0 {
                            let originWidth = 44.0
                            let originHeight = 139.0
                            let originX = -252.0
                            let originY = -38.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction , y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("lightHouseBottom"), in: rect)
                        }
                        
                        //MARK: house4
                        for _ in 0...0 {
                            let originWidth = 33.0
                            let originHeight = 25.0
                            let originX = -278.0
                            let originY = 80.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction , y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("house4"), in: rect)
                        }
                        
                        
                        
                        
                        
                        //MARK: house3
                        for _ in 0...0 {
                            let originWidth = 58.0
                            let originHeight = 47.0
                            let originX = -324.0
                            let originY = 65.0
                            let height = originHeight * IslandHeightFraction
                            let width = height * (originWidth / originHeight)
                            let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                            var context = context
                            context.translateBy(x: (originX + 419.0) * IslandHeightFraction , y: size.height - (0-(originY - 39))  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (originY - 39) )
                            context.draw(Image("house3"), in: rect)
                        }
                        
                        print("djkekwjdkwekldklw\(metric.size.height)")
                        
                        //MARK: TEST PARTICLE
                        /*
                         let x1 = 200, x2 = 150, y1 = size.height - 150, y2 = size.height - 380
                         
                         for x in x2...x1{
                         let xRandom = Int.random(in: -5...5)
                         let yRandom = Int.random(in: -2...0)
                         let sizeRandom = Int.random(in: 4...4)
                         let y: Int = Int(y1)
                         var context = context
                         context.translateBy(x: CGFloat(x + xRandom) , y: CGFloat(getY(x, Int(y1)) + yRandom) - (z * 35).remainder(dividingBy: 50))
                         let rect = CGRect(x:0, y:0, width: 2 + sizeRandom, height: 2 + sizeRandom).insetBy(dx: 0, dy: 0)
                         context.fill(Particle().path(in: rect), with: GraphicsContext.Shading.color(SwiftUIViewForDrawTest.wave))
                         }
                         */
                    } symbols: {
                        Rectangle().fill(LinearGradient(colors: [Color(UIColor(Self.water).lighter(by: 55)), Color(UIColor(Self.water).lighter(by: 55))], startPoint: .topTrailing, endPoint: .bottomLeading)).tag(2)
                        
                    }.offset(x: zoom ? -85 * metric.size.width / 320.0 : 0, y: zoom ? 70 : 0).scaleEffect(zoom ? 2.5 : 1.0)
                    
                    
                    TimelineView(.periodic(from: .now, by: zoom ? 10 : 0.03)) { timeline in
                        let now = timeline.date.timeIntervalSinceReferenceDate
                        let angle = Angle.degrees(now.remainder(dividingBy: 3)*120)
                        let x = (cos(angle.radians))
                        let y = (sin(angle.radians))
                        let z = now
                        Canvas(){ context, size in
                            let IslandHeightFraction = 1.0 * size.width / 320.0
                            let IslandHeightOffSet = IslandHeightOffSet + size.height * 0.25
                            for _ in 0...0 {
                                /*
                                 let rect = CGRect(x:0, y:0, width: size.width, height: 270).insetBy(dx: 0, dy: 0)
                                 var context = context
                                 context.translateBy(x: 20 , y: 20)
                                 context.draw(Text("\(x)"), in: rect)
                                 context.translateBy(x: 0 , y: 40)
                                 context.draw(Text("\(now.remainder(dividingBy: 3))"), in: rect)
                                 */
                            }
                            /*
                             //MARK: Water Shape
                             for _ in 0...0 {
                             
                             let waterHeight = 290.0 + IslandHeightOffSet
                             let rect = CGRect(x:0, y:0, width: size.width, height: waterHeight).insetBy(dx: 0, dy: 0)
                             var context = context
                             context.translateBy(x: 0 , y: size.height - waterHeight)
                             if let mark = context.resolveSymbol(id: 2) {
                             context.draw(mark, in: rect)
                             }
                             }
                             */
                            
                            //MARK: Island Wave Shape
                            for _ in 0...0 {
                                let height = 42.54 * IslandHeightFraction
                                let width = height * (288 / 42.54)
                                let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                                var context = context
                                context.translateBy(x: 0 , y: size.height + 103  - IslandHeightOffSet + (IslandHeightFraction - 1.0) * (103) )
                                context.fill(WhiteWave().path(in: rect, x: x, y: y), with: GraphicsContext.Shading.color(DefaultIslandBackgroundView.wave))
                                
                            }
                            
                            
                            //MARK: TEST PARTICLE
                            /*
                             let x1 = 200, x2 = 150, y1 = size.height - 150, y2 = size.height - 380
                             
                             for x in x2...x1{
                             let xRandom = Int.random(in: -5...5)
                             let yRandom = Int.random(in: -2...0)
                             let sizeRandom = Int.random(in: 4...4)
                             let y: Int = Int(y1)
                             var context = context
                             context.translateBy(x: CGFloat(x + xRandom) , y: CGFloat(getY(x, Int(y1)) + yRandom) - (z * 35).remainder(dividingBy: 50))
                             let rect = CGRect(x:0, y:0, width: 2 + sizeRandom, height: 2 + sizeRandom).insetBy(dx: 0, dy: 0)
                             context.fill(Particle().path(in: rect), with: GraphicsContext.Shading.color(SwiftUIViewForDrawTest.wave))
                             }
                             */
                            /*
                             //MARK: boat wave
                             for _ in 0...0 {
                             
                             let rect = CGRect(x:0, y:0, width: 150, height: 30).insetBy(dx: 0, dy: 0)
                             var context = context
                             context.translateBy(x: size.width / 2 - (z * 10).remainder(dividingBy: size.width) * 1.8 , y: size.height - 100)
                             if let mark = context.resolveSymbol(id: 1) {
                             context.draw(mark, in: rect)
                             }
                             
                             }
                             
                             //MARK: boatTest
                             for _ in 0...0 {
                             let originWidth = 66.64
                             let originHeight = 60.07
                             let height = originHeight * IslandHeightFraction
                             let width = height * (originWidth / originHeight)
                             let rect = CGRect(x:0, y:0, width: width, height: height).insetBy(dx: 0, dy: 0)
                             var context = context
                             context.translateBy(x: size.width / 2 - (z * 10).remainder(dividingBy: size.width) * 1.8 - 50 , y: size.height - 135)
                             context.draw(Image("boat"), in: rect)
                             }
                             */
                        } symbols: {
                            
                            BoatWave(strength: 50.0, frequency: 10, phase: z*3).stroke(LinearGradient(colors: [DefaultIslandBackgroundView.wave.opacity(1.0),DefaultIslandBackgroundView.wave.opacity(0.0)], startPoint: .leading, endPoint: .trailing), lineWidth: 90).tag(1).rotation3DEffect(.degrees(0), axis: (x:0, y:0, z:1))
                        }.offset(x: zoom ? -85 * metric.size.width / 320.0 : 0, y: zoom ? 80 * 320.0 / metric.size.width : 0).scaleEffect(zoom ? 2.5 : 1.0)
                    }
                }
            }
            
        }.ignoresSafeArea()
            //.blur(radius: zoom ? 8 : 0)
            //.fill(Self.gradientEnd)
            .animation(.easeInOut(duration: 1.0), value: tabIndex)
            .animation(.easeInOut(duration: 1.0), value: zoom)
            //.glow(color: .orange)
    }
}

private func getY(_ x: Int, _ y: Int) -> Int {
    return y - x / 8
}



struct SwiftUIViewForDrawTest_Previews1: PreviewProvider {
    @State static var t: AppTabShowType = .habits
    @State static var zoom: Bool = false
    static var previews: some View {
        DefaultIslandBackgroundView(tabIndex: $t, zoom: $zoom)
    }
}

struct SwiftUIViewForDrawTest_Previews2: PreviewProvider {
    @State static var t: AppTabShowType = .habits
    @State static var zoom: Bool = false
    static var previews: some View {
        RootView()
    }
}
