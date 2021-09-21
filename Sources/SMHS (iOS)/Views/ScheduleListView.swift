//
//  ScheduleListView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 4/25/21.
//

import SwiftUI

struct ScheduleListView: View {
    var scheduleViewModel: SharedScheduleInformation
    @State var presentCalendar = false
    @StateObject var masterCalendarViewModel = MasterCalendarViewModel()
    
    var body: some View {
        GeometryReader {geo in
            List{
                Section(header: ScheduleListHeaderText(subHeaderText: scheduleViewModel.dateHelper.subHeaderText)){EmptyView()}
                Section(header: ScheduleListBanner(present: $presentCalendar, action: {
                    masterCalendarViewModel.reloadData {
                        presentCalendar = true
                    }
                    
                }, geometryProxy: geo)){EmptyView()}
                // TODO: Fix persistent storage issue with custom schedules
                //Section(header: ScheduleListBanner(presentModal: $presentModal, geometryProxy: geo)){EmptyView()}
                ForEach(scheduleViewModel.scheduleWeeks, id: \.self){scheduleWeek in
                    Section(header: ScheduleListHeaderView(scheduleWeek: scheduleWeek)) {
                        ForEach(scheduleWeek.scheduleDays, id: \.self) {day in
                            NavigationLink(
                                destination: ScrollView {ScheduleDetailView(scheduleDay: day).padding(.top, 40)}
                                ,
                                label: {
                                    Text(day.title)
                                        .textAlign(.leading)
                                    
                                })
                        }
                    }
                    .textCase(nil)
                }
                .listItemTint(appSecondary)
            }
            .listStyle(InsetGroupedListStyle())
            .fullScreenCover(isPresented: $presentCalendar) {
                MasterCalendarView(calendarViewModel: masterCalendarViewModel)
            }
        }

    }
}
