//
//  ScheduleDateHelper.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/1/21.
//

import Foundation

struct ScheduleDateHelper {
    // Using iso8601 instead of Gregorian
    // so that Monday counts as 1st day of week
    let calendar = Calendar.iso8601

    var subHeaderText: String {
        if calendar.isDateInWeekend(mockDate ?? Date()) {
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

    func parseTodayScheduleData(withRawText rawText: String?,
                                completion: @escaping (ScheduleDay) -> Void) {
        guard let rawText: String = rawText else { return }
        DispatchQueue.global(qos: .userInteractive).async {
            for (line, stringIndex) in zip(rawText.lines, 0..<rawText.count) {
                //Find line that contains the date
                guard line.starts(with: "DTSTART;VALUE=DATE:")
                else { continue }

                //Remove unnecessary text, get date string only
                let dateString = line.replacingOccurrences(of: "DTSTART;VALUE=DATE:",
                                                           with: "")

                //For each day of schedule found, check if the date
                //is a date equal to or after current date
                let dateChecker: (scheduleDate: Date,
                                  currentDate: Date) = self.scheduleDateChecker(dateString: dateString)

                if dateChecker.scheduleDate == dateChecker.currentDate {
                    guard let scheduleDay = self.scheduleLineParser(line: line,
                                                                    rawText: rawText,
                                                                    stringIndex: stringIndex,
                                                                    date: dateChecker.scheduleDate)
                    else { return }
                    completion(scheduleDay)
                    break
                }
                else {
                    continue
                }
            }


        }
    }

    func parseScheduleData(withRawText rawText: String?,
                           mockDate: Date = Date(),
                           completion: @escaping ([ScheduleWeek]) -> Void) {
        guard let rawText: String = rawText else {return}
        
        //CPU performance intensive operation,
        //use background thread to avoid blocking UI
        DispatchQueue.global(qos: .default).async {
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
                let dateChecker: (scheduleDate: Date,
                                  currentDate: Date) = self.scheduleDateChecker(dateString: dateString,
                                                                         mockDate: mockDate)

                //Make sure date not already exist in schedule weeks
                guard scheduleWeeks.last?.getDayByDate(dateChecker.scheduleDate) == nil
                else { continue }

                //Verify that the schedule's date is later than
                //today's date because no point in showing old schedule.
                guard dateChecker.scheduleDate >= dateChecker.currentDate else
                { continue }
                
                //Parse the line of schedule text, stripping unwanted characters and words
                guard let scheduleDay = self.scheduleLineParser(line: line,
                                                                rawText: rawText,
                                                                stringIndex: stringIndex,
                                                                date: dateChecker.0) else { continue }
                scheduleWeeks = getScheduleWeekWithNewDay(weeks: scheduleWeeks,
                                                          newDay: scheduleDay)
                

            }
            completion(scheduleWeeks)
        }
        
    }

    func parseScheduleXML(forDays days: [(date: String, schedule: String)]) -> [ScheduleWeek] {
        // Sort dates into weeks
        // Same week number of year means same week
        var scheduleWeek = [ScheduleWeek]()

        for day in days {
            guard let date = DateFormatter().serverTimeFormat(day.date)
            else {
                #if DEBUG
                debugPrint("⚠️ Date format failed in parseScheduleXML")
                #endif
                continue
            }
            let newDay = ScheduleDay(date: date, scheduleText: day.schedule)
            scheduleWeek = getScheduleWeekWithNewDay(weeks: scheduleWeek,
                                        newDay: newDay)
        }
        return scheduleWeek
    }

    //Appends a ScheduleDay to a ScheduleWeek
    //Determines whether the day is a new week or part of old week
    private func getScheduleWeekWithNewDay(weeks: [ScheduleWeek],
                                           newDay: ScheduleDay) -> [ScheduleWeek] {
        var weeks = weeks
        guard let previousDay = weeks.last?.scheduleDays.last else {
            weeks.append(ScheduleWeek(scheduleDays: [newDay]))
            return weeks
        }
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: newDay.date)
        let previousWeekOfYear = calendar.component(.weekOfYear, from: previousDay.date)

        //Equal week number of the year means same week
        if weekOfYear == previousWeekOfYear {
            //Append to existing last week
            guard weeks.last != nil else {
                weeks.append(ScheduleWeek(scheduleDays: [newDay]))
                return weeks
            }
            weeks.last!.scheduleDays.append(newDay)
        }
        else if weekOfYear > previousWeekOfYear {
            weeks.append(ScheduleWeek(scheduleDays: [newDay]))
        }
        else {
            #if DEBUG
            debugPrint("⚠️ Method addDayToWeek DID NOT append a new day to the week and failed silently.")
            #endif
        }
        return weeks
    }

    //Returns a Date created from given date string, at 0:00:00;
    //Also returns the current Date, at 0:00:00 time
    private func scheduleDateChecker(dateString: String, mockDate: Date = Date()) -> (Date, Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date = formatter.date(from: dateString)!
        return (date, mockDate.eraseTime())
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
