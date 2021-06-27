//
//  ScheduleCustomViewModel.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/19/21.
//

import Combine
import Foundation

final class ScheduleCustomViewModel: ObservableObject {
    @Published var selection: ScheduleDay = ScheduleDay.sampleScheduleDay
    @Published var startTime: Date = makeCurrentDateComponentTime(hours: 15, minutes: 0)
    @Published var endTime: Date = makeCurrentDateComponentTime(hours: 16, minutes: 0)
    @Published var title: String = ""
    @Published var showAlert = false
    static func makeCurrentDateComponentTime(hours: Int, minutes: Int) -> Date {
        var dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                            from: Date())
        dateComponent.hour = hours
        dateComponent.minute = minutes
        dateComponent.second = 0
        return Calendar.current.date(from: dateComponent)!
    }
    
    func validateAndCreate(scheduleDay: ScheduleDay) -> (validated: Bool, block: ClassPeriod?) {
        //Verify existing periods time don't overlap with custom block's time
        guard let first = scheduleDay.periods.first,
              let last = scheduleDay.periods.last else {return (false, nil)}
        let existingDayRange = first.startTime...last.endTime
        
        if !title.isEmpty &&
            endTime > startTime &&
            !existingDayRange.contains(startTime.convertToReferenceDateLocalTime()) &&
            !existingDayRange.contains(endTime.convertToReferenceDateLocalTime())
        {
            let customBlock = ClassPeriod(customTitle: title,
                                          startTime: startTime.convertToReferenceDateLocalTime(),
                                          endTime: endTime.convertToReferenceDateLocalTime())
            return (true, customBlock) 
        }
        return (false, nil)
    } 
}
