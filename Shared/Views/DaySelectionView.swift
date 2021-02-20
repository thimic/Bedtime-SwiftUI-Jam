//
//  DaySelectionView.swift
//  Bedtime
//
//  Created by Michael Thingnes on 20/02/21.
//

import SwiftUI

extension Array where Element: Equatable {
    mutating func remove(element: Element) {
        if let i = firstIndex(of: element) {
            self.remove(at: i)
        }
    }
}

struct DaySelectionView: View {
    
    @EnvironmentObject var model: BedtimeModel
    
    @Binding var schedule: Schedule
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(Weekday.allCases, id: \.self) { weekday in
                VStack {
                    Text(weekday.letter)
                        .fixedSize()
                        .font(.headline)
                        .frame(width: 14, height: 14)
                        .padding(12)
                        .background(
                            Circle()
                                .foregroundColor(schedule.weekdays.contains(weekday) ? .accentColor : .clear)
                        )
                        .padding(4)
                        .padding(.top, 4)
                    Circle()
                        .frame(width: 5, height: 5)
                        .foregroundColor(model.takenWeekdays.contains(weekday) ? .gray : .clear)
                        .padding(.bottom, 8)
                }
                .onTapGesture {
                    if model.takenWeekdays.contains(weekday) { return }
                    if schedule.weekdays.contains(weekday) {
                        schedule.weekdays.remove(element: weekday)
                    } else {
                        schedule.weekdays.append(weekday)
                    }
                }
            }
        }
    }
}

struct DaySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Block(header: Text("Days Active")) {
            Cell {
                DaySelectionView(schedule: .constant(BedtimeModel.example.schedules.first!))
            }
        }
        .padding()
        .backgroundColour(Color(UIColor.secondarySystemBackground))
        .environmentObject(BedtimeModel.example)
        .previewLayout(.sizeThatFits)
        .preferredColorScheme(.dark)
    }
}
