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
    var body: some View {
        List{
            Section(header:
                        Text(scheduleViewModel.dateHelper.subHeaderText)
                        .fontWeight(.semibold)
                        .font(.title2)
                        .textAlign(.leading)
                        .foregroundColor(.platformSecondaryLabel)
                
            ){EmptyView()}
            .textCase(nil)
            ForEach(scheduleViewModel.scheduleWeeks, id: \.self){scheduleWeek in
                Section(header: ScheduleListHeaderView(scheduleWeek: scheduleWeek)) {
                    ForEach(scheduleWeek.scheduleDays, id: \.self) {day in
                        NavigationLink(
                            destination: ClassScheduleView(scheduleText: day.scheduleText)
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

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView(scheduleViewModel: ScheduleViewModel.mockScheduleView)
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
