//
//  OverView.swift
//  Bedtime
//
//  Created by Michael Thingnes on 20/02/21.
//

import SwiftUI

struct BedtimeIcon: View {
    
    let gradient = Gradient(colors: [Color.accentColor, Color(UIColor.systemTeal)])
    let size: CGFloat = 60
    
    var body: some View {
        
        RadialGradient(gradient: gradient, center: .bottomLeading, startRadius: 5, endRadius: 150)
            .frame(maxWidth: 80, minHeight: size)
            .mask(
                Image(systemName: "bed.double.fill")
                    .font(.system(size: size))
            )

    }
}

struct OverView: View {
    
    @EnvironmentObject var model: BedtimeModel
    
    @State private var editableSchedule: Schedule = .standard
    @State private var isShowingEditSchedule: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    BedtimeIcon()
                    
                    Text("Sweet Dreams")
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.bottom)
                
                Cell {
                    BedtimeWheelView(schedule: $editableSchedule)
                }
            }
        }
        .frame(maxWidth: 700)
        .sheet(isPresented: $isShowingEditSchedule) {
            NavigationView {
                EditScheduleView(schedule: $editableSchedule)
                    .environmentObject(model)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button(action: { isShowingEditSchedule.toggle() }, label: {
                                Text("Cancel")
                            })
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: {}, label: {
                                Text("Add")
                            })
                        }
                    }
            }
        }
    }
}

struct OverView_Previews: PreviewProvider {
    static var previews: some View {
        OverView()
            .environmentObject(BedtimeModel.example)
            .preferredColorScheme(.dark)
    }
}
