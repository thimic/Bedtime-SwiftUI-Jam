//
//  DeveloperView.swift
//  Bedtime
//
//  Created by Michael Thingnes on 19/02/21.
//

import AVFoundation
import SwiftUI

struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}


struct DeveloperView: View {
    
    @StateObject var model = BedtimeModel.example
    
    func playSound() {
        let systemSoundID: SystemSoundID = 1005
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    func sendNotification() {
        LocalNotificationManager.shared.requestPermissions()
        LocalNotificationManager.shared.addNotification("7:30 Alarm", subtitle: "Time to wake up. There is work to be done!")
        LocalNotificationManager.shared.scheduleNotifications()
    }
    
    var body: some View {
        
        VStack {
            Button(action: playSound, label: {
                Label("Play Sound", systemImage: "play.fill")
            })
            .buttonStyle(FilledButtonStyle())

            Button(action: sendNotification, label: {
                Label("Send Notification", systemImage: "bell.fill")
            })
            .buttonStyle(FilledButtonStyle())
            
            Form {
                Section(header: Text("Available Weekdays")) {
                    ForEach(model.availableWeekdays, id: \.self) { weekday in
                        Text(weekday.rawValue)
                    }
                }
                
                Section(header: Text("Taken Weekdays")) {
                    ForEach(model.takenWeekdays, id: \.self) { weekday in
                        Text(weekday.rawValue)
                    }
                }
            }
        }
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DeveloperView()
                .preferredColorScheme(.dark)
            
            DeveloperView()
        }
    }
}
