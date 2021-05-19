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

    var body: some View {
        GeometryReader {geo in
            List{
                Section(header: ScheduleListHeaderText(subHeaderText: scheduleViewModel.dateHelper.subHeaderText)){EmptyView()}
                Section(header: ScheduleListBanner(presentModal: $presentModal, geometryProxy: geo)){EmptyView()}
                ForEach(scheduleViewModel.scheduleWeeks, id: \.self){scheduleWeek in
                    Section(header: ScheduleListHeaderView(scheduleWeek: scheduleWeek)) {
                        ForEach(scheduleWeek.scheduleDays, id: \.self) {day in
                            NavigationLink(
                                destination: ClassScheduleView(scheduleDay: day).padding(.top, 40)
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
        }
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView(scheduleViewModel: ScheduleViewModel.mockScheduleView, presentModal: .constant(true))
    }
}

struct FillAll: View {
    let color: Color
    
    var body: some View {
        GeometryReader { proxy in
            self.color.frame(width: proxy.size.width * 1.3).fixedSize()
        }
    }
}
