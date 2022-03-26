//
//  ScheduleListView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 4/25/21.
//

import SwiftUI

struct ScheduleListView: View {
    @ObservedObject var scheduleViewModel: SharedScheduleInformation
    @State var presentCalendar = false
    @StateObject var masterCalendarViewModel = MasterCalendarViewModel()
    
    var body: some View {
        GeometryReader {geo in
            ScrollView {
                LazyVStack {
                    ScheduleListHeaderText(subHeaderText: scheduleViewModel.dateHelper.subHeaderText)
                        .padding(.horizontal, 16)
                    ScheduleListBanner(present: $presentCalendar, action: {
                        masterCalendarViewModel.reloadData {
                            presentCalendar = true
                        }

                    }, geometryProxy: geo)

                    ForEach(scheduleViewModel.scheduleWeeks, id: \.self){scheduleWeek in
                        VStack(spacing: 0) {
                            ScheduleListHeaderView(scheduleWeek: scheduleWeek)
                                .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                            VStack(spacing: 0) {
                                ForEach(scheduleWeek.scheduleDays, id: \.self) {day in
                                    NavigationLink(
                                        destination: ScrollView {ScheduleDetailView(scheduleDay: day).padding(.top, 40)}
                                        ,
                                        label: {
                                            HStack {
                                                Text(day.title)
                                                    .textAlign(.leading)
                                                    .foregroundColor(.platformLabel)
                                                Spacer()
                                                Image(systemSymbol: .chevronRight)
                                                    .font(Font.footnote.weight(.heavy))
                                                    .foregroundColor(Color.platformSecondaryLabel)
                                            }
                                            .font(Font.body.weight(.medium))

                                        })
                                        .padding(12)
                                        .padding(.horizontal, 2)

                                    if !scheduleWeek.isLast(day: day) {
                                        Divider()
                                            .padding(.leading, 14)
                                    }
                                }

                            }
                            .background(Color.platformBackground)
                            .roundedCorners(cornerRadius: 10)
                        }
                        .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
                        .textCase(nil)
                        .onAppear {
                            scheduleViewModel.reloadScrollList(currentWeek: scheduleWeek)
                        }
                    }
                    .listItemTint(appSecondary)

                    Spacer()

                    if scheduleViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }

                }
            }
            .fullScreenCover(isPresented: $presentCalendar) {
                MasterCalendarView(calendarViewModel: masterCalendarViewModel)
            }
        }

    }
}
