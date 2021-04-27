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
        #if os(iOS)
            platformView
            .listStyle(InsetGroupedListStyle())
        #elseif os(macOS)
        platformView
            .listStyle(SidebarListStyle())
        #endif
    }
    var platformView: some View {
        List{
            ForEach(scheduleViewModel.scheduleWeeks, id: \.self){scheduleWeek in
                Section(header: HStack {
                    Label(
                        title: {
                            Text(scheduleWeek.weekText)
                                .font(.callout)
                                .fontWeight(.semibold)
                        },
                        icon: {
                            Image(systemSymbol: .calendar)
                                .scaleEffect(1.2)
                        }
                    )
                    .foregroundColor(Color.primary)
                    Spacer()
                }) {
                    ForEach(scheduleWeek.scheduleDays, id: \.self) {day in
                        NavigationLink(
                            destination: VStack{
                                Spacer()
                                ClassScheduleView(scheduleText: day.scheduleText)
                            },
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
 
    }
}
struct CustomHeader: View {
    let name: String
    let color: Color

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(name)
                Spacer()
            }
            Spacer()
        }
        .padding(0).background(FillAll(color: color))
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

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView(scheduleViewModel: mockScheduleView)
    }
}
