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
    
    func parseScheduleData(withRawText rawText: String?,
                           mockDate: Date = Date(),
                           completion: @escaping ([ScheduleWeek]) -> Void) {
        guard let rawText: String = rawText else {return}
        
        //CPU performance intensive operation,
        //use background thread to avoid blocking UI
        DispatchQueue.global(qos: .userInteractive).async {
            var scheduleWeeks = [ScheduleWeek]()
            for (line, stringIndex) in zip(rawText.lines,
                                           0..<rawText.count) {
                
                //Find line that contains the date
                guard line.starts(with: "DTSTART;VALUE=DATE:") else { continue }
                
                //Remove unnecessary text, get date string only
                let dateString = line.replacingOccurrences(of: "DTSTART;VALUE=DATE:",
                                                           with: "")
                
                //For each day of schedule found, check if the date
                //is a date equal to or after current date
                let dateChecker: (Date, Date) = self.scheduleDateChecker(dateString: dateString,
                                                                         mockDate: mockDate)
                //Verify that the schedule's date is later than
                //today's date because no point in showing old schedule.
                guard dateChecker.0 >= dateChecker.1 else { continue }
                
                //Parse the line of schedule text, stripping unwanted characters and words
                guard let scheduleDay = self.scheduleLineParser(line: line,
                                                             rawText: rawText,
                                                             stringIndex: stringIndex,
                                                                date: dateChecker.0) else { continue }
                //If id equals to 1, means Monday, so append a new week
                if scheduleDay.dayOfTheWeek == 1 || scheduleWeeks.isEmpty {
                    scheduleWeeks.append(ScheduleWeek(scheduleDays: [scheduleDay]))
                }
                //If not Friday, append the `ScheduleDay` to last week in array
                else {
                    scheduleWeeks.last?.scheduleDays.append(scheduleDay)
                }
            }
            completion(scheduleWeeks)
        }
        
    }
    //Returns a Date created from given date string, at 0:00:00;
    //Also returns the current Date, at 0:00:00 time
    private func scheduleDateChecker(dateString: String, mockDate: Date = Date()) -> (Date, Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: dateString)!
        let currentDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: mockDate)!
        return (date, currentDate)
    }
    
    //Constructs a ScheduleDay object from a given
    //line of schedule date
    private func scheduleLineParser(line: Substring, rawText: String, stringIndex: Int, date: Date) -> ScheduleDay? {
        let summary: String = String(rawText.lines[stringIndex+1])
        let containsDay: Bool = summary.lowercased().contains("day")
        let containsSchedule: Bool = summary.lowercased().contains("schedule")
        
        //Handle false positive case where
        //no schedule information of interest is found
        guard containsDay || containsSchedule else {return nil}
        
        //The full schedule information, containing classes
        //and their respective start and end times;
        //Also contains preformatted newlines
        let description: String = String(rawText.lines[stringIndex+2])
        
        //Strip the DESCRIPTION: identifier at start of description text
        let descriptionStripped: String = description.replacingOccurrences(of: "DESCRIPTION:", with: "")
        return ScheduleDay(date: date,
                           scheduleText: "\(descriptionStripped.removingRegexMatches(pattern: #"\\(?!n)"#).removingRegexMatches(pattern: #"\\n"#, replaceWith: "\n").removingRegexMatches(pattern: #"\n\n"#, replaceWith: "\n"))")
    }
}
