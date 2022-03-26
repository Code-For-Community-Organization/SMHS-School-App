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
    
    //Preferred API for fetching calendar data
    //Because networking is resource intensive,
    //this make sure that reload is not too frequent
    func reloadData(completion: @escaping () -> ()) {
        if let time = lastReloadTime, !calendarManager.days.isEmpty {
            // Minimum reload interval - 24 hours
            if abs(Date().timeIntervalSince(time)) > TimeInterval(86400) {
                lastReloadTime = Date()
                fetchData{completion()}
            }
            completion()
        }
        else {
            lastReloadTime = Date()
            fetchData{completion()}
        }
    }
    
    func getFirstDayOfYear() -> Date {
        // Get the current year
        let year = Calendar.current.component(.year, from: Date())
        
        // Get the last day of last year
        if let lastDay = Calendar.current.date(from: DateComponents(year: year - 1, month: 1, day: 1)) {
            // Get the first day of the current year
            if let firstDay = Calendar.current.date(byAdding: .day, value: +1, to: lastDay) {
                return firstDay
            }
            else {
                preconditionFailure("Cannot get first day of this year")
            }
        }
        else {
            preconditionFailure("Cannot get last day of last year")
        }
    }
    
    func getInBetweenMonths(forStart startDate: Date, endDate: Date) -> [String]? {
        //Compute dates of each month in bewteen 2 given dates
        computeMonths: do {
            var inBetweenMonths = [String]()
            let months = endDate.months(from: startDate)
            guard endDate > startDate else {return nil}
            for i in 0...months {
                var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: startDate)
                dateComponents.month = dateComponents.month?.advanced(by: i)
                dateComponents.day = 1
                let date = Calendar.current.date(from: dateComponents)
                guard let _date = date else { return nil }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let formattedDate = dateFormatter.string(from: _date)
                inBetweenMonths.append(formattedDate)
            }
            return inBetweenMonths
        }
        
    }
    //- Parameters:
    //startDate: The starting range of dates to fetch calendar information for
    //endDate: The ending range of dates to fetch calendar information for
    //completion: Handler to notify when networking is finished
    func fetchData(from startDate: Date = Date(),
                   to endDate: Date = Calendar.current.date(byAdding: .month, value: 3, to: Date())!,
                   completion: @escaping () -> ()) {
        guard let inBetweenMonths = getInBetweenMonths(forStart: getFirstDayOfYear(),
                                                       endDate: endDate)
        else { return }
    
        let dispatchGroup = DispatchGroup()
        for month in inBetweenMonths {
            dispatchGroup.enter()
            Downloader.load("https://www.smhs.org/fs/elements/18885?is_draft=false&is_load_more=true&parent_id=18885&_=1622830844463&cal_date=\(month)"){data, error in
                guard let data = data else {
                    #if DEBUG
                    print("\(error!)")
                    #endif
                    return
                }
                guard let htmlText = String(data: data, encoding: .ascii) else {
                    #if DEBUG
                    print("Unable to convert data to ascii string, will return")
                    #endif
                    return
                }
                self.parseCalendarFromHTML(htmlText)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    func parseCalendarFromHTML(_ htmlText: String) {
        do {
            let html = try SwiftSoup.parse(htmlText)
            let css = "div.fsCalendarDaybox.fsStateHasEvents:not(.fsCalendarOutOfRange)"
            let daysElement = try html.select(css)
            for day in daysElement {
                let childrenElement = day.children()
                let dateString = "\(try childrenElement.attr("data-year"))-\(Int(try childrenElement.attr("data-month"))!+1)-\(try childrenElement.attr("data-day"))"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-M-d"
                let formattedDate = dateFormatter.date(from: dateString)!
                let events: [CalendarEvent] = try day.select("div.fsCalendarInfo")
                    .compactMap {event in
                        let eventTitle = try event.select("a.fsCalendarEventTitle.fsCalendarEventLink").text()
                        let timeRange = try event.select("div.fsTimeRange")
                        let startTime = try timeRange.select("time.fsStartTime").attr("datetime")
                        let endTime = try timeRange.select("time.fsEndTime").attr("datetime")
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        guard !eventTitle.isEmpty else { return nil }
                        
                        guard let _startTime = dateFormatter.date(from: startTime),
                              let _endTime = dateFormatter.date(from: endTime) else {
                            return .init(title: eventTitle, isFullDay: true)
                        }
                        return .init(title: eventTitle,
                                            startTime: _startTime,
                                            endTime: _endTime)
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
    }
}
