//
//  ScheduleListView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 4/25/21.
//

import SwiftUI

struct ScheduleListView: View {
    var scheduleViewModel: ScheduleViewModel
    @State var tappedItem: ScheduleWeek?
    @Binding var presentModal: Bool
    @State var presentCalendar = false

    var body: some View {
        List{
            Section(header: ScheduleListHeaderText(subHeaderText: scheduleViewModel.dateHelper.subHeaderText)){EmptyView()}
            Section(header: Button("Master Calendar", action: {presentCalendar = true})){EmptyView()}
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
            .listItemTint(Color.secondary)
        }
        .listStyle(InsetGroupedListStyle())
        .fullScreenCover(isPresented: $presentCalendar) {
            MasterCalendarView(showCalendar: $presentCalendar)
        }
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView(scheduleViewModel: ScheduleViewModel.mockScheduleView, presentModal: .constant(true))
    }
}

