//
//  Widgets.swift
//  Widgets
//
//  Created by Jevon Mao on 5/1/21.
//

import WidgetKit
import SwiftUI
import SwiftUIVisualEffects
import SFSafeSymbols
import Firebase

struct Provider: TimelineProvider {
    let viewModel: SharedScheduleInformation = {
        FirebaseApp.configure()
        globalRemoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()

        #if DEBUG
        settings.minimumFetchInterval = 0
        #else
        let sixHours = 60 * 60 * 6
        settings.minimumFetchInterval = TimeInterval(sixHours)
        #endif

        globalRemoteConfig.configSettings = settings
        globalRemoteConfig.fetch {status, error in
            if status == .success {
                globalRemoteConfig.activate {_, _ in}
            } else {
                #if DEBUG
                debugPrint("Config not fetched")
                debugPrint("Error: \(error?.localizedDescription ?? "No error available.")")
                #endif
            }
        }
        return SharedScheduleInformation()
    }()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), scheduleDay: ScheduleDay(date: Date(), scheduleText: "Example Schedule Day\nWednesday, April 21 \nSpecial Virtual Day 2 \n(40 minute classes) \n\nPeriod 2                         8:00-8:40 \n\nPeriod 3                         8:45-9:25 \n(10 minute break) \n\nPeriod 4                         9:35-10:15 \n\nPeriod 5                         10:20-11:40 \n(40 minute DIVE Presentation) \n\nNutrition                      11:40-12:10 \n\nPeriod 6                         12:15-12:55 \n\nPeriod 7                         1:00-1:40 \n\nPeriod 1                         1:45-2:25 \n-------------------------------\n\n\nClasses 8:00-2:25\n\nDive Presentation\n\nB JV Tennis vs JSerra 5:30\n\nB JV/V LAX vs JSerra 7:30/5:30\n\nB JV/V Vball vs Bosco 3:00/3:00\n\nB V Basketball vs Bosco 7:00\n\nB V Golf @ Hunt Beach 3:00\n\nG JV Tennis vs Orange Luth 3:15\n\nG V LAX @ JSerra 5:30\n\nG V Tennis @ Orange Luth 2:30\n\nJV Gold Baseball vs JSerra 3:30\n\nJV/V Baseball @ South Hills 2:30/3:15\n\n\n\nV Sball vs Mission Viejo 3:30\n"))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), scheduleDay: viewModel.scheduleWeeks.first?.scheduleDays.first)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        if viewModel.currentDaySchedule == nil {
            let timeline = Timeline(entries: [SimpleEntry(date: Date(), scheduleDay: nil)], policy: .atEnd)
            completion(timeline)
        }
        else {
            guard let week = viewModel.scheduleWeeks.first else {return}
            for day in week.scheduleDays {
                entries.append(.init(date: day.date, scheduleDay: day))
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
 
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let scheduleDay: ScheduleDay?
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if let scheduleText = entry.scheduleDay?.scheduleText {
                Text(scheduleText)
                    .foregroundColor(Color.white)
                    .padding()
            }
            else {
                VStack {
                    Image(systemSymbol: .exclamationmarkTriangleFill)
                        .foregroundColor(.systemYellow)
                        .font(.largeTitle)
                    Text("Schedule Unavailable")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)

                }
                
            }
         
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
        .background(
            LinearGradient(gradient: .init(colors: [appPrimary, appPrimary.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
        )
    }
}

@main
struct Widgets: Widget {
    let kind: String = "Widgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Today's Schedule")
        .supportedFamilies([.systemLarge])
        .description("Quickly glance today's class schedule, beautifully presented on the home screen.")
    }
}

struct Widgets_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsEntryView(entry: SimpleEntry(date: Date(), scheduleDay: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
