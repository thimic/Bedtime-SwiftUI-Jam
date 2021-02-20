//
//  BedtimeWheelView.swift
//  Bedtime
//
//  Created by Michael Thingnes on 20/02/21.
//

import SwiftUI


extension Double {
    var radians: Double { self * .pi / 180 }
}

extension Color {
    static let darkOrange = Color(red: 135.0 / 255.0, green: 53.0 / 255.0, blue: 17.0 / 255.0)
}


struct ClockTicks: View {
    
    let ringPickerLineWidth: CGFloat
    
    let width: CGFloat
    let height: CGFloat
    let center: CGPoint
    let clockRadius: CGFloat
    
    let tickInset: CGFloat = 6
    let numberInset: CGFloat = 25
    let imageInset: CGFloat = 48
    
    let longtickRange = 1...24
    let longtickSize = CGSize(width: 5, height: 1)
    
    let shorttickRange = 1...96
    let shorttickSize = CGSize(width: 2, height: 1)
    
    let tickColour: Color = .gray.opacity(0.7)
    
    var numberRadius: CGFloat { clockRadius - numberInset }
    var imageRadius: CGFloat { clockRadius - imageInset }
    
    var body: some View {
        
        ZStack {
            ForEach(longtickRange, id: \.self) { tick in
                
                let angle = Double(tick) * 360 / Double(longtickRange.upperBound)
                let numberAngle = angle - 90.0
                
                Capsule()
                    .frame(width: longtickSize.width, height: longtickSize.height)
                    .offset(x: -(longtickSize.width / 2))
                    .position(x: width / 2 + clockRadius - tickInset, y: height / 2)
                    .rotationEffect(.degrees(angle), anchor: .center)
                    .foregroundColor(tickColour)
                
                if tick.isMultiple(of: 2) && !tick.isMultiple(of: 6) {
                    Text("\(tick)")
                        .position(
                            x: center.x + (numberRadius * CGFloat(cos(numberAngle.radians))),
                            y: center.y + (numberRadius * CGFloat(sin(numberAngle.radians)))
                        )
                        .foregroundColor(.gray)
                        .font(.subheadline.weight(.semibold))
                }
                
                if tick.isMultiple(of: 6) {
                    Text("\(tick % 24)")
                        .position(
                            x: center.x + (numberRadius * CGFloat(cos(numberAngle.radians))),
                            y: center.y + (numberRadius * CGFloat(sin(numberAngle.radians)))
                        )
                        .font(.subheadline.weight(.semibold))
                }
                
            }
            
            ForEach(shorttickRange, id: \.self) { tick in
                if !tick.isMultiple(of: (shorttickRange.upperBound / longtickRange.upperBound)) {
                    Capsule()
                        .frame(width: shorttickSize.width, height: shorttickSize.height)
                        .offset(x: -(shorttickSize.width / 2))
                        .position(x: width / 2 + clockRadius - tickInset, y: height / 2)
                        .rotationEffect(.degrees(Double(tick) * 360 / Double(shorttickRange.upperBound)), anchor: .center)
                        .foregroundColor(tickColour)

                }
            }
            
            Image(systemName: "sparkles")
                .position(x: center.x, y: center.y - imageRadius)
                .foregroundColor(Color(UIColor.systemTeal))
            
            Image(systemName: "sun.max.fill")
                .position(x: center.x, y: center.y + imageRadius)
                .foregroundColor(.yellow)
            
        }
        .compositingGroup()
    }
}


struct WheelTicks: View {
    
    @Binding var bedtimeAngle: Double
    @Binding var wakeupAngle: Double
    
    let ringPickerLineWidth: CGFloat
    
    let width: CGFloat
    let height: CGFloat
    let center: CGPoint
    let pickerRadius: CGFloat
    
    var body: some View {
        
        ForEach(1...144, id: \.self) { tick in
            Capsule()
                .frame(width: 15, height: 2.5)
                .position(x: width / 2 + pickerRadius, y: height / 2)
                .rotationEffect(.degrees(Double(tick) * 2.5), anchor: .center)
        }
        .mask(
            Path { path in
                path.addArc(
                    center: center,
                    radius: pickerRadius,
                    startAngle: Angle(degrees: bedtimeAngle),
                    endAngle: Angle(degrees: wakeupAngle),
                    clockwise: false
                )
            }
            .stroke(lineWidth: ringPickerLineWidth)
        )
        .compositingGroup()
    }
}


struct WheelDragHandle: View {
    
    @Binding var angle: Double
    
    @Binding var pickerColour: Color
    @Binding var pickerDarkColour: Color
    
    @State private var isPressed: Bool = false
    
    let symbolName: String
        
    let width: CGFloat
    let height: CGFloat
    let center: CGPoint
    let pickerRadius: CGFloat
    
    let ringPickerHandleWidth: CGFloat
        
    var body: some View {
        ZStack {
            Circle()
                .frame(width: ringPickerHandleWidth, height: ringPickerHandleWidth)
                .foregroundColor(pickerColour)

            Circle()
                .frame(width: ringPickerHandleWidth, height: ringPickerHandleWidth)
                .foregroundColor(pickerDarkColour.opacity(0.25))
                .opacity(isPressed ? 1.0 : 0.0)
            
            Image(systemName: symbolName)
                .font(.subheadline)
                .foregroundColor(pickerDarkColour)
        }
        .position(
            x: center.x + (pickerRadius * CGFloat(cos(angle.radians))),
            y: center.y + (pickerRadius * CGFloat(sin(angle.radians)))
        )
        .gesture(
            DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                .onChanged { _ in withAnimation(.easeInOut(duration: 0.25)) { isPressed = true } }
                .onEnded { _ in withAnimation(.easeOut(duration: 0.25)) { isPressed = false } }
        )

    }
}


struct WheelPicker: View {
    
    @Binding var schedule: Schedule
    
    @State private var pickerColour: Color = .orange
    @State private var pickerDarkColour: Color = .darkOrange
    
    @State private var bedtimeAngle: Double = -100
    @State private var wakeupAngle: Double = 25
    
    let ringLineWidth: CGFloat = 50.0
    let ringPickerLineWidth: CGFloat = 40.0
    let ringPickerHandleWidth: CGFloat = 32.0
    
    func timeToAngle(_ time: DateComponents) -> Double {
        let timeRange = 0.0...24.0
        let angleRange = 0.0...360.0
        let angleOffset = -90.0
        let hour = 60.0 * 60.0
        
        let timeInterval = Calendar.current.date(from: DateComponents())!.distance(to: Calendar.current.date(from: time)!)
        
        let normalised = timeInterval / (timeRange.upperBound * hour)
        return (normalised * angleRange.upperBound) + angleOffset
    }
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color(UIColor.systemBackground), lineWidth: 50.0)
            
            GeometryReader { geometry in
                
                let width = geometry.size.width
                let height = geometry.size.height
                let center = CGPoint(x: width / 2, y: height / 2)
                let ringRadius = min(geometry.size.width / 2, geometry.size.height / 2)
                let clockRadius = ringRadius - ringLineWidth
                let pickerRadius = ringRadius - (ringLineWidth / 2)
                
                Path { path in
                    path.addArc(
                        center: center,
                        radius: pickerRadius,
                        startAngle: Angle(degrees: bedtimeAngle),
                        endAngle: Angle(degrees: wakeupAngle),
                        clockwise: false
                    )
                }
                .stroke(pickerColour, style: StrokeStyle(lineWidth: ringPickerLineWidth, lineCap: .round))
                .shadow(radius: 5)
                
                ClockTicks(
                    ringPickerLineWidth: ringPickerLineWidth,
                    width: width,
                    height: height,
                    center: center,
                    clockRadius: clockRadius
                )
                
                WheelTicks(
                    bedtimeAngle: $bedtimeAngle,
                    wakeupAngle: $wakeupAngle,
                    ringPickerLineWidth: ringPickerLineWidth,
                    width: width,
                    height: height,
                    center: center,
                    pickerRadius: pickerRadius
                )
                .foregroundColor(.darkOrange.opacity(0.2))
                
                WheelDragHandle(
                    angle: $bedtimeAngle,
                    pickerColour: $pickerColour,
                    pickerDarkColour: $pickerDarkColour,
                    symbolName: "bed.double.fill",
                    width: width,
                    height: height,
                    center: center,
                    pickerRadius: pickerRadius,
                    ringPickerHandleWidth: ringPickerHandleWidth
                )
                .onTapGesture {
                    
                }
                
                WheelDragHandle(
                    angle: $wakeupAngle,
                    pickerColour: $pickerColour,
                    pickerDarkColour: $pickerDarkColour,
                    symbolName: "bell.fill",
                    width: width,
                    height: height,
                    center: center,
                    pickerRadius: pickerRadius,
                    ringPickerHandleWidth: ringPickerHandleWidth
                )
                .onTapGesture {
                    
                }
                
            }
        }
        .onChange(of: schedule.bedtime) { bedtime in
            bedtimeAngle = timeToAngle(bedtime)
        }
        .onChange(of: schedule.wakeup) { wakeup in
            wakeupAngle = timeToAngle(wakeup)
        }
        .onAppear {
            bedtimeAngle = timeToAngle(schedule.bedtime)
            wakeupAngle = timeToAngle(schedule.wakeup)
        }
        
    }
}

struct BedtimeWheelView: View {
    
    @Binding var schedule: Schedule
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    
                    HStack {
                        TimeCell(name: "Bedtime", iconName: "bed.double.fill", time: schedule.bedtime)
                        TimeCell(name: "Wake Up", iconName: "bell.fill", time: schedule.wakeup)
                    }
                    
                    Spacer()
                    
                    VStack {
                        WheelPicker(schedule: $schedule)
                            .padding(.bottom, 10)
                            .frame(width: 320, height: 320)
                        Text(schedule.durationAsString)
                            .font(.system(.title2, design: .rounded).weight(.semibold))
                            .padding(.bottom, 2)
                    }
                    
                    Spacer()
                                       
                }

            }
            
            HStack {
                VStack {
                    Spacer()
                    SleepGoalTextView(schedule: schedule)
                }
                Spacer()
            }
        }
        .padding(.vertical)
    }
}

struct BedtimeWheelView_Previews: PreviewProvider {
    static var previews: some View {
        Cell {
            BedtimeWheelView(schedule: .constant(BedtimeModel.example.schedules.first!))
                .frame(width: 700, height: 380)
        }
        .environmentObject(BedtimeModel.example)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
        .padding()
    }
}
