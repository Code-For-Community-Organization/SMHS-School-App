//
//  ScheduleCustomViewModel.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/19/21.
//

import Combine
import Foundation

class ScheduleCustomViewModel: ObservableObject {
    @Published var selection: ScheduleDay?
    @Published var startTime: Date = makeCurrentDateComponentTime(hours: 15, minutes: 0)
    @Published var endTime: Date = makeCurrentDateComponentTime(hours: 16, minutes: 0)
    @Published var title: String = ""
    @Published var showAlert = false
    static func makeCurrentDateComponentTime(hours: Int, minutes: Int) -> Date {
        var dateComponent = DateComponents()
        dateComponent.hour = hours
        dateComponent.minute = minutes
        return Calendar.current.date(from: dateComponent)!
    }
    
    func validateSelection() -> Bool {
        if !title.isEmpty && selection != nil && endTime > startTime {return true}
        return false
    } 
}
