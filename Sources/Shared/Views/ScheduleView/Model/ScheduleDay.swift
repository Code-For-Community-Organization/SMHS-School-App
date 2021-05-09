//
//  ClassPeriod.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import Foundation
import Regex

struct ScheduleDay: Hashable, Identifiable, Codable {
    var id: Int
    var date: Date
    var scheduleText: String
    var periods: [ClassPeriod] {
        parseClassPeriods()
    }
    private var currentDateReferenceTime: Date? {Date().convertToReferenceDateLocalTime()}
    var title: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: date)
    }
    
    func getCurrentPeriodRemainingTime(selectionMode: NutritionScheduleSelection) -> TimeInterval? {
        if let endTime = getCurrentPeriod(selectionMode: selectionMode)?.endTime, 
           let reference = currentDateReferenceTime {
            return endTime - reference
        }
        return nil
    }
    
    func getCurrentPeriodRemainingPercent(selectionMode: NutritionScheduleSelection) -> Double? {
        if let endTime = getCurrentPeriod(selectionMode: selectionMode)?.endTime,
           let startTime = getCurrentPeriod(selectionMode: selectionMode)?.startTime,
           let timeRemaining = getCurrentPeriodRemainingTime(selectionMode: selectionMode) {
            let totalTime = endTime - startTime
            return timeRemaining / totalTime
        }
        return nil
    }
    
    func getCurrentPeriod(selectionMode: NutritionScheduleSelection) -> ClassPeriod? {
        //Filter for periods that are possible as current period
        //Current time within period start/end time
        let current = periods.filter{currentDateReferenceTime?.isBetween($0.startTime, and: $0.endTime) ?? false}
        
        guard current.count > 1 else {return current.last}
        switch selectionMode {
        case .firstLunch:
            return current.first
        case .secondLunch:
            return current.last
        }
    }
    func parseClassPeriods() -> [ClassPeriod] {
        //Will be returned for value of this variable
        var classPeriods: [ClassPeriod] = [ClassPeriod]()
        let textLines = scheduleText.lines
        
        //Regular expression patterns for start time, end time, and period number
        let startTimePattern = #"((0?[1-9]|1[0-2]):[0-5][0-9]-)"#.r!
        let endTimePattern = #"(-(0?[1-9]|1[0-2]):[0-5][0-9])"#.r!
        let periodPattern = #"Period \d"#.r!
        

        
        //Iterate over the line text itself
        //and the index of the line in entire text block
        for (line, lineNum) in zip(textLines, 0..<textLines.count) {
            
            //Use Regex to start time, end time, and period
            //Optional unwrap to make sure they exist (Might not exist because some lines do not contain schedule info)
            if let startTime: Substring = startTimePattern.findFirst(in: String(line))?.matched.dropLast(),
               let endTime: Substring = endTimePattern.findFirst(in: String(line))?.matched.dropFirst(),
               let period: Character = periodPattern.findFirst(in: String(line))?.matched.last {
                classPeriods.append(ClassPeriod(periodNumber: Int(String(period)),
                                                startTime: DateFormatter.formatTime12to24(startTime) ?? Date(), 
                                                endTime: DateFormatter.formatTime12to24(endTime) ?? Date()))
            }
            
            //Deal with nutrition schedule case
            else if let nutritionIndex = line.range(of: "Nutrition")?.lowerBound,
                    let period = periodPattern.findFirst(in: String(line)) {
                
                //Find next line because current line only has label, next line contains time info
                let nextLine = String(textLines[lineNum+1])
                
                //Regex find start times and end times, convert them to array of string, dropping the dash character
                let startTimes: [String] = Array(startTimePattern.findAll(in: nextLine)).map{String($0.matched.dropLast())}
                let endTimes: [String] = Array(endTimePattern.findAll(in: nextLine)).map{String($0.matched.dropFirst())}
                
                //Total of 4 start/end times for nutrition and period revolving it
                guard let startTimeFirst: String = startTimes.first,
                      let endTimeFirst: String = endTimes.first,
                      let startTimeLast: String = startTimes.last,
                      let endTimeLast: String = endTimes.first else {continue}
                
                //nutritionIndex is location index of "nutrition" label
                //compare nutritionIndex with location of "period #" label to determine which comes 1st
                if nutritionIndex < line.range(of: period.matched)!.lowerBound {
                    classPeriods.append(ClassPeriod(periodNumber: nil,
                                                    startTime: DateFormatter.formatTime12to24(startTimeFirst) ?? Date(),
                                                    endTime: DateFormatter.formatTime12to24(endTimeFirst) ?? Date())
                                        )
                    guard period.matched.last != nil, let periodNumber: Int = Int(String(period.matched.last!)) else {continue}
                    classPeriods.append(ClassPeriod(periodNumber: periodNumber,
                                                    startTime: DateFormatter.formatTime12to24(startTimeLast) ?? Date(),
                                                    endTime: DateFormatter.formatTime12to24(endTimeLast) ?? Date())
                                       )
                                             
                }
                
                //Handles case where period # comes before nutrition
                //Reverse the start/end time order
                else {
                    classPeriods.append(ClassPeriod(periodNumber: nil,
                                                         startTime: DateFormatter.formatTime12to24(startTimeLast) ?? Date(),
                                                         endTime: DateFormatter.formatTime12to24(endTimeLast) ?? Date())
                                        )
                    guard period.matched.last != nil, let periodNumber: Int = Int(String(period.matched.last!)) else {continue}
                    classPeriods.append(ClassPeriod(periodNumber: periodNumber,
                                                    startTime: DateFormatter.formatTime12to24(startTimeFirst) ?? Date(),
                                                    endTime: DateFormatter.formatTime12to24(endTimeFirst) ?? Date())
                                       )
                                             
                }
                
            }
        }
        return classPeriods
    }
}

struct ClassPeriod: Hashable, Codable  {
    var periodNumber: Int?
    var startTime: Date
    var endTime: Date
}

