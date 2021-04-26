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
        if let text = placeholderText {
            self.ICSText = text
            return
        }
        let url = URL(string: "https://www.smhs.org/calendar/calendar_379.ics")!
        Downloader.load(url: url){data, error in
            guard let data = data else {
                print("Error occurred while fetching iCS: \(error!)")
                return
            }
            DispatchQueue.main.async {
                let rawText = String(data: data, encoding: .utf8) ?? ""
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
        self.parseScheduleData(withRawText: ICSText){result in
            DispatchQueue.main.async {
                self.scheduleWeeks = result
            }
        }
    }
    func parseScheduleData(withRawText rawText: String?, completion: @escaping ([ScheduleWeek]) -> Void) {
        guard let rawText = rawText else {return}
        //ICSText is fetched from networking the calendar ICS URL
        DispatchQueue.global(qos: .userInteractive).async {
            print("started parsing")
            var scheduleWeeks = [ScheduleWeek]()
            var indexNumber = 0
            for (line, stringIndex) in zip(rawText.lines, 0..<rawText.count) {
                //Find line that contains the date
                print("start iteration \(indexNumber)")
                if line.starts(with: "DTSTART;VALUE=DATE:"){
                    //Remove unnecessary text, get date string only
                    let dateString = line.replacingOccurrences(of: "DTSTART;VALUE=DATE:", with: "")
                    let dateChecker = self.scheduleDateChecker(dateString: dateString)
                    if dateChecker.0 >= dateChecker.1 {
                        print("ready to parse")
                        if let scheduleDay = self.scheduleLineParser(line: line, rawText: rawText, stringIndex: stringIndex, indexNumber: indexNumber, date: dateChecker.0) {
                            print("parse finished")
                            if (indexNumber) % 5 == 0 || indexNumber == 0 {
                                scheduleWeeks.append(ScheduleWeek(scheduleDays: [scheduleDay]))
                            }
                            else {
                                scheduleWeeks.last?.scheduleDays.append(scheduleDay)
                            }
                            indexNumber += 1
                        }
                        
                    }
                }
                print("\(indexNumber) iteration finished")
            }
            completion(scheduleWeeks)
        }
        
    }
    func scheduleDateChecker(dateString: String) -> (Date, Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: dateString)!
        let currentDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        print("Date")
        return (date, currentDate)
    }
    func scheduleLineParser(line: Substring, rawText: String, stringIndex: Int, indexNumber: Int, date: Date) -> ScheduleDay? {
        //Parse summary, and description (block text of schedule)
        let summary = rawText.lines[stringIndex+1].replacingOccurrences(of: "SUMMARY:", with: "")
        guard summary.lowercased().contains("day") else {return nil}
        let description = String(rawText.lines[stringIndex+2]).replacingOccurrences(of: "DESCRIPTION:", with: "")
        print("parse line")
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
