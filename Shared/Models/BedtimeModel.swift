//
//  BedtimeModel.swift
//  Bedtime
//
//  Created by Michael Thingnes on 20/02/21.
//

import Foundation

extension CaseIterable where Self: Equatable {

    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}


extension DateComponents {
    
    var timeString: String {
        let date = Calendar.current.date(from: self)!
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}


enum Weekday: String, CaseIterable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    var dateComponent: DateComponents? {
        guard let index = self.index else { return nil}
        return DateComponents(weekday: index)
    }
    
    var shortName: String {
        String(rawValue.prefix(3))
    }
    
    var letter: String {
        String(rawValue.prefix(1))
    }
    
    static let weekend: Set = [saturday, sunday]
    static let weekdays: Set = [monday, tuesday, wednesday, thursday, friday]
}


struct Schedule : Hashable, Identifiable {

    let id: UUID = UUID()
    var weekdays: [Weekday]
    var bedtime: DateComponents
    var wakeup: DateComponents
    var alarm: Bool = true
    var volume: Double = 1.0
    var sound: String = "Early Riser"
    var snooze: Bool = true
    
    var duration: TimeInterval {
        var wakeupDate = Calendar.current.date(from: wakeup)!
        let bedtimeDate = Calendar.current.date(from: bedtime)!
        if wakeupDate < bedtimeDate {
            wakeupDate.addTimeInterval(24 * 60 * 60)
        }
        return bedtimeDate.distance(to: wakeupDate)
    }
    
    var durationAsString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief
        formatter.maximumUnitCount = 2
        
        return formatter.string(from: duration)!
    }
    
    var dayList: String {
        switch Set(weekdays) {
        case Weekday.weekend:
            return "Weekends"
        case Weekday.weekdays:
            return "Week Days"
        default:
            break
        }

        switch weekdays.count {
        case 0:
            return "N/A"
        case 1:
            return weekdays.first!.rawValue
        case 2:
            return "\(weekdays.first!.shortName) and \(weekdays.last!.shortName)"
        default:
            var string = ""
            for (index, weekday) in weekdays.enumerated() {
                if index == 0 {
                    string.append(weekday.shortName)
                    continue
                }
                if index == weekdays.count - 1 {
                    string.append(", and \(weekday.shortName)")
                    continue
                }
                string.append(", \(weekday.shortName)")
            }
            return string
        }

    }
    
    static let standard = Schedule(
        weekdays: [],
        bedtime: DateComponents(hour: 22, minute: 00),
        wakeup: DateComponents(hour: 7, minute: 30)
    )
}


class BedtimeModel : ObservableObject {
    
    init(_ schedules: [Schedule] = [], sleepGoalHours: Int = 8, sleepGoalMinutes: Int = 0) {
        self.schedules = schedules
        self.sleepGoalHours = sleepGoalHours
        self.sleepGoalMinutes = sleepGoalMinutes
    }
    
    @Published var schedules: [Schedule]
    @Published var override: Schedule?
    @Published var sleepGoalHours: Int
    @Published var sleepGoalMinutes: Int
    
    var sleepGoalDuration: TimeInterval {
        let dateComponents = DateComponents(hour: sleepGoalHours, minute: sleepGoalMinutes)
        return Calendar.current.date(from: DateComponents())!.distance(to: Calendar.current.date(from: dateComponents)!)
    }
    
    var next: Schedule? {
        let weekday = Calendar.current.component(.weekday, from: Date())
        let schedules: [Schedule] = schedules.compactMap({ schedule in
            let weekdays = schedule.weekdays.map { wd in wd.index }
            if weekdays.contains(weekday) {
                return schedule
            }
            return nil
        })
        if let schedule = schedules.first {
            return schedule
        }
        return nil
    }
    
    var takenWeekdays: [Weekday] {
        schedules.flatMap { shedule in shedule.weekdays }
    }
    
    var availableWeekdays: [Weekday] {
        Weekday.allCases.difference(from: takenWeekdays)
    }
    
}

extension BedtimeModel {
    
    static var example = BedtimeModel(
        [
            Schedule(
                weekdays: [.monday],
                bedtime: DateComponents(hour: 22, minute: 30),
                wakeup: DateComponents(hour: 6, minute: 25)
            ),
            Schedule(
                weekdays: [.wednesday, .thursday, .friday],
                bedtime: DateComponents(hour: 23, minute: 30),
                wakeup: DateComponents(hour: 7, minute: 25)
            ),
            Schedule(
                weekdays: [.saturday, .sunday],
                bedtime: DateComponents(hour: 0, minute: 0),
                wakeup: DateComponents(hour: 8, minute: 0),
                alarm: false
            )
        ]
    )
    
}
