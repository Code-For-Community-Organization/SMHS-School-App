//
//  ScheduleDateHelper.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/1/21.
//

import Foundation

struct ScheduleDateHelper {
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
        
    var currentDate: String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMMM d"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    
    func parseScheduleData(withRawText rawText: String?, completion: @escaping ([ScheduleWeek]) -> Void) {
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
                    let dateChecker: (Date, Date) = self.scheduleDateChecker(dateString: dateString)
                    
                    //.0 is the schedule's date, .1 is current date
                    if dateChecker.0 >= dateChecker.1 {
                        
                        //Parse the line of schedule text, stripping unwanted characters and words
                        if let scheduleDay: ScheduleDay = self.scheduleLineParser(line: line, rawText: rawText, stringIndex: stringIndex, date: dateChecker.0) {
                            
                            //If id equals to 1, means Monday, so append a new week
                            if scheduleDay.id == 1 || scheduleWeeks.isEmpty {
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
    func scheduleDateChecker(dateString: String) -> (Date, Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: dateString)!
        let currentDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        return (date, currentDate)
    }
    
    func scheduleLineParser(line: Substring, rawText: String, stringIndex: Int, date: Date) -> ScheduleDay? {
        //Parse summary, and description (block text of schedule)
        let summary: String = String(rawText.lines[stringIndex+1])
        guard summary.lowercased().contains("day") else {return nil}
        let description: String = String(rawText.lines[stringIndex+2])
        let descriptionStripped: String = description.replacingOccurrences(of: "DESCRIPTION:", with: "")
        //id is the current weekday represented by integer
        return ScheduleDay(id: Date.getDayOfTheWeek(for: date),
                           date: date,
                           scheduleText: "\(descriptionStripped.removingRegexMatches(pattern: #"\\(?!n)"#).removingRegexMatches(pattern: #"\\n"#, replaceWith: "\n").removingRegexMatches(pattern: #"\n\n"#, replaceWith: "\n"))")
    }
}
