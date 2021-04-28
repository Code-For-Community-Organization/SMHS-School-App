//
//  ScheduleViewModel.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import Combine
import SwiftUI
import Foundation

class ScheduleViewModel: ObservableObject {
    @AppStorage("ICSText") var ICSText: String?
    @Published(key: "scheduleWeeks") var scheduleWeeks = [ScheduleWeek]()
    var subHeaderText: String {
        if Calendar.current.isDateInWeekend(Date()) {
            return "School Holiday"
        }
        else {
            return "Daily Schedule"
        }
    }
    var currentWeekday: String {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "EEEE"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    var todayScheduleText: String? {scheduleWeeks.first?.scheduleDays.first?.scheduleText}
    var currentDate: String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMMM d"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    init(placeholderText: String? = nil){
        //Handle preview instance with mock placeholder text
        if let text = placeholderText {
            self.ICSText = text
            self.scheduleWeeks = [ScheduleWeek(scheduleDays: [ScheduleDay(id: 0, date: Date(), scheduleText: "Placeholder")])]
            return
        }
        let url = URL(string: "https://www.smhs.org/calendar/calendar_379.ics")!
        //Load ICS calendar data from network
        Downloader.load(url: url){data, error in
            guard let data = data else {
                #if DEBUG
                print("Error occurred while fetching iCS: \(error!)")
                #endif
                return
            }
            //Publish changes on main thread
            DispatchQueue.main.async {
                let rawText = String(data: data, encoding: .utf8) ?? ""
                //Parse data with fetched result only if ICSText is empty (which likely means 1st time app is opened)
                if self.ICSText == nil {
                    self.parseScheduleData(withRawText: rawText){result in
                        DispatchQueue.main.async {
                            self.scheduleWeeks = result
                        }
                    }
                }
                
                self.ICSText = rawText
            }
        }
        //1st attempt at parsing, before networking
        //If ICSText is nil the parsing will fail silently, and fallback on 2nd parsing above
        self.parseScheduleData(withRawText: ICSText){result in
            DispatchQueue.main.async {
                self.scheduleWeeks = result
            }
        }
    }
    func parseScheduleData(withRawText rawText: String?, completion: @escaping ([ScheduleWeek]) -> Void) {
        guard let rawText: String = rawText else {return}
        //CPU performance intensive operation, use background thread to avoid blocking UI
        DispatchQueue.global(qos: .userInteractive).async { 
            var scheduleWeeks: [ScheduleWeek] = [ScheduleWeek]()
            var indexNumber: Int = 0
            for (line, stringIndex) in zip(rawText.lines, 0..<rawText.count) {
                //Find line that contains the date
                if line.starts(with: "DTSTART;VALUE=DATE:"){
                    //Remove unnecessary text, get date string only
                    let dateString: String = line.replacingOccurrences(of: "DTSTART;VALUE=DATE:", with: "")
                    //For each day of schedule found, check if the date is a date equal to or after current date
                    let dateChecker: (Date, Date) = self.scheduleDateChecker(dateString: dateString)
                    //.0 is the schedule's date, .1 is current date
                    if dateChecker.0 >= dateChecker.1 {
                        //Parse the line of schedule text, stripping unwanted characters and words
                        if let scheduleDay: ScheduleDay = self.scheduleLineParser(line: line, rawText: rawText, stringIndex: stringIndex, indexNumber: indexNumber, date: dateChecker.0) {
                            //indexNumber starts at 0, increase by 1 with each schedule day found
                            //Divisible by 5 means a Friday, so create a new `ScheduleWeek` to hold more `ScheduleDay`
                            if (indexNumber) % 5 == 0 || indexNumber == 0 {
                                scheduleWeeks.append(ScheduleWeek(scheduleDays: [scheduleDay]))
                            }
                            //If not Friday, append the `ScheduleDay` to last week in array
                            else {
                                scheduleWeeks.last?.scheduleDays.append(scheduleDay)
                            }
                            indexNumber += 1
                        }
                        
                    }
                }
            }
            completion(scheduleWeeks)
        }
        
    }
    func scheduleDateChecker(dateString: String) -> (Date, Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: dateString)!
        let currentDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        return (date, currentDate)
    }
    func scheduleLineParser(line: Substring, rawText: String, stringIndex: Int, indexNumber: Int, date: Date) -> ScheduleDay? {
        //Parse summary, and description (block text of schedule)
        let summary = rawText.lines[stringIndex+1].replacingOccurrences(of: "SUMMARY:", with: "")
        guard summary.lowercased().contains("day") else {return nil}
        let description = String(rawText.lines[stringIndex+2]).replacingOccurrences(of: "DESCRIPTION:", with: "")
        return ScheduleDay(id: indexNumber,
                           date: date,
                           scheduleText: "\(description.removingRegexMatches(pattern: #"\\(?!n)"#).removingRegexMatches(pattern: #"\\n"#, replaceWith: "\n").removingRegexMatches(pattern: #"\n\n"#, replaceWith: "\n"))")
    }
}
struct Downloader {
    static func load(url: URL, completion: @escaping (Data?, Error?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil, error!)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
}
