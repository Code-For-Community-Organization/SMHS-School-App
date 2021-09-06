//
//  PeriodParseExtensions.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/24/21.
//

import Foundation
import Regex

extension ScheduleDay {
    //Regular expression patterns for start time, end time, and period number
    static let startTimePattern: Regex = #"((0?[1-9]|1[0-2]):[0-5][0-9]-)"#.r!
    static let endTimePattern: Regex = #"(-(0?[1-9]|1[0-2]):[0-5][0-9])"#.r!
    static let periodPattern: Regex = #"(per|period) \d+"#.r!
    static let officeHour = "office hours"
    static let lunch = "lunch"
    static let distribution = "distribution"
    
    func parseClassPeriods() -> [ClassPeriod] {
        //Will be returned for value of this variable
        var classPeriods: [ClassPeriod] = [ClassPeriod]()
        
        //Lowercase all line characters for ease of parsing
        let textLines: [Substring] = scheduleText.lines.map{Substring($0.lowercased())}
        
        //Iterate over the line text itself and its index
        for (var line, lineNum) in zip(textLines, 0..<textLines.count) {
            
            //Stop parsing garbage information (sports, after school.etc)
            guard !line.contains(String(repeating: "-", count: 20))
            
            // This is the main, most used return route!!!
            else {return classPeriods}
            
            //Normal period case
            guard let startTime: Substring = Self.startTimePattern.findFirst(in: String(line))?.matched.dropLast(), //Optional might be nil because some lines do not contain schedule
                  let endTime: Substring = Self.endTimePattern.findFirst(in: String(line))?.matched.dropFirst(),
                  "[a-zA-Z]".r!.matches(String(line)) else
            {
                var firstLunchCharIndex: Substring.Index?
                let nutritionIndex = line.range(of: "nutrition")?.lowerBound
                let alternate = line.range(of: "lunch")?.lowerBound
                firstLunchCharIndex = nutritionIndex ?? alternate

                //Handle 1st/2nd nutrition schedule case
                if let nutritionIndex: Substring.Index = firstLunchCharIndex,
                   let period: Match = Self.periodPattern.findFirst(in: String(line)) {
                    
                    let block = parseNutritionPeriodLines(textLines,
                                                          lineNum: lineNum,
                                                          nutritionIndex: nutritionIndex,
                                                          period: period)
                    classPeriods.append(contentsOf: block)
                }
                continue
            }
            
            guard let timeIndex = line.index(of: startTime) else {
                continue
            }
            line.removeSubrange(timeIndex..<line.endIndex)
            //Normal lunch
            guard line.contains(Self.lunch) else {
                //Regular period
                classPeriods.append(parseRegularPeriodLine(line, startTime: startTime, endTime: endTime))
                continue
            }
            classPeriods.append(parseRegularLunchPeriodLine(line, startTime: startTime, endTime: endTime))
            
        }

        // Not the main return route!!!
        return classPeriods
    }
    
    func parseRegularLunchPeriodLine(_ line: Substring, startTime: Substring, endTime:Substring) -> ClassPeriod {
        return ClassPeriod(nutritionBlock: .singleLunch,
                           startTime: DateFormatter.formatTime12to24(startTime) ?? currentDate,
                           endTime: DateFormatter.formatTime12to24(endTime) ?? currentDate)
    }
    
    func parseRegularPeriodLine(_ line: Substring, startTime: Substring, endTime:Substring) -> ClassPeriod {
        guard let period: Character = Self.periodPattern.findFirst(in: String(line))?.matched.last else {
            let periodTitle = line.trimmingCharacters(in: .whitespaces)
            return ClassPeriod(periodTitle,
                               startTime: DateFormatter.formatTime12to24(startTime) ?? currentDate,
                               endTime: DateFormatter.formatTime12to24(endTime) ?? currentDate)
        }
        return ClassPeriod(nutritionBlock: .period,
                           periodNumber: Int(String(period)),
                           startTime: DateFormatter.formatTime12to24(startTime) ?? currentDate,
                           endTime: DateFormatter.formatTime12to24(endTime) ?? currentDate)
    }
    
    func parseNutritionPeriodLines(_ textLines: [Substring],
                                   lineNum: Int,
                                   nutritionIndex: String.Index,
                                   period: Match) -> [ClassPeriod]? {
        var classPeriods = [ClassPeriod]()
        //Find next line because current line only has label, next line contains time info
        let nextLine = String(textLines[lineNum+1])
        
        //Regex find start times and end times, convert them to array of string, dropping the dash character
        let startTimes: [String] = Array(Self.startTimePattern.findAll(in: nextLine)).map{String($0.matched.dropLast())}
        let endTimes: [String] = Array(Self.endTimePattern.findAll(in: nextLine)).map{String($0.matched.dropFirst())}
        
        //Total of 4 start/end times for nutrition and period revolving it
        guard let startTimeFirst: String = startTimes.first,
              let endTimeFirst: String = endTimes.first,
              let startTimeLast: String = startTimes.last,
              let endTimeLast: String = endTimes.last else {return nil}
        
        //nutritionIndex is location index of "nutrition" label
        //compare nutritionIndex with location of "period #" label to determine which comes 1st
        if nutritionIndex < textLines[lineNum].range(of: period.matched)!.lowerBound {
            classPeriods.append(ClassPeriod(nutritionBlock: .firstLunch,
                                            startTime: DateFormatter.formatTime12to24(startTimeFirst) ?? currentDate,
                                            endTime: DateFormatter.formatTime12to24(endTimeFirst) ?? currentDate))
            
            guard period.matched.last != nil, let periodNumber: Int = Int(String(period.matched.last!)) else {return nil}
            classPeriods.append(ClassPeriod(nutritionBlock: .secondLunchPeriod,
                                            periodNumber: periodNumber,
                                            startTime: DateFormatter.formatTime12to24(startTimeLast) ?? currentDate,
                                            endTime: DateFormatter.formatTime12to24(endTimeLast) ?? currentDate))
            
            
        }
        
        //Handles case where period # comes before nutrition
        //Reverse the start/end time order
        else {
            classPeriods.append(ClassPeriod(nutritionBlock: .secondLunch,
                                            startTime: DateFormatter.formatTime12to24(startTimeLast) ?? currentDate,
                                            endTime: DateFormatter.formatTime12to24(endTimeLast) ?? currentDate))
            
            guard period.matched.last != nil, let periodNumber: Int = Int(String(period.matched.last!)) else {return nil}
            classPeriods.append(ClassPeriod(nutritionBlock: .firstLunchPeriod,
                                            periodNumber: periodNumber,
                                            startTime: DateFormatter.formatTime12to24(startTimeFirst) ?? currentDate,
                                            endTime: DateFormatter.formatTime12to24(endTimeFirst) ?? currentDate))
        }
        return classPeriods
    }

    func appendOptionalPeriod8(periods: [ClassPeriod]) -> [ClassPeriod] {
        debugPrint("Appending optional period 8")
        // Make sure remote config enabled period 8
        let p8Enabled = globalRemoteConfig.configValue(forKey: "eighth_period_enabled").boolValue
        guard p8Enabled else { return periods }

        // Get period 8 days of week from remote config
        let p8DaysConfig = globalRemoteConfig.configValue(forKey: "period_eight_days").jsonValue

        // Expect JSON:
        // ex. {"days": [1,3,5]} for mon, wed, fri
        // Get first of dictionary, and get its period 8 days
        if let p8DaysConfig = p8DaysConfig as? [String: Any],
           let p8Days = p8DaysConfig.first?.value {
            //Cast as dictionary, with values as days
            guard let p8DayArray = p8Days as? NSArray
            else { return periods }

            let p8DayIntArray = p8DayArray
                    .compactMap({$0 as? NSString})
                    .compactMap({$0.doubleValue})

            //Make sure today's schedule date is correct
            guard p8DayIntArray.contains(Double(self.dayOfTheWeek))
            else { return periods }

            //Get periods's start and end times from remote config
            let timesConfig = globalRemoteConfig.configValue(forKey: "period_eight_time").jsonValue
            guard let times = timesConfig as? [String: String]
            else { return periods }

            // Get start/end values from dictionary
            // Format into Date objects
            guard let startTime = DateFormatter.hourTimeFormat(times["start"] ?? ""),
                  let endTime = DateFormatter.hourTimeFormat(times["end"] ?? "")
            else { return periods }

            var periods = periods
            periods.append(.init(nutritionBlock: .period,
                                 periodNumber: 8,
                                 startTime: startTime,
                                 endTime: endTime))
            return periods
        }
        return periods
    }
}
