//
//  ClassPeriod.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import Foundation
import Regex

struct ScheduleDay: Hashable, Identifiable, Codable {
    internal init(id: Int, date: Date, scheduleText: String, mockDate: Date? = nil) {
        self.id = id
        self.date = date
        self.scheduleText = scheduleText
        self.mockDate = mockDate
    }
    var mockDate: Date?
    var id: Int
    var date: Date
    var scheduleText: String
    var periods: [ClassPeriod] {
        parseClassPeriods()
    }
    fileprivate var currentDate: Date {
        return mockDate ?? Date()
    }
    private var currentDateReferenceTime: Date? {currentDate.convertToReferenceDateLocalTime()}
    var title: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    func getCurrentPeriodRemainingTime(selectionMode: PeriodCategory) -> TimeInterval? {
        if let endTime = getCurrentPeriod(selectionMode: selectionMode)?.endTime, 
           let reference = currentDateReferenceTime {
            return endTime - reference
        }
        return nil
    }
    
    func getCurrentPeriodRemainingPercent(selectionMode: PeriodCategory) -> Double? {
        if let endTime = getCurrentPeriod(selectionMode: selectionMode)?.endTime,
           let startTime = getCurrentPeriod(selectionMode: selectionMode)?.startTime,
           let timeRemaining = getCurrentPeriodRemainingTime(selectionMode: selectionMode) {
            let totalTime = endTime - startTime
            return timeRemaining / totalTime
        }
        return nil
    }
    
    func getCurrentPeriod(selectionMode: PeriodCategory) -> ClassPeriod? {
        //Filter for periods that are possible as current period
        //Current time within period start/end time
        periods.filter {
            //All all periods that contains current time in between its start/end time
            guard (currentDateReferenceTime?.isBetween($0.startTime, and: $0.endTime)) ?? false else {
                return false
            }
            //Compare against selectionMode only if current period is lunch revolving
            //Otherwise 1st 2nd lunch don't matter
            return $0.periodCategory ~=~ selectionMode
        }.first
    }
    func parseClassPeriods() -> [ClassPeriod] {
        //Will be returned for value of this variable
        var classPeriods: [ClassPeriod] = [ClassPeriod]()
        let textLines: [Substring] = scheduleText.lines
        
        //Regular expression patterns for start time, end time, and period number
        let startTimePattern: Regex = #"((0?[1-9]|1[0-2]):[0-5][0-9]-)"#.r!
        let endTimePattern: Regex = #"(-(0?[1-9]|1[0-2]):[0-5][0-9])"#.r!
        let periodPattern: Regex = #"Period \d"#.r!
        
        //Iterate over the line text itself
        //and the index of the line in entire text block
        for (line, lineNum) in zip(textLines, 0..<textLines.count) {
            guard !line.contains(String(repeating: "-", count: 20)) else {return classPeriods}
            //Use Regex to start time, end time, and period
            //Optional unwrap to make sure they exist (Might not exist because some lines do not contain schedule info)
            if let startTime: Substring = startTimePattern.findFirst(in: String(line))?.matched.dropLast(),
               let endTime: Substring = endTimePattern.findFirst(in: String(line))?.matched.dropFirst(),
               "[a-zA-Z]".r!.matches(String(line))
            {
                guard !line.contains("Office Hours") else {
                    classPeriods.append(ClassPeriod(nutritionBlock: .officeHour,
                                                    startTime: DateFormatter.formatTime12to24(startTime) ?? currentDate,
                                                    endTime: DateFormatter.formatTime12to24(endTime) ?? currentDate))
                    continue
                }
                guard let period: Character = periodPattern.findFirst(in: String(line))?.matched.last else {
                    classPeriods.append(ClassPeriod(nutritionBlock: .singleLunch,
                                                    startTime: DateFormatter.formatTime12to24(startTime) ?? currentDate,
                                                    endTime: DateFormatter.formatTime12to24(endTime) ?? currentDate))
                    continue
                }
                classPeriods.append(ClassPeriod(nutritionBlock: .period,
                                                periodNumber: Int(String(period)),
                                                startTime: DateFormatter.formatTime12to24(startTime) ?? currentDate,
                                                endTime: DateFormatter.formatTime12to24(endTime) ?? currentDate))
            }
            
            //Deal with 1st/2nd nutrition schedule case
            else if let nutritionIndex: Substring.Index = line.range(of: "Nutrition")?.lowerBound,
                    let period: Match = periodPattern.findFirst(in: String(line)) {
                
                //Find next line because current line only has label, next line contains time info
                let nextLine = String(textLines[lineNum+1])
                
                //Regex find start times and end times, convert them to array of string, dropping the dash character
                let startTimes: [String] = Array(startTimePattern.findAll(in: nextLine)).map{String($0.matched.dropLast())}
                let endTimes: [String] = Array(endTimePattern.findAll(in: nextLine)).map{String($0.matched.dropFirst())}
                
                //Total of 4 start/end times for nutrition and period revolving it
                guard let startTimeFirst: String = startTimes.first,
                      let endTimeFirst: String = endTimes.first,
                      let startTimeLast: String = startTimes.last,
                      let endTimeLast: String = endTimes.last else {continue}
                
                //nutritionIndex is location index of "nutrition" label
                //compare nutritionIndex with location of "period #" label to determine which comes 1st
                if nutritionIndex < line.range(of: period.matched)!.lowerBound {
                    classPeriods.append(ClassPeriod(nutritionBlock: .firstLunch,
                                                    startTime: DateFormatter.formatTime12to24(startTimeFirst) ?? currentDate,
                                                    endTime: DateFormatter.formatTime12to24(endTimeFirst) ?? currentDate)
                                        )
                    guard period.matched.last != nil, let periodNumber: Int = Int(String(period.matched.last!)) else {continue}
                    classPeriods.append(ClassPeriod(nutritionBlock: .secondLunchPeriod,
                                                    periodNumber: periodNumber,
                                                    startTime: DateFormatter.formatTime12to24(startTimeLast) ?? currentDate,
                                                    endTime: DateFormatter.formatTime12to24(endTimeLast) ?? currentDate)
                                       )
                                             
                }
                
                //Handles case where period # comes before nutrition
                //Reverse the start/end time order
                else {
                    classPeriods.append(ClassPeriod(nutritionBlock: .secondLunch,
                                                    startTime: DateFormatter.formatTime12to24(startTimeLast) ?? currentDate,
                                                    endTime: DateFormatter.formatTime12to24(endTimeLast) ?? currentDate)
                                        )
                    guard period.matched.last != nil, let periodNumber: Int = Int(String(period.matched.last!)) else {continue}
                    classPeriods.append(ClassPeriod(nutritionBlock: .firstLunchPeriod,
                                                    periodNumber: periodNumber,
                                                    startTime: DateFormatter.formatTime12to24(startTimeFirst) ?? currentDate,
                                                    endTime: DateFormatter.formatTime12to24(endTimeFirst) ?? currentDate)
                                       )
                                             
                }
                
            }
        }
        return classPeriods
    }
    
    static let sampleScheduleDay = ScheduleDay(id: 1, date: Date(), scheduleText: "Period 6 8:00-9:05\nPeriod 7 9:12-10:22\n(5 minutes for announcements)\nNutrition                      Period 1\n10:22-11:02                10:29-11:34\nPeriod 1                        Nutrition\n11:09-12:14                 11:34-12:14\nPeriod 2 12:21-1:26\nOffice Hours 1:33-2:30\n-------------------------------\nAP French Lang/Culture & Modern World Hist 8:00\nAP Macroeconomics 12:00\nB FS Golf vs MD 3:30\nB JV Golf @ JSerra 3:00\nB JV Tennis vs Servite 3:15\nB JV/V LAX @ JSerra 7:00/5:30\nB V Tennis @ Servite 2:30\nB V Vball @ JSerra 3:00\nG JV/V LAX @ Orange Luth 7:00/5:30\nG V Golf vs Rosary 4:30\nPossible G Soccer CIF\nSenior Graduation Ticket Distribution\n\nV Wrestling vs Aliso Niguel 1:30\n")
}


