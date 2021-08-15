//
//  ScheduleListView.swift
//  SMHSSchedule (macOS)
//
//  Created by Jevon Mao on 4/27/21.
//

import SwiftUI

struct ScheduleListView: View {
    var scheduleViewModel: ScheduleViewModel
    @State var selected: ScheduleDay?
    var body: some View {
        List {
            ForEach(scheduleViewModel.scheduleWeeks, id: \.self) { scheduleWeek in
                Section(header: ScheduleListHeaderView(scheduleWeek: scheduleWeek)
                ) {
                    ForEach(scheduleWeek.scheduleDays, id: \.self) { day in
                        NavigationLink(
                            destination: VStack {
                                Spacer()
                                ClassScheduleView(scheduleText: day.scheduleText)
                            },
                            tag: day,
                            selection: $selected,
                            label: {
                                Text(day.title).textAlign(.leading)
                                    .onTapGesture {
                                        self.selected = day
                                    }
                            }
                        )
                    }
                }
                .textCase(nil)
            }
            .listItemTint(Color.secondary)
        }
        .listStyle(SidebarListStyle())
        .onAppear {
            selected = scheduleViewModel.scheduleWeeks.first?.scheduleDays.first
        }
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView(scheduleViewModel: ScheduleViewModel.mockScheduleView)
    }
}
