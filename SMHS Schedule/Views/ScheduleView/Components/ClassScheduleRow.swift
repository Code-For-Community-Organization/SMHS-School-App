//
//  ClassScheduleRow.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 4/21/21.
//

import SwiftUI

struct ClassScheduleRow: View {
    var scheduleDay: ScheduleDay
    var isActive: Binding<Bool> {Binding(get: {return scheduleDay.id == 0 ? true : false}, set: {_ in })}
    var body: some View {
        NavigationView{
            NavigationLink(
                destination: ClassScheduleView(scheduleText: scheduleDay.scheduleText),
                isActive: isActive,
                label: {
                    Text(scheduleDay.title)
                })
        }

    }
}

struct ClassScheduleRow_Previews: PreviewProvider {
    static var previews: some View {
        ClassScheduleRow(scheduleDay: ScheduleDay(id: 0, date: Date(), scheduleText: "Test"))
    }
}
