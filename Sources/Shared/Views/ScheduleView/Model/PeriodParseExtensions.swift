//
//  PeriodParseExtensions.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/24/21.
//

import Foundation

fileprivate typealias c = Constants.Schedule

extension ScheduleDay {
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
            
            //Normal start/end time format case
            guard let startTime: Substring = c.startTimePattern.findFirst(in: String(line))?.matched.dropLast(), //Optional might be nil because some lines do not contain schedule
                  let endTime: Substring = c.endTimePattern.findFirst(in: String(line))?.matched.dropFirst(),
                  "[a-zA-Z]".r!.matches(String(line)) else
                  {
                      //Handle 1st/2nd nutrition schedule case
                      if let nutritionIndex = c.lunchPattern.findFirst(in: String(line))?.range.lowerBound,
                         let period: Match = c.periodPattern.findFirst(in: String(line)) {

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

            if c.lunchPattern.matches(String(line)) {
                //Normal lunch
                classPeriods.append(parseRegularLunchPeriodLine(line, startTime: startTime, endTime: endTime))
                continue
            }

            // Academic period case
            if c.officeHourPattern.matches(String(line)) {
                classPeriods.append(parseRegularPeriodLine(line,
                                                           startTime: startTime,
                                                           endTime: endTime,
                                                           isAcademicPeriod: true))
                continue
            }

            //Regular period
            classPeriods.append(parseRegularPeriodLine(line, startTime: startTime, endTime: endTime))
        }

        // Not the main return route!!!
        return classPeriods
    }
    
    func parseRegularLunchPeriodLine(_ line: Substring, startTime: Substring, endTime:Substring) -> ClassPeriod {
        return ClassPeriod(nutritionBlock: .singleLunch,
                           startTime: DateFormatter.formatTime12to24(startTime) ?? currentDate,
                           endTime: DateFormatter.formatTime12to24(endTime) ?? currentDate)
    }
    
    func parseRegularPeriodLine(_ line: Substring,
                                startTime: Substring,
                                endTime:Substring,
                                isAcademicPeriod: Bool = false) -> ClassPeriod {
        let startTime = DateFormatter.formatTime12to24(startTime) ?? currentDate
        let endTime = DateFormatter.formatTime12to24(endTime) ?? currentDate
        if isAcademicPeriod {
            return ClassPeriod(nutritionBlock: .officeHour, startTime: startTime, endTime: endTime)
        }
        
        guard let period: Character = c.periodPattern.findFirst(in: String(line))?.matched.last else {
            let periodTitle = line.trimmingCharacters(in: .whitespaces)
            return ClassPeriod(periodTitle,
                               startTime: startTime,
                               endTime: endTime)
        }
        return ClassPeriod(nutritionBlock: .period,
                           periodNumber: Int(String(period)),
                           startTime: startTime,
                           endTime: endTime)
    }

    func parseNutritionPeriodLines(_ textLines: [Substring],
                                   lineNum: Int,
                                   nutritionIndex: String.Index,
                                   period: Match) -> [ClassPeriod]? {
        var classPeriods = [ClassPeriod]()
        //Find next line because current line only has label, next line contains time info
        let nextLine = String(textLines[lineNum+1])
        
        //Regex find start times and end times, convert them to array of string, dropping the dash character
        let startTimes: [String] = Array(c.startTimePattern.findAll(in: nextLine)).map{String($0.matched.dropLast())}
        let endTimes: [String] = Array(c.endTimePattern.findAll(in: nextLine)).map{String($0.matched.dropFirst())}
        
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
        // Make sure remote config enabled period 8
        guard Constants.isPeriod8Enabled,
              let p8Days = Constants.period8Days,
              p8Days.contains(self.dayOfTheWeek),

              // Make sure is not school holiday
              !Constants.noSchoolIdentifier.contains(dayTitle ?? ""),

              let times = Constants.period8Times
        else { return periods }

        var periods = periods
        periods.append(.init(nutritionBlock: .period,
                             periodNumber: 8,
                             startTime: times.start,
                             endTime: times.end))
        return periods
    }
}
