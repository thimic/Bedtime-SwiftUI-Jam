//
//  LocalNotificationManager.swift
//  Bedtime
//
//  Created by Michael Thingnes on 20/02/21.
//

import UIKit


struct Notification {
    let id: UUID = UUID()
    let title: String
    var subtitle: String?
}


class LocalNotificationManager {
    var notifications: [Notification] = []
    
    func requestPermissions() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .criticalAlert]) { granted, error in
                guard granted && error == nil else { return }
            }
    }
    
    func addNotification(_ title: String, subtitle: String?) {
        notifications.append(Notification(title: title, subtitle: subtitle))
    }
    
    func scheduleNotifications() {
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            if let subtitle = notification.subtitle {
                content.subtitle = subtitle
            }
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.weekday = 1
            dateComponents.hour = 9
            dateComponents.minute = 30
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let dateTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: notification.id.uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                guard error == nil else { return }
                print("Sceduling notification with id: \(request.identifier)")
            }
        }
        notifications.removeAll()
    }
}


extension LocalNotificationManager {
    static let shared = LocalNotificationManager()
}
