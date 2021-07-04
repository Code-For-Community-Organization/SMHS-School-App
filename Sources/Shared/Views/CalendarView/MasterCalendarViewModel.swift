//
//  MasterCalendarViewModel.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/4/21.
//

import Combine
import Foundation
import SwiftSoup

class MasterCalendarViewModel: ObservableObject {
    @Published(key: "calendarManager") var calendarManager = CalendarManager()
    @Storage(key: "lastReloadTime", defaultValue: nil) var lastReloadTime: Date?
    
    func reloadData(completion: @escaping () -> ()) {
        if let time = lastReloadTime, !calendarManager.days.isEmpty {
            completion()
            if abs(Date().timeIntervalSince(time)) > TimeInterval(0) {
                lastReloadTime = Date()
                fetchData{completion()}
            }
        }
        else {
            lastReloadTime = Date()
            fetchData{completion()}
        }
    }
    func fetchData(from startDate: Date = Date(),
                   to endDate: Date = Calendar.current.date(byAdding: .month, value: 3, to: Date())!,
                   completion: @escaping () -> ()) {
        print("Fetching calendar data")
        let months = endDate.months(from: startDate)
        var inBetweenMonths = [String]()
        guard endDate > startDate else {return}
        for i in 0...months {
            var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: startDate)
            dateComponents.month = dateComponents.month?.advanced(by: i)
            dateComponents.day = 1
            let date = Calendar.current.date(from: dateComponents)
            guard let date = date else {return}
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedDate = dateFormatter.string(from: date)
            inBetweenMonths.append(formattedDate)
        }
        let dispatchGroup = DispatchGroup()
        for month in inBetweenMonths {
            dispatchGroup.enter()
            Downloader.load("https://www.smhs.org/fs/elements/18885?is_draft=false&is_load_more=true&parent_id=18885&_=1622830844463&cal_date=\(month)"){data, error in
                guard let data = data else {
                    #if DEBUG
                    print("\(error!)")
                    return
                    #endif
                }
                guard let htmlText = String(data: data, encoding: .ascii) else {
                    #if DEBUG
                    print("Unable to convert data to ascii string, will return")
                    #endif
                    return
                }
                do {
                    let html = try SwiftSoup.parse(htmlText)
                    let daysElement = try html.select("div.fsCalendarDaybox.fsStateHasEvents:not(.fsCalendarOutOfRange)")
                    for day in daysElement {
                        let childrenElement = day.children()
                        let dateString = "\(try childrenElement.attr("data-year"))-\(Int(try childrenElement.attr("data-month"))!+1)-\(try childrenElement.attr("data-day"))"
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-M-d"
                        let formattedDate = dateFormatter.date(from: dateString)!
                        var events = [CalendarEvent]()
                        for event in try day.select("div.fsCalendarInfo") {
                            let eventTitle = try event.select("a.fsCalendarEventTitle.fsCalendarEventLink").text()
                            let timeRange = try event.select("div.fsTimeRange")
                            let startTime = try timeRange.select("time.fsStartTime").attr("datetime")
                            let endTime = try timeRange.select("time.fsEndTime").attr("datetime")
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                            guard !eventTitle.isEmpty else {continue}
                            guard let startTime = dateFormatter.date(from: startTime),
                                  let endTime = dateFormatter.date(from: endTime) else {
                                events.append(.init(title: eventTitle, isFullDay: true))
                                continue
                            }
                            events.append(.init(title: eventTitle,
                                                startTime: startTime,
                                                endTime: endTime))
                        }
                        let day = CalendarDay(date: formattedDate, events: events)
                        DispatchQueue.main.async {
                            self.calendarManager.days[day.date] = day
                        }
                    }
                }
                catch Exception.Error(type: let type, Message: let message) {
                    #if DEBUG
                    print("Error of type \(type), \(message)")
                    #endif
                }
                catch {
                    #if DEBUG
                    print("Unknown error")
                    #endif
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}
