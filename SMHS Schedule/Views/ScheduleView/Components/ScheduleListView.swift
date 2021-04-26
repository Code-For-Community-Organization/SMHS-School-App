//
//  ScheduleListView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 4/25/21.
//

import SwiftUI

struct ScheduleListView: View {
    var scheduleViewModel: ScheduleViewModel
    var body: some View {
        List{
            ForEach(scheduleViewModel.scheduleWeeks, id: \.self){scheduleWeek in
                Section(header: Text(scheduleWeek.weekText)) {
                    ForEach(scheduleWeek.scheduleDays, id: \.self) {day in
                        NavigationLink(
                            destination: ClassScheduleView(scheduleText: day.scheduleText),
                            label: {
                                Text(day.title)
                                    .textAlign(.leading)

                            })
                    }
                }
                .textCase(nil)
  
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView(scheduleViewModel: mockScheduleView)
    }
}
