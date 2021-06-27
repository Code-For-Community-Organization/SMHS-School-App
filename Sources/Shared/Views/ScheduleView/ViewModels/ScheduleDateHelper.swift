//
//  ScheduleDateHelper.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/1/21.
//

import Foundation

struct ScheduleDateHelper {
    var subHeaderText: String {
        if Calendar.current.isDateInWeekend(mockDate ?? Date()) {
            return "School Holiday"
        }
        else {
            return "Daily Schedule"
        }
    }
    var currentWeekday: String {
        let date = mockDate ?? Date()
        let format = DateFormatter()
        format.dateFormat = "EEEE"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
        
    var todayDateDescription: String {
        let date = mockDate ?? Date()
        let format = DateFormatter()
        format.dateFormat = "MMMM d"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    var mockDate: Date?
    
    init(mockDate: Date? = nil) {
        self.mockDate = mockDate
    }
    func parseScheduleData(withRawText rawText: String?, mockDate: Date = Date(), completion: @escaping ([ScheduleWeek]) -> Void) {
        guard let rawText: String = rawText else {return}
        //CPU performance intensive operation, use background thread to avoid blocking UI
        DispatchQueue.global(qos: .utility).async {
            var scheduleWeeks = [ScheduleWeek]()
            for (line, stringIndex) in zip(rawText.lines, 0..<rawText.count) {
                //Find line that contains the date
                if line.starts(with: "DTSTART;VALUE=DATE:"){
                    //Remove unnecessary text, get date string only
                    let dateString: String = line.replacingOccurrences(of: "DTSTART;VALUE=DATE:", with: "")
                    
                    //For each day of schedule found, check if the date is a date equal to or after current date
                    let dateChecker: (Date, Date) = self.scheduleDateChecker(dateString: dateString, mockDate: mockDate)
                    
                    //.0 is the schedule's date, .1 is current date
                    if dateChecker.0 >= dateChecker.1 {
                        
                        //Parse the line of schedule text, stripping unwanted characters and words
                        if let scheduleDay: ScheduleDay = self.scheduleLineParser(line: line, rawText: rawText, stringIndex: stringIndex, date: dateChecker.0) {
                            //If id equals to 1, means Monday, so append a new week
                            if scheduleDay.dayOfTheWeek == 1 || scheduleWeeks.isEmpty {
                                scheduleWeeks.append(ScheduleWeek(scheduleDays: [scheduleDay]))
                            }
                            //If not Friday, append the `ScheduleDay` to last week in array
                            else {
                                scheduleWeeks.last?.scheduleDays.append(scheduleDay)
                            }
                        }
                        
                    }
                }
            }
            completion(scheduleWeeks)
        }
        
    }
    //Returns a Date created from given date string, at 0:00:00, and current Date
    private func scheduleDateChecker(dateString: String, mockDate: Date = Date()) -> (Date, Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: dateString)!
        let currentDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: mockDate)!
        return (date, currentDate)
    }
    
    private func scheduleLineParser(line: Substring, rawText: String, stringIndex: Int, date: Date) -> ScheduleDay? {
        let summary: String = String(rawText.lines[stringIndex+1])
        let containsDay: Bool = summary.lowercased().contains("day")
        let containsSchedule: Bool = summary.lowercased().contains("schedule")
        
        guard containsDay || containsSchedule else {return nil}
        
        let description: String = String(rawText.lines[stringIndex+2])
        let descriptionStripped: String = description.replacingOccurrences(of: "DESCRIPTION:", with: "")
        return ScheduleDay(date: date,
                           scheduleText: "\(descriptionStripped.removingRegexMatches(pattern: #"\\(?!n)"#).removingRegexMatches(pattern: #"\\n"#, replaceWith: "\n").removingRegexMatches(pattern: #"\n\n"#, replaceWith: "\n"))")
    }
}
