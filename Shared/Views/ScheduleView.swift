//
//  ScheduleView.swift
//  Bedtime
//
//  Created by Michael Thingnes on 20/02/21.
//

import SwiftUI


struct ScheduleViewCell: View {
    
    let schedule: Schedule
    
    @Binding var editableSchedule: Schedule
    @Binding var showEditSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(schedule.dayList)
                .font(.subheadline)
                .bold()
                .foregroundColor(Color(UIColor.systemTeal))
            HStack {
                TimeCell(name: "Bedtime", iconName: "bed.double.fill", time: schedule.bedtime)
                TimeCell(
                    name: schedule.alarm ? "Wake Up" : "Wake Up - No Alarm",
                    iconName: schedule.alarm ? "bell.fill" : "bell.slash",
                    time: schedule.wakeup,
                    alarm: schedule.alarm
                )
            }
            .padding(.vertical, 4)
            
            Divider()
            
            Button(action: {
                editableSchedule = schedule
                showEditSheet.toggle()
            }, label: {
                HStack {
                    Text("Edit")
                    Spacer()
                }
            })
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}


struct ScheduleView: View {
    
    @EnvironmentObject var model: BedtimeModel
    
    @State private var showingSleepGoalPicker: Bool = false
    
    @State private var editableSchedule: Schedule = .standard
    @State private var isShowingEditSchedule: Bool = false
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                
                Block(header: Text("Full Schedule")) {
                    ForEach(model.schedules, id: \.self) { schedule in
                        Cell {
                            ScheduleViewCell(
                                schedule: schedule,
                                editableSchedule: $editableSchedule,
                                showEditSheet: $isShowingEditSchedule
                            )
                        }
                    }
                    
                    Cell {
                        Button(action: {
                            editableSchedule = .standard
                            isShowingEditSchedule.toggle()
                        }, label: {
                            HStack {
                                Text(model.schedules.count > 0 ? "Add Schedule for Other Days" : "Set Your First Schedule")
                                Spacer()
                            }
                        })
                    }
                }
                
                Block(header: Text("Additional Details")) {
                    Cell {
                        HStack {
                            Text("Sleep Goal")
                            Spacer()
                            Text("\(model.sleepGoalHours) hr \(String(format: "%02d", model.sleepGoalMinutes)) min")
                                .foregroundColor(showingSleepGoalPicker ? .accentColor : .gray)
                        }
                        if showingSleepGoalPicker {
                            Divider()
                            HStack {
                                Picker(selection: $model.sleepGoalHours, label: Text("Picker"), content: {
                                    ForEach(4...12, id: \.self) { hour in
                                        Text("\(hour) hr").tag(hour)
                                    }
                                })
                                .frame(maxWidth: 120)
                                .clipped()
                                
                                Picker(selection: $model.sleepGoalMinutes, label: Text("Picker"), content: {
                                    Text("00 min").tag(0)
                                    if model.sleepGoalHours < 12 {
                                        Text("30 min").tag(30)
                                    }
                                })
                                .frame(maxWidth: 120)
                                .clipped()
                            }
                            
                        }
                    }
                    .onTapGesture {
                        showingSleepGoalPicker.toggle()
                    }
                }
            }
        }
        .padding(.horizontal)
        .backgroundColour(Color(UIColor.secondarySystemBackground))
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

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ScheduleView()
                .environmentObject(BedtimeModel.example)
                .preferredColorScheme(.dark)
            
            ScheduleView()
                .environmentObject(BedtimeModel.example)
                .preferredColorScheme(.light)
        }
    }
}
