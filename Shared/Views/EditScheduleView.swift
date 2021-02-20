//
//  EditScheduleView.swift
//  Bedtime
//
//  Created by Michael Thingnes on 20/02/21.
//

import SwiftUI


struct SleepGoalTextView: View {
    
    let schedule: Schedule
    
    @EnvironmentObject var model: BedtimeModel
    
    var sleepGoalText: String {
        if schedule.duration >= model.sleepGoalDuration {
            return "This schedule meets your sleep goal."
        } else {
            return "This schedule does not meet your sleep goal."
        }
    }
    
    var body: some View {
        HStack {
            if schedule.duration < model.sleepGoalDuration {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundColor(.orange)
            }
            
            Text(sleepGoalText)
                .foregroundColor(.gray)
        }
        .font(.subheadline)
    }
    
}

struct EditScheduleView: View {
    
    @EnvironmentObject var model: BedtimeModel
    
    @Binding var schedule: Schedule
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Add Another Part to Your Schedule")
                    .font(.system(size: 34, weight: .bold))
                    .multilineTextAlignment(.center)

            
                Block(header: Text("Days Active")) {
                    Cell {
                        HStack {
                            Spacer()
                            DaySelectionView(schedule: $schedule)
                                .environmentObject(model)
                            Spacer()
                        }
                    }
                }
                
                Block(header: Text("Bedtime and Wake Up")) {
                    Cell {
                        BedtimeWheelView(schedule: $schedule)
                    }
                }
                
                Block(header: Text("Alarm Options")) {
                    Cell {
                        HStack {
                            Toggle(isOn: $schedule.alarm, label: {
                                Text("Wake Up Alarm")
                            })
                        }
                    }
                }
                if schedule.alarm {
                    Cell {
                        VStack {
                            HStack {
                                Text("Sound & Haptics")
                                Spacer()
                                NavigationLink(
                                    destination: Text("Destination"),
                                    label: {
                                        HStack {
                                            Text(schedule.sound)
                                            Image(systemName: "chevron.right")
                                                .font(.callout)
                                        }
                                        .foregroundColor(.gray)
                                    })
                            }
                            
                            Divider()
                            
                            HStack {
                                Image(systemName: "speaker.fill")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                                Slider(value: $schedule.volume, in: 0.0...1.0)
                                Image(systemName: "speaker.wave.3.fill")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                            
                            Divider()
                            
                            Toggle(isOn: $schedule.snooze, label: {
                                Text("Snooze")
                            })
                        }
                    }
                }
            }
            .padding()
        }
        .padding()
    }
}

struct EditScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        EditScheduleView(schedule: .constant(BedtimeModel.example.schedules.first!))
            .backgroundColour(Color(UIColor.secondarySystemBackground))
            .environmentObject(BedtimeModel.example)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
