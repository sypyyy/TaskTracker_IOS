//
//  Shapes.swift
//  HabitTracker
//
//  Created by 施炎培 on 2023/5/26.
//

import Foundation
import SwiftUI

struct CheckMarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.01538*width, y: 0.47561*height))
        path.addCurve(to: CGPoint(x: 0.34615*width, y: 0.97561*height), control1: CGPoint(x: 0.10513*width, y: 0.52846*height), control2: CGPoint(x: 0.29692*width, y: 0.70244*height))
        path.addCurve(to: CGPoint(x: 0.98462*width, y: 0.20732*height), control1: CGPoint(x: 0.52051*width, y: 0.70732*height), control2: CGPoint(x: 0.87692*width, y: 0.2561*height))
        path.addLine(to: CGPoint(x: 0.98462*width, y: 0.03659*height))
        path.addCurve(to: CGPoint(x: 0.37692*width, y: 0.71951*height), control1: CGPoint(x: 0.78462*width, y: 0.15854*height), control2: CGPoint(x: 0.43846*width, y: 0.62195*height))
        path.addCurve(to: CGPoint(x: 0.08462*width, y: 0.32927*height), control1: CGPoint(x: 0.32769*width, y: 0.56341*height), control2: CGPoint(x: 0.16154*width, y: 0.39431*height))
        path.addLine(to: CGPoint(x: 0.01538*width, y: 0.47561*height))
        path.closeSubpath()
        return path
    }
}

struct CheckMark: View {
    let size: Int
    var body: some View {
        CheckMarkShape().fill(.gray).frame(width: CGFloat(size), height: CGFloat(size))
    }
}

struct MountainShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.00236*width, y: 0.99384*height))
        path.addCurve(to: CGPoint(x: 0.2695*width, y: 0.01823*height), control1: CGPoint(x: 0.0203*width, y: 0.70649*height), control2: CGPoint(x: 0.12429*width, y: 0.15394*height))
        path.addCurve(to: CGPoint(x: 0.99527*width, y: 0.99384*height), control1: CGPoint(x: 0.39685*width, y: -0.10078*height), control2: CGPoint(x: 0.81484*width, y: 0.60431*height))
        path.addLine(to: CGPoint(x: 0.00236*width, y: 0.99384*height))
        path.closeSubpath()
        return path
    }
}

struct sunShape : Shape{
    var x: Double = 0.9
    var y: Double = 0.4

    var animatableData: AnimatablePair<Double, Double> {
        get { return AnimatablePair(x, y) }
        set { x = newValue.first
              y = newValue.second
        }
    }
    func path(in rect: CGRect) -> Path {
        let width: CGFloat = rect.size.width
        let height: CGFloat = rect.size.height
        var p = Path()
        p.addArc(center: CGPoint(
            x: width * x,
            y: height * y
        ), radius: width * 0.25, startAngle: Angle(degrees: 360.0), endAngle: Angle(degrees:0.0), clockwise: true)
        return p
    }
}


struct IslandShape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.09668*width, y: 0.20971*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.18492*height), control1: CGPoint(x: 0.06738*width, y: 0.19801*height), control2: CGPoint(x: 0.03456*width, y: 0.19002*height))
        path.addLine(to: CGPoint(x: 0, y: 0.59632*height))
        path.addCurve(to: CGPoint(x: 0.08481*width, y: 0.64231*height), control1: CGPoint(x: 0.02469*width, y: 0.60453*height), control2: CGPoint(x: 0.05742*width, y: 0.63382*height))
        path.addCurve(to: CGPoint(x: 0.17813*width, y: 0.66355*height), control1: CGPoint(x: 0.12772*width, y: 0.65562*height), control2: CGPoint(x: 0.16664*width, y: 0.66355*height))
        path.addCurve(to: CGPoint(x: 0.24691*width, y: 0.65333*height), control1: CGPoint(x: 0.18379*width, y: 0.66355*height), control2: CGPoint(x: 0.21087*width, y: 0.65932*height))
        path.addCurve(to: CGPoint(x: 0.31217*width, y: 0.64231*height), control1: CGPoint(x: 0.26666*width, y: 0.65005*height), control2: CGPoint(x: 0.2891*width, y: 0.64624*height))
        path.addCurve(to: CGPoint(x: 0.36331*width, y: 0.63359*height), control1: CGPoint(x: 0.32914*width, y: 0.63942*height), control2: CGPoint(x: 0.34647*width, y: 0.63646*height))
        path.addCurve(to: CGPoint(x: 0.42504*width, y: 0.62322*height), control1: CGPoint(x: 0.3853*width, y: 0.62985*height), control2: CGPoint(x: 0.40648*width, y: 0.62628*height))
        path.addCurve(to: CGPoint(x: 0.47795*width, y: 0.61502*height), control1: CGPoint(x: 0.44764*width, y: 0.6195*height), control2: CGPoint(x: 0.46637*width, y: 0.61655*height))
        path.addCurve(to: CGPoint(x: 0.55763*width, y: 0.59632*height), control1: CGPoint(x: 0.49051*width, y: 0.61336*height), control2: CGPoint(x: 0.51111*width, y: 0.61624*height))
        path.addCurve(to: CGPoint(x: 0.63347*width, y: 0.56855*height), control1: CGPoint(x: 0.57842*width, y: 0.58742*height), control2: CGPoint(x: 0.6087*width, y: 0.57968*height))
        path.addCurve(to: CGPoint(x: 0.69167*width, y: 0.54208*height), control1: CGPoint(x: 0.65211*width, y: 0.56017*height), control2: CGPoint(x: 0.67164*width, y: 0.55128*height))
        path.addCurve(to: CGPoint(x: 0.7534*width, y: 0.51347*height), control1: CGPoint(x: 0.71186*width, y: 0.5328*height), control2: CGPoint(x: 0.73255*width, y: 0.52321*height))
        path.addCurve(to: CGPoint(x: 0.79169*width, y: 0.49552*height), control1: CGPoint(x: 0.76614*width, y: 0.50753*height), control2: CGPoint(x: 0.77893*width, y: 0.50153*height))
        path.addCurve(to: CGPoint(x: 0.831*width, y: 0.47696*height), control1: CGPoint(x: 0.80486*width, y: 0.48932*height), control2: CGPoint(x: 0.818*width, y: 0.48312*height))
        path.addCurve(to: CGPoint(x: 0.86804*width, y: 0.45934*height), control1: CGPoint(x: 0.84349*width, y: 0.47103*height), control2: CGPoint(x: 0.85587*width, y: 0.46515*height))
        path.addCurve(to: CGPoint(x: 0.90507*width, y: 0.44163*height), control1: CGPoint(x: 0.88063*width, y: 0.45334*height), control2: CGPoint(x: 0.89301*width, y: 0.44742*height))
        path.addCurve(to: CGPoint(x: 0.95595*width, y: 0.41712*height), control1: CGPoint(x: 0.92281*width, y: 0.43312*height), control2: CGPoint(x: 0.93987*width, y: 0.4249*height))
        path.addCurve(to: CGPoint(x: width, y: 0.39573*height), control1: CGPoint(x: 0.97166*width, y: 0.40953*height), control2: CGPoint(x: 0.98643*width, y: 0.40235*height))
        path.addCurve(to: CGPoint(x: 0.96471*width, y: 0), control1: CGPoint(x: 0.98756*width, y: 0.39375*height), control2: CGPoint(x: 0.97139*width, y: 0.07303*height))
        path.addCurve(to: CGPoint(x: 0.09668*width, y: 0.20971*height), control1: CGPoint(x: 0.96037*width, y: 0.06609*height), control2: CGPoint(x: 0.25083*width, y: 0.27125*height))
        path.closeSubpath()
        return path
    }
}

struct WhiteWave{
    func path(in rect: CGRect, x: Double, y: Double) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.18893*width, y: 0.752*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.56165*height), control1: CGPoint(x: 0.16234*width, y: 0.83322*height), control2: CGPoint(x: 0.05131*width, y: 0.65894*height))
        path.addLine(to: CGPoint(x: 0, y: 0.79007*height))
        path.addCurve(to: CGPoint(x: 0.18182*width, y: 0.94318*height), control1: CGPoint(x: 0, y: 0.85352*height), control2: CGPoint(x: 0.16257*width, y: 1.05943*height))
        path.addCurve(to: CGPoint(x: 0.2972*width, y: 0.82251*height), control1: CGPoint(x: 0.19103*width, y: (0.88754 + 0.05 * (x+1))*height), control2: CGPoint(x: 0.24028*width, y: 0.84808*height))
        path.addCurve(to: CGPoint(x: 0.49681*width, y: 0.79545*height), control1: CGPoint(x: 0.38576*width, y: (0.78273 + 0.12 * (x+1))*height), control2: CGPoint(x: 0.4929*width, y: 0.77659*height))
        path.addCurve(to: CGPoint(x: 0.62762*width, y: 0.64594*height), control1: CGPoint(x: 0.50134*width, y: 0.81722*height), control2: CGPoint(x: 0.55957*width, y: (0.73088 + 0.09 * (x+1))*height))
        path.addCurve(to: CGPoint(x: 0.79196*width, y: 0.5*height), control1: CGPoint(x: 0.68396*width, y: 0.57563*height), control2: CGPoint(x: 0.74703*width, y: (0.50628 + 0.12 * (x+1))*height))
        path.addCurve(to: CGPoint(x: 0.99363*width, y: 0.16825*height), control1: CGPoint(x: 0.84681*width, y: 0.30716*height), control2: CGPoint(x: 0.98269*width, y: (0.15171 + 0.1 * (x+1))*height))
        path.addCurve(to: CGPoint(x: 0.98077*width, y: 0.01136*height), control1: CGPoint(x: 1.00978*width, y: 0.19267*height), control2: CGPoint(x: 0.98951*width, y: 0.04545*height))
        path.addCurve(to: CGPoint(x: 0.98252*width, y: 0.07955*height), control1: CGPoint(x: 0.97911*width, y: 0.01287*height), control2: CGPoint(x: 0.98427*width, y: 0.07955*height))
        path.addCurve(to: CGPoint(x: 0.8479*width, y: 0.25*height), control1: CGPoint(x: 0.98252*width, y: (0.07955 - 0.07 * (y+1))*height), control2: CGPoint(x: 0.86517*width, y: 0.22109*height))
        path.addCurve(to: CGPoint(x: 0.66608*width, y: 0.45858*height), control1: CGPoint(x: 0.83651*width, y: 0.26906*height), control2: CGPoint(x: 0.75026*width, y: (0.36627 - 0.07 * (-x+1))*height))
        path.addCurve(to: CGPoint(x: 0.49681*width, y: 0.63779*height), control1: CGPoint(x: 0.58216*width, y: (0.55062 - 0.1 * (y+1))*height), control2: CGPoint(x: 0.50031*width, y: 0.63779*height))
        path.addCurve(to: CGPoint(x: 0.34441*width, y: 0.65871*height), control1: CGPoint(x: 0.49318*width, y: 0.63779*height), control2: CGPoint(x: 0.41928*width, y: 0.64121*height))
        path.addCurve(to: CGPoint(x: 0.18893*width, y: 0.752*height), control1: CGPoint(x: 0.27507*width, y: (0.67492 - 0.08 * (y+1))*height), control2: CGPoint(x: 0.20491*width, y: 0.70319*height))
        path.closeSubpath()
        return path
    }
    
    func getRandomExtent() -> Double {
        return Double.random(in: 0.01...0.8)
    }
}

struct IslandShapeTop: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.91585*width, y: 0.55595*height))
        path.addCurve(to: CGPoint(x: 0.99815*width, y: 0.64535*height), control1: CGPoint(x: 0.97439*width, y: 0.55595*height), control2: CGPoint(x: 0.99899*width, y: 0.62613*height))
        path.addCurve(to: CGPoint(x: 0.10003*width, y: 0.97193*height), control1: CGPoint(x: 0.99367*width, y: 0.74827*height), control2: CGPoint(x: 0.25952*width, y: 1.06777*height))
        path.addCurve(to: CGPoint(x: 0, y: 0.93332*height), control1: CGPoint(x: 0.06972*width, y: 0.95371*height), control2: CGPoint(x: 0.03575*width, y: 0.94127*height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addCurve(to: CGPoint(x: 0.50912*width, y: 0.4467*height), control1: CGPoint(x: 0.12901*width, y: 0.11145*height), control2: CGPoint(x: 0.31336*width, y: 0.30626*height))
        path.addCurve(to: CGPoint(x: 0.70803*width, y: 0.50581*height), control1: CGPoint(x: 0.57469*width, y: 0.49374*height), control2: CGPoint(x: 0.64155*width, y: 0.47615*height))
        path.addCurve(to: CGPoint(x: 0.91585*width, y: 0.55595*height), control1: CGPoint(x: 0.77837*width, y: 0.53719*height), control2: CGPoint(x: 0.8483*width, y: 0.55595*height))
        path.closeSubpath()
        return path
    }
}




struct BoatWave: Shape {
    
    // how high our waves should be
    var strength: Double

    // how frequent our waves should be
    var frequency: Double
    var phase: Double
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()

        // calculate some important values up front
        let width = Double(rect.width)
        let height = Double(rect.height)
        
        
       

        // split our total width up based on the frequency
        let wavelength = width / frequency

        // start at the left center
        path.move(to: CGPoint(x: 0, y: height / 4.0 + strength * sin(phase)))

        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width, by: 1) {
            // find our current position relative to the wavelength
            let relativeX = x / wavelength

            // calculate the sine of that position
            let sine = sin(relativeX + phase)

            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
            let y = strength * sine + height / 4.0

            // add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
        }
        let phaseSecond = phase + 3.14/4
        path.move(to: CGPoint(x: 0, y: 3 * height / 4.0 + strength * sin(phaseSecond)))
        
        // now count across individual horizontal points one by one
        for x in stride(from: 0, through: width, by: 1) {
            // find our current position relative to the wavelength
            let relativeX = x / wavelength

            // calculate the sine of that position
            let sine = sin(relativeX + phaseSecond)

            // multiply that sine by our strength to determine final offset, then move it down to the middle of our view
            let y = strength * sine + 3 * height / 4.0

            // add a line to here
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return Path(path.cgPath)
    }
   
}



struct Particle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.addEllipse(in: CGRect(x: 0, y: 0, width: width, height: height))
        return path
    }
}
